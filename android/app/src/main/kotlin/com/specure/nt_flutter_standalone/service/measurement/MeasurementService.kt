package com.specure.nt_flutter_standalone.service.measurement

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Binder
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import at.rtr.rmbt.client.RMBTClient
import at.rtr.rmbt.client.RMBTClientCallback
import at.rtr.rmbt.client.TotalTestResult
import at.rtr.rmbt.client.helper.IntermediateResult
import at.rtr.rmbt.client.helper.TestStatus
import at.rtr.rmbt.client.v2.task.result.QoSResultCollector
import at.rtr.rmbt.util.model.shared.exception.ErrorStatus
import com.google.gson.Gson
import com.specure.nt_flutter_standalone.MainActivity
import com.specure.nt_flutter_standalone.R
import com.specure.nt_flutter_standalone.models.LocationModel
import com.specure.nt_flutter_standalone.models.LoopModeSettings
import com.specure.nt_flutter_standalone.models.MeasurementState
import com.specure.nt_flutter_standalone.models.MeasurementTestResult
import com.specure.nt_flutter_standalone.models.SignalMeasurementType
import com.specure.nt_flutter_standalone.models.TargetMeasurementServer
import com.specure.nt_flutter_standalone.service.CustomLifecycleService
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.async
import kotlinx.coroutines.delay
import org.json.JSONObject
import timber.log.Timber
import java.util.*

private const val KEY_MEASUREMENT_TYPE = "measurement_type_flag" // used on the control server to determine type for signal measurement
private const val CLIENT_UUID_EXTRA = "clientUUID"
private const val APP_VERSION_EXTRA = "app_version"
private const val FLAVOR_EXTRA = "flavor"
private const val LOCATION_EXTRA = "location"
private const val LOOP_MODE_SETTINGS_EXTRA = "loop_mode_settings"
private const val KEY_MEASUREMENT_SERVER_PREFERRED = "prefer_server"
private const val MEASUREMENT_SERVER_EXTRA = "measurementServer"
private const val PINGS_EXTRA = "externalPings"
private const val JITTER_EXTRA = "externalJitter"
private const val PACKET_LOSS_EXTRA = "externalPacketLoss"
private const val TEST_START_EXTRA = "externalTestStart"
private const val TELEPHONY_PERMISSION_GRANTED = "telephony_permission_granted"
private const val LOCATION_PERMISSION_GRANTED = "location_permission_granted"
private const val UUID_PERMISSION_GRANTED = "uuid_permission_granted"
private const val NOTIFICATION_PERMISSION_GRANTED = "notification_permission_granted"
private const val KEY_LOOP_MODE_ENABLED = "user_loop_mode"
private const val KEY_LOOP_MODE_SETTINGS = "loopmode_info"

private const val CLIENT_NAME = "RMBT"
private const val CLIENT_TYPE = "MOBILE"
private const val CLIENT_VERSION = "1"
private const val PATH_PREFIX = "mobile"
private const val NOTIFICATION_ID = 101

private const val SKIP_QOS_TESTS = true

class MeasurementService : CustomLifecycleService() {
    private var rmbtClient: RMBTClient? = null
    private val binder = MeasurementServiceBinder()
    private var testProgressListener: TestProgressListener? = null
    private val result: IntermediateResult by lazy { IntermediateResult() }

    private lateinit var host: String
    private lateinit var appVersion: String
    private lateinit var clientUUID: String
    private lateinit var flavor: String
    private var geoLocation: LocationModel? = null
    private var measurementServer: TargetMeasurementServer? = null
    private var externalPings: DoubleArray = doubleArrayOf()
    private var externalJitter: Double = 0.0
    private var externalPacketLoss: Double = 0.0
    private var externalTestStart: Double = 0.0
    private var telephonyPermissionGranted: Boolean = false
    private var locationPermissionGranted: Boolean = false
    private var notificationPermissionGranted: Boolean = false
    private var uuidPermissionGranted: Boolean = false
    private var loopModeConfig: LoopModeSettings? = null

    //TODO pass this as a settings from Flutter
    private val port = 443

    private var clientJob: Job? = null
    private var measurementJob: Job? = null

    private var previousDownloadProgress = -1
    private var previousUploadProgress = -1
    private var finalDownloadValuePosted = false
    private var finalUploadValuePosted = false
    private var isTestRunning = false

    private fun getRMBTClientInstance() = RMBTClient.getInstance(
        host,
        PATH_PREFIX,
        port,
        true,
        arrayListOf(
            Date().time.toString(),
            geoLocation?.latitude?.toString(),
            geoLocation?.longitude?.toString(),
            geoLocation?.city,
            geoLocation?.country,
            geoLocation?.county,
            geoLocation?.postalCode
        ),
        clientUUID,
        CLIENT_TYPE,
        CLIENT_NAME,
        CLIENT_VERSION,
        null,
        JSONObject().apply {
            put(KEY_MEASUREMENT_TYPE, SignalMeasurementType.REGULAR.signalTypeName)
            if (measurementServer != null && measurementServer!!.id >= 0) {
                put(KEY_MEASUREMENT_SERVER_PREFERRED, measurementServer!!.id)
                put("user_server_selection", true)
                put(
                    MEASUREMENT_SERVER_EXTRA,
                    JSONObject(
                        Gson().toJson(measurementServer, TargetMeasurementServer::class.java),
                    ),
                )
            }
            put(TELEPHONY_PERMISSION_GRANTED, telephonyPermissionGranted)
            put(LOCATION_PERMISSION_GRANTED, locationPermissionGranted)
            put(NOTIFICATION_PERMISSION_GRANTED, notificationPermissionGranted)
            put(UUID_PERMISSION_GRANTED, uuidPermissionGranted)
            put(APP_VERSION_EXTRA, appVersion)
            if (loopModeConfig != null) {
                put(KEY_LOOP_MODE_ENABLED, true)
                put(KEY_LOOP_MODE_SETTINGS, JSONObject(Gson().toJson(loopModeConfig, LoopModeSettings::class.java)))
            }
            put(PINGS_EXTRA, externalPings)
            put(JITTER_EXTRA, externalJitter)
            put(PACKET_LOSS_EXTRA, externalPacketLoss)
            put(TEST_START_EXTRA, externalTestStart)
        },
        flavor,
        this@MeasurementService.applicationContext.cacheDir,
        mutableSetOf<ErrorStatus>(),
    )

    private fun TestStatus.isFinalState(skipQoSTest: Boolean) = this == TestStatus.ABORTED ||
            this == TestStatus.END ||
            this == TestStatus.ERROR ||
            (this == TestStatus.SPEEDTEST_END && skipQoSTest) ||
            this == TestStatus.QOS_END

    private val rmbtClientCallback: RMBTClientCallback = object : RMBTClientCallback {
        override fun onClientReady(testUUID: String?, loopUUID: String?, testToken: String?, testStartTimeNanos: Long, threadNumber: Int) {
            testProgressListener?.onClientReady(testUUID, loopUUID, null, System.nanoTime())
            Timber.d("Client is ready, test UUID: $testUUID , loop UUID: $loopUUID")
        }
        override fun onSpeedDataChanged(threadId: Int, bytes: Long, timestampNanos: Long, isUpload: Boolean) {
            Timber.d("Client speed data changed: $threadId  $bytes $timestampNanos $isUpload")
        }
        override fun onPingDataChanged(clientPing: Long, serverPing: Long, timeNs: Long) {
            Timber.d("Client ping data changed: $clientPing $serverPing $timeNs")
        }

        @RequiresApi(Build.VERSION_CODES.ECLAIR)
        override fun onTestCompleted(result: TotalTestResult?, waitQoSResults: Boolean) {
            Timber.e(" RESULTS: $result WAIT FOR QOS: $waitQoSResults")
            if (!waitQoSResults) {
                Timber.e(" TEST COMPLETED: $result")
                isTestRunning = false
                testProgressListener?.onFinish()
                Handler(Looper.getMainLooper()).postDelayed({
                    this@MeasurementService.stopForeground(true)
                }, 2000)
            }
        }

        override fun onQoSTestCompleted(qosResult: QoSResultCollector?) {
            Timber.e(" QOS TEST COMPLETED")
        }
        override fun onTestStatusUpdate(status: TestStatus?) {
            Timber.d("Client test status changed: ${status?.toString()}")
            val phaseFinished = when (status) {
                TestStatus.PACKET_LOSS_AND_JITTER -> TestStatus.PING
                TestStatus.DOWN -> TestStatus.INIT
                TestStatus.INIT_UP -> TestStatus.DOWN
                TestStatus.SPEEDTEST_END -> TestStatus.UP
                else -> null
            }
            phaseFinished?.let {
                testProgressListener?.onPhaseFinished(phaseFinished, result)
            }
        }
    }

    private fun setState(state: MeasurementState, progress: Int) {
        testProgressListener?.onProgressChanged(state, progress)
    }

    override fun onBind(intent: Intent?): IBinder {
        super.onBind(intent)
        return binder
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Timber.d("MeasurementService: onStartCommand ${intent?.action}")
        if (intent != null) {
            showForegroundNotificationForAndroidO()
            host = resources.getString(R.string.control_server_url)
            appVersion = intent.getStringExtra(APP_VERSION_EXTRA) ?: ""
            clientUUID = intent.getStringExtra(CLIENT_UUID_EXTRA) ?: ""
            flavor = intent.getStringExtra(FLAVOR_EXTRA) ?: "nt"
            geoLocation = intent.getParcelableExtra(LOCATION_EXTRA)
            val loopModeConfigJson = intent.getStringExtra(LOOP_MODE_SETTINGS_EXTRA)
            if (loopModeConfigJson != null) {
                loopModeConfig = Gson().fromJson(loopModeConfigJson, LoopModeSettings::class.java)
            }
            val measurementServerJson = intent.getStringExtra(MEASUREMENT_SERVER_EXTRA)
            if (measurementServerJson != null) {
                measurementServer = Gson().fromJson(measurementServerJson, TargetMeasurementServer::class.java)
            }
            telephonyPermissionGranted = intent.getBooleanExtra(TELEPHONY_PERMISSION_GRANTED, false)
            locationPermissionGranted = intent.getBooleanExtra(LOCATION_PERMISSION_GRANTED, false)
            notificationPermissionGranted = intent.getBooleanExtra(NOTIFICATION_PERMISSION_GRANTED, false)
            uuidPermissionGranted = intent.getBooleanExtra(UUID_PERMISSION_GRANTED, false)
            externalPings = intent.getDoubleArrayExtra(PINGS_EXTRA) ?: doubleArrayOf()
            externalJitter = intent.getDoubleExtra(JITTER_EXTRA, 0.0)
            externalPacketLoss = intent.getDoubleExtra(PACKET_LOSS_EXTRA, 0.0)
            externalTestStart = intent.getDoubleExtra(TEST_START_EXTRA, 0.0)
            println("Measurement Server id: ${measurementServer?.id}")
            when (intent.action) {
                ACTION_START_TEST -> startTest()
                ACTION_STOP_TEST -> stopTest()
            }
        }
        return super.onStartCommand(intent, flags, startId)
    }

    private fun showForegroundNotificationForAndroidO() {
        val actionIntent = PendingIntent.getService(this@MeasurementService, 0, stopTestsIntent(this@MeasurementService), PendingIntent.FLAG_IMMUTABLE)
        val action = NotificationCompat.Action.Builder(0, "Cancel measurement", actionIntent).build()
        val contentIntent = PendingIntent.getActivity(this@MeasurementService, 0, Intent(this@MeasurementService, MainActivity::class.java), PendingIntent.FLAG_IMMUTABLE)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notification = NotificationCompat.Builder(this, "measurement")
                .setContentText("Measurement is running...")
                .setContentTitle("Measurement")
                .setContentIntent(contentIntent)
                .setSmallIcon(android.R.drawable.ic_media_play)
                .addAction(action)
                .build()

            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                startForeground(NOTIFICATION_ID, notification)
            } else {
                startForeground(NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE)
            }
        }
    }

    private fun startTest() {
        clientJob = GlobalScope.async {
            previousDownloadProgress = -1
            previousUploadProgress = -1
            finalDownloadValuePosted = false
            finalUploadValuePosted = false

            setState(MeasurementState.INIT, 0)
            rmbtClient = getRMBTClientInstance()
            Timber.e("startTest() -> Is rmbtClient null: ${rmbtClient == null}")
            rmbtClient?.let { client ->
                client.commonCallback = rmbtClientCallback
                runMeasurementJob()
                isTestRunning = true
                var currentStatus = TestStatus.WAIT
                while (!currentStatus.isFinalState(SKIP_QOS_TESTS)) {
                    currentStatus = client.status
                    Timber.v(currentStatus.name)
                    rmbtClientCallback.onTestStatusUpdate(currentStatus)
                    handleCurrentStatus(currentStatus, client)
                    if (currentStatus.isFinalState(SKIP_QOS_TESTS)) {
                        handleFinalState(client, currentStatus)
                    } else {
                        delay(100)
                    }
                }
            }
        }
    }

    private fun runMeasurementJob() {
        measurementJob = GlobalScope.async {
            @Suppress("BlockingMethodInNonBlockingContext")
            val result = rmbtClient?.runTest()
            testProgressListener?.onCompleted(MeasurementTestResult(
                result!!,
                rmbtClient?.controlConnection?.clientUUID!!,
                CLIENT_NAME,
                rmbtClient?.controlConnection?.testToken!!
            ))
            rmbtClientCallback.onTestCompleted(result, !SKIP_QOS_TESTS)
        }
    }

    private fun handleCurrentStatus(currentStatus: TestStatus, client: RMBTClient) {
        when (currentStatus) {
            TestStatus.WAIT -> handleWaitStatus()
            TestStatus.INIT -> handleInitStatus(client)
            TestStatus.PING -> handlePingStatus(client)
            TestStatus.DOWN -> handleDownloadStatus(client)
            TestStatus.PACKET_LOSS_AND_JITTER -> handleJitterAndPacketLossStatus(client)
            TestStatus.INIT_UP -> handleInitUploadStatus()
            TestStatus.UP -> handleUploadStatus(client)
            TestStatus.SPEEDTEST_END -> handleSpeedTestEndStatus()
            TestStatus.ERROR -> handleErrorStatus(client)
            TestStatus.END -> handleEndStatus()
            TestStatus.ABORTED -> handleAbortStatus()
            TestStatus.QOS_TEST_RUNNING -> {} //handleQoSRunning(qosTest)
            TestStatus.QOS_END -> {} //handleQoSEnd()
        }
    }

    private fun handleFinalState(client: RMBTClient, currentStatus: TestStatus) {
        client.commonCallback = null
        client.shutdown()
        this@MeasurementService.rmbtClient = null
        if (currentStatus != TestStatus.ERROR) {
            testProgressListener?.onFinish()
        }
        stop()
    }

    private fun handleWaitStatus() {
        setState(MeasurementState.INIT, 0)
    }

    private fun handleInitStatus(client: RMBTClient) {
        client.getIntermediateResult(result)
        setState(MeasurementState.INIT, (result.progress * 100).toInt())
    }

    private fun handlePingStatus(client: RMBTClient) {
        client.getIntermediateResult(result)
        setState(MeasurementState.PING, (result.progress * 100).toInt())
        testProgressListener?.onPingChanged(result.progress)
        Timber.d("PROGRESS PING TCI: ${result.progress}")
    }

    private fun handleDownloadStatus(client: RMBTClient) {
        client.getIntermediateResult(result)
        val progress = (result.progress * 100).toInt()
        if (progress != previousDownloadProgress) {
            setState(MeasurementState.DOWNLOAD, progress)
            val value = result.downBitPerSec
            testProgressListener?.onDownloadSpeedChanged(progress, value)
            Timber.d("testProgressListener is null?: ${testProgressListener == null}")
            previousDownloadProgress = progress
        }
    }

    private fun handleJitterAndPacketLossStatus(client: RMBTClient) {
        client.getIntermediateResult(result)
        Timber.d("JITTER PROGRESS TCI: $result.progress")
        setState(MeasurementState.JITTER, (result.progress * 100).toInt())
        testProgressListener?.onJitterChanged(result.progress)
        val packetLoss = client.totalTestResult.packetLossPercent.toInt()
        if (packetLoss >= 0) {
            testProgressListener?.onPacketLossChanged(packetLoss)
        }
    }

    private fun handleInitUploadStatus() {
        setState(MeasurementState.INIT_UPLOAD, 0)
    }

    private fun handleUploadStatus(client: RMBTClient) {
        client.getIntermediateResult(result)
        val progress = (result.progress * 100).toInt()
        if (progress != previousUploadProgress) {
            setState(MeasurementState.UPLOAD, (result.progress * 100).toInt())
            val value = result.upBitPerSec
            Timber.e("Progressy2: ${result.upBitPerSec} - $value")
            testProgressListener?.onUploadSpeedChanged(progress, value)
            previousUploadProgress = progress
        }
        if (!finalDownloadValuePosted) {
            val value = result.downBitPerSec
            Timber.w("Progressy2: ${result.upBitPerSec} - $value")
            testProgressListener?.onDownloadSpeedChanged(-1, value)
            finalDownloadValuePosted = true
        }
    }

    private fun handleSpeedTestEndStatus() {
        if (SKIP_QOS_TESTS) {
            setState(MeasurementState.FINISH, 0)
            isTestRunning = false
        }
    }

    private fun handleErrorStatus(client: RMBTClient) {
        Timber.d("XDTE: Handle error ${client.errorMsg}")
        isTestRunning = false
        testProgressListener?.onError(client.errorMsg)
    }

    private fun handleAbortStatus() {
        Timber.e("${TestStatus.ABORTED} handling not implemented")
        isTestRunning = false
    }

    private fun handleEndStatus() {
        setState(MeasurementState.FINISH, 0)
        isTestRunning = false
    }

    private fun stopTest() {
        stop()
        stopSelf()
    }

    private fun stop() {
        rmbtClient?.commonCallback = null
        rmbtClient?.abortTest(false)
        rmbtClient?.shutdown()

        if (measurementJob == null) {
            Timber.w("measurement job is already stopped")
        } else {
            measurementJob?.cancel()
        }

        if (clientJob == null) {
            Timber.w("clientJob Runner is already stopped")
        } else {
            clientJob?.cancel()
        }

        clientJob = null
        measurementJob = null
        testProgressListener?.onPostFinish()
        testProgressListener = null

        stopForeground(true)
    }

    inner class MeasurementServiceBinder : Binder() {
        fun getService(): MeasurementService = this@MeasurementService

        fun getRmbtClient(): RMBTClient? = this@MeasurementService.rmbtClient

        fun setTestListener(progressListener: TestProgressListener) {
            testProgressListener = progressListener
        }

        fun isTestRunning(): Boolean = isTestRunning
    }

    companion object {
        private const val ACTION_START_TEST = "KEY_START_TESTS"
        private const val ACTION_STOP_TEST = "KEY_STOP_TESTS"

        fun startTests(
            context: Context,
            appVersion: String,
            flavor: String,
            clientUUID: String,
            location: Map<String, Any?>,
            measurementServer: TargetMeasurementServer?,
            telephonyPermissionGranted: Boolean,
            locationPermissionGranted: Boolean,
            notificationPermissionGranted: Boolean,
            uuidPermissionGranted: Boolean,
            loopModeSettings: LoopModeSettings?,
            externalPings: DoubleArray,
            externalJitter: Double,
            externalPacketLoss: Double,
            externalTestStart: Double,
        ) {
            val intent = intent(context)
            val locationModel =
                if (location.isNotEmpty()) LocationModel.fromMap(location)
                else null
            intent.action = ACTION_START_TEST
            intent.putExtra(APP_VERSION_EXTRA, appVersion)
            intent.putExtra(CLIENT_UUID_EXTRA, clientUUID)
            intent.putExtra(FLAVOR_EXTRA, flavor)
            intent.putExtra(LOCATION_EXTRA, locationModel)
            loopModeSettings?.let {
                intent.putExtra(LOOP_MODE_SETTINGS_EXTRA, Gson().toJson(it).toString())
            }
            measurementServer?.let {
                intent.putExtra(MEASUREMENT_SERVER_EXTRA, Gson().toJson(it).toString())
            }
            intent.putExtra(TELEPHONY_PERMISSION_GRANTED, telephonyPermissionGranted)
            intent.putExtra(LOCATION_PERMISSION_GRANTED, locationPermissionGranted)
            intent.putExtra(UUID_PERMISSION_GRANTED, uuidPermissionGranted)
            intent.putExtra(NOTIFICATION_PERMISSION_GRANTED, notificationPermissionGranted)
            intent.putExtra(PINGS_EXTRA, externalPings)
            intent.putExtra(JITTER_EXTRA, externalJitter)
            intent.putExtra(PACKET_LOSS_EXTRA, externalPacketLoss)
            intent.putExtra(TEST_START_EXTRA, externalTestStart)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stopTestsIntent(context: Context): Intent = Intent(context, MeasurementService::class.java).apply {
            action = ACTION_STOP_TEST
        }

        fun stopTests(context: Context) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startService(stopTestsIntent(context))
            } else {
                context.startService(stopTestsIntent(context))
            }
        }

        fun intent(context: Context) = Intent(context, MeasurementService::class.java)
    }
}