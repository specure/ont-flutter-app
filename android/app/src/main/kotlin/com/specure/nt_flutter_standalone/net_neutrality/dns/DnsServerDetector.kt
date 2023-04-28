package com.specure.nt_flutter_standalone.net_neutrality.dns

import android.annotation.TargetApi
import android.content.Context
import android.content.Context.CONNECTIVITY_SERVICE
import android.net.ConnectivityManager
import android.net.LinkProperties
import android.net.NetworkInfo
import android.os.Build
import timber.log.Timber
import java.io.BufferedReader
import java.io.InputStream
import java.io.InputStreamReader
import java.io.LineNumberReader
import java.lang.reflect.Method
import java.net.InetAddress

/**
 * DNS servers detector
 *
 * IMPORTANT: don't cache the result.
 *
 * Or if you want to cache the result make sure you invalidate the cache
 * on any network change.
 *
 * It is always better to use a new instance of the detector when you need
 * current DNS servers otherwise you may get into troubles because of invalid/changed
 * DNS servers.
 *
 * This class combines various methods and solutions from:
 * Dnsjava http://www.xbill.org/dnsjava/
 * Minidns https://github.com/MiniDNS/minidns
 *
 * Unfortunately both libraries are not aware of Orero changes so new method was added to fix this.
 *
 * Created by Madalin Grigore-Enescu on 2/24/18.
 */
class DnsServersDetector(context: Context) {
    /**
     * Holds context this was created under
     */
    private val context: Context// Will hold the consecutive result

    // METHOD 1: old deprecated system properties

    // METHOD 2 - use connectivity manager

    // LAST METHOD: detect android DNS servers by executing getprop string command in a separate process
    // This method fortunately works in Oreo too but many people may want to avoid exec
    // so it's used only as a failsafe scenario

    // Fall back on factory DNS servers
    /**
     * Returns android DNS servers used for current connected network
     * @return Dns servers array
     */
    val servers: Array<String?>
        get() {

            // Will hold the consecutive result
            var result: Array<String?>?

            // METHOD 1: old deprecated system properties
            result = serversMethodSystemProperties
            if (result != null && result.size > 0) {
                return result
            }

            // METHOD 2 - use connectivity manager
            result = serversMethodConnectivityManager
            if (result != null && result.size > 0) {
                return result
            }

            // LAST METHOD: detect android DNS servers by executing getprop string command in a separate process
            // This method fortunately works in Oreo too but many people may want to avoid exec
            // so it's used only as a failsafe scenario
            result = serversMethodExec
            return if (result != null && result.size > 0) {
                result
            } else FACTORY_DNS_SERVERS

            // Fall back on factory DNS servers
        }
    //endregion
    //region - private /////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////// Prioritize the DNS servers for link which have a default route

    // Append secondary arrays only if priority is empty

    // Stop here if we have at least one DNS server

    // Failure
// Iterate all networks
    // Notice that android LOLLIPOP or higher allow iterating multiple connected networks of SAME type
// This code only works on LOLLIPOP and higher
    /**
     * Detect android DNS servers by using connectivity manager
     *
     * This method is working in android LOLLIPOP or later
     *
     * @return Dns servers array
     */
    private val serversMethodConnectivityManager: Array<String?>?
        private get() {

            // This code only works on LOLLIPOP and higher
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                try {
                    val priorityServersArrayList: ArrayList<String> = ArrayList()
                    val serversArrayList: ArrayList<String> = ArrayList()
                    val connectivityManager: ConnectivityManager = context.getSystemService(
                        CONNECTIVITY_SERVICE
                    ) as ConnectivityManager
                    if (connectivityManager != null) {

                        // Iterate all networks
                        // Notice that android LOLLIPOP or higher allow iterating multiple connected networks of SAME type
                        for (network in connectivityManager.getAllNetworks()) {
                            val networkInfo: NetworkInfo? =
                                connectivityManager.getNetworkInfo(network)
                            if (networkInfo?.isConnected() == true) {
                                val linkProperties: LinkProperties? =
                                    connectivityManager.getLinkProperties(network)
                                val dnsServersList: List<InetAddress> =
                                    linkProperties?.getDnsServers() as List<InetAddress>

                                // Prioritize the DNS servers for link which have a default route
                                if (linkPropertiesHasDefaultRoute(linkProperties)) {
                                    for (element in dnsServersList) {
                                        val dnsHost: String = element.getHostAddress()
                                        priorityServersArrayList.add(dnsHost)
                                    }
                                } else {
                                    for (element in dnsServersList) {
                                        val dnsHost: String = element.getHostAddress()
                                        serversArrayList.add(dnsHost)
                                    }
                                }
                            }
                        }
                    }

                    // Append secondary arrays only if priority is empty
                    if (priorityServersArrayList.isEmpty()) {
                        priorityServersArrayList.addAll(serversArrayList)
                    }

                    // Stop here if we have at least one DNS server
                    if (priorityServersArrayList.size > 0) {
                        return priorityServersArrayList.toArray(arrayOfNulls(0))
                    }
                } catch (ex: Exception) {
                    Timber.d("Exception detecting DNS servers using ConnectivityManager method: $ex")
                }
            }

            // Failure
            return null
        }// Stop here if we have at least one DNS server

    // Failed
// This originally looked for all lines containing .dns; but
    // http://code.google.com/p/android/issues/detail?id=2207#c73
    // indicates that net.dns* should always be the active nameservers, so
    // we use those.

    /**
     * Detect android DNS servers by using old deprecated system properties
     *
     * This method is NOT working anymore in Android 8.0
     * Official Android documentation state this in the article Android 8.0 Behavior Changes.
     * The system properties net.dns1, net.dns2, net.dns3, and net.dns4 are no longer available,
     * a change that improves privacy on the platform.
     *
     * https://developer.android.com/about/versions/oreo/android-8.0-changes.html#o-pri
     * @return Dns servers array
     */
    private val serversMethodSystemProperties: Array<String?>?
        private get() {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {

                // This originally looked for all lines containing .dns; but
                // http://code.google.com/p/android/issues/detail?id=2207#c73
                // indicates that net.dns* should always be the active nameservers, so
                // we use those.
                val re1 = Regex("^\\d+(\\.\\d+){3}$")
                val re2 = Regex("^[0-9a-f]+(:[0-9a-f]*)+:[0-9a-f]+$")
                val serversArrayList: ArrayList<String> = ArrayList()
                try {
                    val SystemProperties = Class.forName("android.os.SystemProperties")
                    val method: Method = SystemProperties.getMethod(
                        "get", *arrayOf<Class<*>>(
                            String::class.java
                        )
                    )
                    val netdns = arrayOf("net.dns1", "net.dns2", "net.dns3", "net.dns4")
                    for (i in netdns.indices) {
                        val args = arrayOf<Any>(netdns[i])
                        val v = method.invoke(null, args) as String
                        if (v != null && (v.matches(re1) || v.matches(re2)) && !serversArrayList.contains(
                                v
                            )
                        ) {
                            serversArrayList.add(v)
                        }
                    }

                    // Stop here if we have at least one DNS server
                    if (serversArrayList.size > 0) {
                        return serversArrayList.toArray(arrayOfNulls(0))
                    }
                } catch (ex: Exception) {
                    Timber.d( "Exception detecting DNS servers using SystemProperties method $ex")
                }
            }

            // Failed
            return null
        }// We are on the safe side and avoid any bug

    // Failed

    /**
     * Detect android DNS servers by executing getprop string command in a separate process
     *
     * Notice there is an android bug when Runtime.exec() hangs without providing a Process object.
     * This problem is fixed in Jelly Bean (Android 4.1) but not in ICS (4.0.4) and probably it will never be fixed in ICS.
     * https://stackoverflow.com/questions/8688382/runtime-exec-bug-hangs-without-providing-a-process-object/11362081
     *
     * @return Dns servers array
     */
    private val serversMethodExec: Array<String?>?
        private get() {

            // We are on the safe side and avoid any bug
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                try {
                    val process = Runtime.getRuntime().exec("getprop")
                    val inputStream: InputStream = process.inputStream
                    val lineNumberReader = LineNumberReader(InputStreamReader(inputStream))
                    val serversSet = methodExecParseProps(lineNumberReader)
                    if (serversSet != null && serversSet.size > 0) {
                        return serversSet.toTypedArray()
                    }
                } catch (ex: Exception) {
                    Timber.d( "Exception in getServersMethodExec $ex")
                }
            }

            // Failed
            return null
        }

    /**
     * Parse properties produced by executing getprop command
     * @param lineNumberReader
     * @return Set of parsed properties
     * @throws Exception
     */
    @Throws(Exception::class)
    private fun methodExecParseProps(lineNumberReader: BufferedReader): Set<String?> {
        var line: String
        val serversSet: MutableSet<String?> = HashSet(10)
        while (lineNumberReader.readLine().also { line = it } != null) {
            val split = line.indexOf(METHOD_EXEC_PROP_DELIM)
            if (split == -1) {
                continue
            }
            val property = line.substring(1, split)
            val valueStart = split + METHOD_EXEC_PROP_DELIM.length
            val valueEnd = line.length - 1
            if (valueEnd < valueStart) {

                // This can happen if a newline sneaks in as the first character of the property value. For example
                // "[propName]: [\n…]".
                Timber.d("Malformed property detected: \"$line\"")
                continue
            }
            var value = line.substring(valueStart, valueEnd)
            if (value.isEmpty()) {
                continue
            }
            if (property.endsWith(".dns") || property.endsWith(".dns1") ||
                property.endsWith(".dns2") || property.endsWith(".dns3") ||
                property.endsWith(".dns4")
            ) {

                // normalize the address
                val ip: InetAddress = InetAddress.getByName(value) ?: continue
                value = ip.getHostAddress()
                if (value == null) continue
                if (value.length == 0) continue
                serversSet.add(value)
            }
        }
        return serversSet
    }

    /**
     * Returns true if the specified link properties have any default route
     * @param linkProperties
     * @return true if the specified link properties have default route or false otherwise
     */
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    private fun linkPropertiesHasDefaultRoute(linkProperties: LinkProperties): Boolean {
        for (route in linkProperties.getRoutes()) {
            if (route.isDefaultRoute()) {
                return true
            }
        }
        return false
    } //endregion

    companion object {
        private const val TAG = "DnsServersDetector"

        /**
         * Holds some default DNS servers used in case all DNS servers detection methods fail.
         * Can be set to null if you want caller to fail in this situation.
         */
        private val FACTORY_DNS_SERVERS = arrayOf<String?>(
            "8.8.8.8",
            "8.8.4.4"
        )

        /**
         * Properties delimiter used in exec method of DNS servers detection
         */
        private const val METHOD_EXEC_PROP_DELIM = "]: ["
    }
    //region - public //////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////
    /**
     * Constructor
     */
    init {
        this.context = context
    }
}