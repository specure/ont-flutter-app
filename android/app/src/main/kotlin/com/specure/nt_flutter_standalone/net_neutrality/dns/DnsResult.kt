package com.specure.nt_flutter_standalone.net_neutrality.dns

data class DnsResult(
    val givenResolver: String?,
    val record: String,
    val host: String,
    val timeoutSeconds: Int?,
    val resultQueryStatus: String,
    val resultStatus: Int?,
    val resultDurationNanos: Long?,
    val resultResolver: String?,
    val rawResult: String?,
    val dnsRecords: List<DnsRecord>
)