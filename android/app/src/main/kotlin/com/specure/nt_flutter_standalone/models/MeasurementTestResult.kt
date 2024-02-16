package com.specure.nt_flutter_standalone.models

import at.rtr.rmbt.client.TotalTestResult
import com.specure.nt_flutter_standalone.utils.extensions.toMap

data class MeasurementTestResult(
    val totalTestResult: TotalTestResult,
    val testUUID: String,
    val clientName: String,
    val testToken: String
) {
    fun toMap(): MutableMap<String, Any> {
        return mapOf(
            Pair("client_uuid", testUUID),
            Pair("client_name", clientName),
            Pair("client_version", totalTestResult.client_version),
            Pair("test_encryption", totalTestResult.encryption),
            Pair("voip_result_packet_loss_percents", totalTestResult.packetLossPercent),
            Pair("voip_result_jitter_millis", totalTestResult.jitterMeanNanos / 1000000.0),
            Pair("test_bytes_download", totalTestResult.bytes_download),
            Pair("test_bytes_upload", totalTestResult.bytes_upload),
            Pair("test_nsec_download", totalTestResult.nsec_download),
            Pair("test_nsec_upload", totalTestResult.nsec_upload),
            Pair("test_total_bytes_download", totalTestResult.totalDownBytes),
            Pair("test_total_bytes_upload", totalTestResult.totalUpBytes),
            Pair("test_speed_download", totalTestResult.speed_download),
            Pair("test_speed_upload", totalTestResult.speed_upload),
            Pair("test_ping_shortest", totalTestResult.ping_shortest),
            Pair("test_num_threads", totalTestResult.num_threads),
            Pair("test_port_remote", totalTestResult.port_remote),
            Pair("speed_detail", totalTestResult.speedItems.map { it.toMap() }),
            Pair("pings", totalTestResult.pings.map { it.toMap() }),
            Pair("test_ip_server", totalTestResult.ip_server.hostAddress),
            Pair("test_ip_local", totalTestResult.ip_local.hostAddress),
            Pair("test_token", testToken)
        ).toMutableMap()
    }
}
