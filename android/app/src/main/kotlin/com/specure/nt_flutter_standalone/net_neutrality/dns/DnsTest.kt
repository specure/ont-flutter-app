package com.specure.nt_flutter_standalone.net_neutrality.dns

import com.google.gson.Gson
import com.specure.nt_flutter_standalone.utils.extensions.io
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withTimeout
import org.xbill.DNS.*
import timber.log.Timber
import java.net.SocketTimeoutException
import java.util.concurrent.TimeUnit

const val DEFAULT_TIMEOUT_SECONDS = 5

const val QUERY_STATUS_RESULT_OK = "OK"
const val QUERY_STATUS_RESULT_ERROR = "ERROR"
const val QUERY_STATUS_RESULT_TIMEOUT = "TIMEOUT"
const val QUERY_STATUS_RESULT_UNKNOWN = "UNKNOWN"

class DnsTest(private val resolver: String?, private val host: String, timeoutSeconds: Int?, private  val recordType: String?) {
    private var queryResult = QUERY_STATUS_RESULT_UNKNOWN
    private var resultStatus = -1
    private var rawResponse:String? = null
    private var resultResolver: String? = null
    private var resultRecords: List<DnsRecord> = mutableListOf()
    private var startTimeNanos: Long? = null
    private var endTimeNanos: Long? = null
    private var resultTimeoutSeconds: Int = timeoutSeconds ?: DEFAULT_TIMEOUT_SECONDS

    fun execute(result: io.flutter.plugin.common.MethodChannel.Result? = null) = io {
        val dnsResult: DnsResult
        try {
            startTimeNanos = System.nanoTime()
            resultRecords =
                withTimeout(TimeUnit.SECONDS.toMillis(resultTimeoutSeconds.toLong())) {
                     lookupDns(
                        host,
                        recordType ?: "A",
                        resolver,
                        resultTimeoutSeconds
                    ) ?: emptyList()
                }
        } catch (e: Exception) {
            Timber.e("DnsTest failed for host: $host, recordType: $recordType, resolver: $resultResolver")
        } finally {
            endTimeNanos = System.nanoTime()
            resultResolver = resolver
            dnsResult = DnsResult(
                timeoutSeconds = resultTimeoutSeconds,
                dnsRecords = resultRecords,
                givenResolver = resolver,
                resultResolver = resultResolver,
                resultQueryStatus = queryResult,
                resultStatus = resultStatus,
                host = host,
                record = recordType ?: "A",
                rawResult = rawResponse,
                resultDurationNanos = startTimeNanos?.let { startTimeNanos -> endTimeNanos?.let { endTimeNanos ->  endTimeNanos - startTimeNanos}},
            )
            Timber.d("DNS RESULT: $rawResponse")
        }
        val dnsResultJson = Gson().toJson(dnsResult)
        result?.success(dnsResultJson)
    }

    private fun lookupDns(
        domainName: String,
        record: String,
        resolver: String?,
        timeoutSeconds: Int
    ): List<DnsRecord>? {
        val result: MutableList<DnsRecord> = mutableListOf()
        try {
            println("dns lookup: record = $record for host: $domainName, using resolver:$resolver")
            ResolverConfig.refresh() // refresh dns server
            val req: Dig.DnsRequest = Dig.doRequest(domainName, record, resolver, timeoutSeconds.times(1000))
            queryResult = QUERY_STATUS_RESULT_OK
            resultStatus = req.response.rcode
            rawResponse = req.response.toString()
            println("answer: " + req.response.toString())
            if (resultStatus == Rcode.NOERROR) {
                val records: Array<Record> =
                    req.response.getSectionArray(Section.ANSWER)
                if (records.isNotEmpty()) {
                    for (i in records.indices) {
                        var resultAddress: String?
                        var resultPriority: String? = null
                        var resultTtl: String?
                        when (records[i]) {
                            is MXRecord -> {
                                resultPriority = (records[i] as MXRecord).priority.toString()
                                resultAddress = (records[i] as MXRecord).target.toString()
                            }
                            is CNAMERecord -> {
                                resultAddress = (records[i] as CNAMERecord).alias.toString()
                            }
                            is ARecord -> {
                                resultAddress = (records[i] as ARecord).address.hostAddress
                            }
                            is AAAARecord -> {
                                resultAddress = (records[i] as AAAARecord).address.hostAddress
                            }
                            is A6Record -> {
                                resultAddress = (records[i] as A6Record).suffix.toString()
                            }
                            else -> {
                                resultAddress = records[i].name.toString()
                            }
                        }
                        resultTtl = records[i].ttl.toString()
                        result.add(DnsRecord(
                            resultAddress = resultAddress,
                            resultPriority = resultPriority,
                            resultTtl = resultTtl,
                        ))
                    }
                } else {
                    return null
                }
            } else {
                return null
            }
        } catch (e: SocketTimeoutException) {
            queryResult = QUERY_STATUS_RESULT_TIMEOUT
            return null
        } catch (e: java.lang.Exception) {
            queryResult = QUERY_STATUS_RESULT_ERROR
            e.printStackTrace()
            return null
        }
        return result
    }
}