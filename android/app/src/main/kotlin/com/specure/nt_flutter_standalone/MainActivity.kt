package com.specure.nt_flutter_standalone

import android.Manifest.permission.ACCESS_COARSE_LOCATION
import android.Manifest.permission.ACCESS_FINE_LOCATION
import android.content.ComponentName
import android.content.Context
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import android.net.ConnectivityManager
import android.os.*
import androidx.annotation.RequiresApi
import at.rtr.rmbt.client.helper.Config
import at.rtr.rmbt.client.helper.IntermediateResult
import at.rtr.rmbt.client.helper.TestStatus
import at.rtr.rmbt.client.v2.task.result.QoSTestResultEnum
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.specure.nt_flutter_standalone.models.*
import com.specure.nt_flutter_standalone.net_neutrality.dns.DnsServersDetector
import com.specure.nt_flutter_standalone.net_neutrality.dns.DnsTest
import com.specure.nt_flutter_standalone.service.measurement.MeasurementService
import com.specure.nt_flutter_standalone.service.measurement.TestProgressListener
import com.specure.nt_flutter_standalone.utils.client_uuid.ClientUuidMigrator
import com.specure.nt_flutter_standalone.utils.permission.LocationAccessImpl
import com.specure.nt_flutter_standalone.utils.permission.PhoneStateAccessImpl
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.sentry.Sentry
import timber.log.Timber
import java.net.InetAddress

private const val MEASUREMENT_CHANNEL = "nettest/measurements"
private const val PERMISSIONS_INFO_CHANNEL = "nettest/permissions"
private const val PREFERENCES_CHANNEL = "nettest/preferences"
private const val DNS_TEST_CHANNEL = "nettest/dnsTest"
private const val LOCATION_CHANNEL = "nettest/location"

private const val PERMISSIONS_CHECKED_BUNDLE_KEY = "PERMISSIONS_CHECKED_BUNDLE_KEY"

private const val TEST_STARTED_MESSAGE = "TEST_STARTED"
private const val TEST_STOPPED_MESSAGE = "TEST_STOPPED"

class MainActivity : FlutterActivity() {
    private lateinit var permissionsInfoChannel: MethodChannel
    private lateinit var measurementMethodChannel: MethodChannel
    private lateinit var preferencesMethodChannel: MethodChannel
    private lateinit var dnsTestMethodChannel: MethodChannel
    private lateinit var locationMethodChannel: MethodChannel

    private val gson = Gson()
    private var lastMeasurementState = MeasurementState.IDLE
    private var permissionsChecked = false
    private var isMeasurementServiceBound = false
    private var measurementBinder: MeasurementService.MeasurementServiceBinder? = null
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState != null) {
            permissionsChecked = savedInstanceState.getBoolean(PERMISSIONS_CHECKED_BUNDLE_KEY)
        }
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP_MR1)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        permissionsInfoChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERMISSIONS_INFO_CHANNEL)
        measurementMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MEASUREMENT_CHANNEL)
        preferencesMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PREFERENCES_CHANNEL)
        dnsTestMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DNS_TEST_CHANNEL)
        locationMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LOCATION_CHANNEL)

        permissionsInfoChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getPermissionState" -> getPermissionState(result)
                else -> result.notImplemented()
            }
        }

        locationMethodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "isLocationServiceEnabled" -> {
                    val locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
                    result.success(locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER))
                }
                "getLatestLocation" -> {
                    val coarseLocationAccess = context.checkSelfPermission(ACCESS_COARSE_LOCATION)
                    val fineLocationAccess = context.checkSelfPermission(ACCESS_FINE_LOCATION)
                    if (coarseLocationAccess != PackageManager.PERMISSION_GRANTED
                        && fineLocationAccess != PackageManager.PERMISSION_GRANTED) {
                        result.success(null)
                        return@setMethodCallHandler
                    }
                    fusedLocationClient.lastLocation
                        .addOnSuccessListener { location : Location? ->
                            if (location == null) {
                                result.success(null)
                            } else {
                                val map = mapOf(
                                    Pair("lat", location.latitude),
                                    Pair("long", location.longitude)
                                )
                                result.success(gson.toJson(map))
                            }
                        }
                }
                else -> result.notImplemented()
            }
        }

        measurementMethodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startTest" -> {
                    startService(
                        call.argument("appVersion")!!,
                        call.argument("flavor")!!,
                        call.argument("clientUUID")!!,
                        call.argument("location")!!,
                        call.argument("measurementServer"),
                        call.argument("telephonyPermissionGranted"),
                        call.argument("locationPermissionGranted"),
                        call.argument("uuidPermissionGranted"),
                        call.argument("loopModeSettings"),
                        call.argument<ArrayList<Double>>("pingsNs"),
                        call.argument<Double>("jitterNs"),
                        call.argument<Double>("packetLoss"),
                        call.argument<Double>("testStartNs"),
                    )
                    result.success(TEST_STARTED_MESSAGE)
                }
                "stopTest" -> {
                    MeasurementService.stopTests(this@MainActivity.applicationContext)
                    result.success(TEST_STOPPED_MESSAGE)
                }
                else -> result.notImplemented()
            }
        }

        preferencesMethodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getClientUuid" -> result.success(ClientUuidMigrator(context).getClientUuid())
                "removeClientUuid" -> {
                    ClientUuidMigrator(context).removeClientUuid()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        dnsTestMethodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startDnsTest" -> {
                    var server: String? = null
                    try {
                        server = getDnsServer() ?: DnsServersDetector(context).servers[0]
                    } catch (e: Exception) {
                        val ex = Exception("Error during determining default dns server: $e")
                        Timber.e(ex)
                    }
                    if (server == null) {
                        val ex = Exception("Unable to detect default DNS server")
                        Sentry.captureException(ex)
                    }
                    startDnsTest(
                        call.argument("resolver") ?: server,
                        call.argument("target")!!,
                        call.argument("timeout"),
                        call.argument("entryType"),
                        result
                    )
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getPermissionState(result: MethodChannel.Result) {
        val permissions = checkPermissions()
        val json = gson.toJson(permissions, PermissionState::class.java)
        val response: Map<String?, String?> = gson.fromJson(json, object : TypeToken<Map<String?, String?>?>() {}.type)
        result.success(response)
    }

    private fun checkPermissions(): PermissionState {
        val readPhoneStatePermitted = PhoneStateAccessImpl(this).isAllowed
        var locationAccess = LocationAccessImpl(this)
        val locationPermissionsPermitted = locationAccess.isAllowed
        val preciseLocationPermissionsPermitted = locationAccess.isPreciseLocationAllowed
        return PermissionState(permissionsChecked, locationPermissionsPermitted, preciseLocationPermissionsPermitted, readPhoneStatePermitted)
    }

    private fun startService(appVersion: String,
                             flavor: String,
                             clientUUID: String,
                             location: Map<String, Any?>,
                             measurementServer: Map<String, Any?>?,
                             telephonyPermissionGranted: Boolean?,
                             locationPermissionGranted: Boolean?,
                             uuidPermissionGranted: Boolean?,
                             loopModeSettings: Map<String, Any?>?,
                             externalPings: ArrayList<Double>?,
                             externalJitter: Double?,
                             externalPacketLoss: Double?,
                             externalTestStart: Double?
    ) {
        if (isMeasurementServiceBound) {
            context.unbindService(measurementServiceConnection)
        }

        val parsedMS = measurementServer?.let { ms ->
            TargetMeasurementServer(
                ms["encrypted"] as Boolean,
                ms["port"] as Int,
                ms["webAddress"] as String,
                ms["id"] as Int,
                ms["serverType"] as String
            )
        }

        val parsedLoopModeSettings = loopModeSettings?.let { settings ->
            LoopModeSettings(
                settings["max_delay"] as Int,
                settings["max_movement"] as Int,
                settings["max_tests"] as Int,
                settings["test_counter"] as Int,
                settings["loop_uuid"] as String?,
            )
        }

        MeasurementService.startTests(
            this@MainActivity.applicationContext, appVersion, flavor, clientUUID, location, parsedMS,
            telephonyPermissionGranted ?: false,
            locationPermissionGranted ?: false,
            uuidPermissionGranted ?: false,
            parsedLoopModeSettings,
            externalPings?.toDoubleArray() ?: doubleArrayOf(),
            externalJitter ?: 0.0,
            externalPacketLoss ?: 0.0,
            externalTestStart ?: 0.0
        )
        context.bindService(
            MeasurementService.intent(context), measurementServiceConnection, Context.BIND_AUTO_CREATE)
    }

    private fun startDnsTest(resolver: String?, host: String, timeoutSeconds: Int?, addressType: String?, result: MethodChannel.Result) {
        val test = DnsTest(resolver, host, timeoutSeconds, addressType)
        test.execute(result)
    }

    override fun onSaveInstanceState(outState: Bundle, outPersistentState: PersistableBundle) {
        super.onSaveInstanceState(outState, outPersistentState)
        outState.putBoolean(PERMISSIONS_CHECKED_BUNDLE_KEY, permissionsChecked)
    }

    override fun onPostResume() {
        super.onPostResume()
        Timber.d("MainActivity -> onPostResume()")
        // TODO: save previous permissions state to state maybe to compare them and notify only in the case of the real change
        notifyAboutChangedPermissions()
        context.bindService(MeasurementService.intent(context), measurementServiceConnection, Context.BIND_AUTO_CREATE)
    }

    private fun notifyAboutChangedPermissions() {
        Handler(Looper.getMainLooper()).postDelayed({
            val readPhoneStatePermitted = PhoneStateAccessImpl(this).isAllowed
            val locationAccess = LocationAccessImpl(this)
            val locationPermissionsPermitted = locationAccess.isAllowed
            val preciseLocationPermissionsPermitted = locationAccess.isPreciseLocationAllowed
            permissionsInfoChannel.invokeMethod("permissionsChanged", mapOf(
                Pair("permissionsChecked", "true"),
                Pair("locationPermissionsGranted", locationPermissionsPermitted),
                Pair("readPhoneStatePermissionsGranted", readPhoneStatePermitted),
                Pair("preciseLocationPermissionsGranted", preciseLocationPermissionsPermitted)
            ), object : MethodChannel.Result {
                override fun success(o: Any?) = Timber.d("permissionsChange ${o.toString()}")
                override fun error(s: String, s1: String?, o: Any?) {}
                override fun notImplemented() {}
            })
        },1000L)
    }

    override fun onPause() {
        super.onPause()
        if (measurementServiceConnection.bound) {
            this.unbindService(measurementServiceConnection)
        }
    }

    private val testProgressCallback = object : TestProgressListener {

        private fun sendValueToFlutter(state: MeasurementState, value: Any) {
            if (lastMeasurementState == state) {
                Handler(Looper.getMainLooper()).post {
                    measurementMethodChannel.invokeMethod(
                        "speedMeasurementDidMeasureSpeed",
                        mapOf(
                            Pair("phase", lastMeasurementState.toFlutterMeasurementState()),
                            Pair("result", value)
                        )
                    )
                }
            }
        }

        private fun sendProgressToFlutter(state: MeasurementState, progress: Any) {
            if (lastMeasurementState == state) {
                Handler(Looper.getMainLooper()).post {
                    measurementMethodChannel.invokeMethod(
                        "speedMeasurementDidUpdateWith",
                        mapOf(
                            Pair("phase", lastMeasurementState.toFlutterMeasurementState()),
                            Pair("progress", progress)
                        )
                    )
                }
            }
        }

        private fun sendClientReady(testUuid: String?, loopUuid: String?) {
            Handler(Looper.getMainLooper()).post {
                measurementMethodChannel.invokeMethod(
                    "measurementRequestSent",
                    mapOf(
                        Pair("testUuid", testUuid),
                        Pair("loopUuid", loopUuid)
                    )
                )
            }
        }

        private fun sendFinalResultToFlutter(state: MeasurementState, value: Double) {
            Handler(Looper.getMainLooper()).post {
                Timber.e("speedMeasurementPhaseFinalResult phase: ${state.toFlutterMeasurementState()}  value: $value")
                measurementMethodChannel.invokeMethod(
                    "speedMeasurementPhaseFinalResult",
                    mapOf(
                        Pair("phase", state.toFlutterMeasurementState()),
                        Pair("finalResult", value)
                    )
                )
            }
        }

        override fun onProgressChanged(state: MeasurementState, progress: Int) {
            lastMeasurementState = state
            Handler(Looper.getMainLooper()).post {
                measurementMethodChannel.invokeMethod(
                    "speedMeasurementDidStartPhase",
                    mapOf(Pair("phase", state.toFlutterMeasurementState()))
                )
            }
            Timber.d("Client test status changed: $state progress: $progress")
        }

        override fun onPingChanged(pingProgress: Float) {
            sendProgressToFlutter(MeasurementState.PING, pingProgress)
            Timber.d("Client ping progress changed: PING: $pingProgress")
        }

        override fun onJitterChanged(jitterProgress: Float) {
            sendProgressToFlutter(MeasurementState.JITTER, jitterProgress)
            Timber.d("Client jitter progress changed: $jitterProgress")
        }

        override fun onPacketLossChanged(packetLossPercent: Int) {
            sendProgressToFlutter(MeasurementState.PACKET_LOSS, packetLossPercent)
            Timber.d("Client packet loss changed: $packetLossPercent")
        }

        override fun onDownloadSpeedChanged(progress: Int, speedBps: Long) {
            sendValueToFlutter(MeasurementState.DOWNLOAD, (speedBps / 1000).toDouble())
            Timber.d("Client download speed data changed: $progress  $speedBps $lastMeasurementState")
        }

        override fun onUploadSpeedChanged(progress: Int, speedBps: Long) {
            sendValueToFlutter(MeasurementState.UPLOAD, (speedBps / 1000).toDouble())
            Timber.d("Client upload speed data changed: $progress  $speedBps")
        }

        @RequiresApi(Build.VERSION_CODES.LOLLIPOP_MR1)
        override fun onCompleted(result: MeasurementTestResult) {
            Timber.d("Test completed")
            Handler(Looper.getMainLooper()).post {
                val arguments = result.toMap()
                measurementMethodChannel.invokeMethod("measurementComplete", arguments)
            }
        }

        override fun onPhaseFinished(phase: TestStatus, result: IntermediateResult) {
            when (phase) {
                TestStatus.PING -> {
                    if (result.pingNano.toDouble() > 0.0) {
                        sendFinalResultToFlutter(MeasurementState.PING, result.pingNano.toDouble())
                    }
                }
                TestStatus.PACKET_LOSS_AND_JITTER -> {
                    if (result.jitter.toDouble() > 0.0) {
                        sendFinalResultToFlutter(MeasurementState.JITTER, result.jitter.toDouble())
                    }
                    val packetLoss = (result.packetLossDown + result.packetLossUp).toFloat()/2f.toDouble()
                    sendFinalResultToFlutter(MeasurementState.PACKET_LOSS, packetLoss)
                }
                TestStatus.DOWN -> {
                    if (result.downBitPerSec.toDouble() > 0.0) {
                        sendFinalResultToFlutter(MeasurementState.DOWNLOAD, (result.downBitPerSec / 1000f).toDouble())
                    }
                }
                TestStatus.UP -> {
                    if (result.upBitPerSec.toDouble() > 0.0) {
                        sendFinalResultToFlutter(MeasurementState.UPLOAD, (result.upBitPerSec / 1000f).toDouble())
                    }
                }
                else -> return
            }
        }

        override fun onFinish() {
            Timber.d("Test finished")
        }

        override fun onPostFinish() {
            Timber.d("Test post-finished")
            MeasurementService.stopTestsIntent(this@MainActivity.applicationContext)
            measurementMethodChannel.invokeMethod("measurementPostFinish", null)
        }

        override fun onError(errorMsg: String) {
            Timber.e("Test error: $errorMsg")
            Handler(Looper.getMainLooper()).post {
                measurementMethodChannel.invokeMethod("measurementDidFail", errorMsg)
            }
        }

        override fun onClientReady(testUUID: String?, loopUUID: String?, loopLocalUUID: String?, testStartTimeNanos: Long) {
            sendClientReady(testUUID, loopUUID)
            Timber.d("Client is ready: $testUUID and  loop UUID: $loopUUID")
        }

        override fun onQoSTestProgressUpdate(tasksPassed: Int, tasksTotal: Int, progressMap: Map<QoSTestResultEnum, Int>) {
            TODO("Not yet implemented")
        }
    }

    private val measurementServiceConnection = object : ServiceConnection {
        var bound = false

        override fun onServiceConnected(componentName: ComponentName, binder: IBinder) {
            isMeasurementServiceBound = true
            Timber.e("Service connected")
            if (binder is MeasurementService.MeasurementServiceBinder) {
                measurementBinder = binder
                binder.setTestListener(testProgressCallback)
                val testIsRunning = isTestRunning()
                Timber.d("IS TEST RUNNING? bind: $testIsRunning")
            }
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            measurementBinder = null
            isMeasurementServiceBound = false
            Timber.d("Service disconnected")
        }

        override fun onBindingDied(name: ComponentName?) {
            super.onBindingDied(name)
            isMeasurementServiceBound = false
            measurementBinder = null
        }

        override fun onNullBinding(name: ComponentName?) {
            super.onNullBinding(name)
            isMeasurementServiceBound = false
            measurementBinder = null
        }
    }

    private fun isTestRunning(): Boolean =
        isMeasurementServiceBound && measurementBinder?.isTestRunning() == true

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    private fun getDnsServer(): String? {
        val cm: ConnectivityManager = context.getSystemService(ConnectivityManager::class.java)
        val servers = mutableListOf<InetAddress>()
        val networks = arrayOf(cm.activeNetwork)
        for (i in networks.indices) {
            val linkProperties = cm.getLinkProperties(networks[i])
            if (linkProperties != null) {
                servers.addAll(linkProperties.dnsServers)
            }
        }
        val serverAddress = if (servers.isNotEmpty()) {
            servers[0].hostAddress
        } else {
            null
        }
        return serverAddress
    }
}