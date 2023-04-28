package com.specure.nt_flutter_standalone.utils.extensions

import at.rtr.rmbt.client.Ping

fun Ping.toMap(): HashMap<String, Any> {
    return hashMapOf(
        "value" to this.client,
        "value_server" to this.server,
        "time_ns" to this.timeNs
    )
}