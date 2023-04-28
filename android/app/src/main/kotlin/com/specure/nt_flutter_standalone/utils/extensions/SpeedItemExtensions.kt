package com.specure.nt_flutter_standalone.utils.extensions

import at.rtr.rmbt.client.SpeedItem

fun SpeedItem.toMap(): HashMap<String, Any> {
    return hashMapOf(
        "bytes" to this.bytes,
        "direction" to if (this.upload) "upload" else "download",
        "thread" to this.thread,
        "time" to this.time
    )
}