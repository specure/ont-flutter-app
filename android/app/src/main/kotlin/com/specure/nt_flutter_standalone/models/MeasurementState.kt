package com.specure.nt_flutter_standalone.models

enum class MeasurementState {
    IDLE,
    INIT,
    PING,
    DOWNLOAD,
    INIT_UPLOAD,
    UPLOAD,
    QOS,
    FINISH,
    ERROR,
    ABORTED,
    JITTER,
    PACKET_LOSS
}

fun MeasurementState.toFlutterMeasurementState(): Int {
    return when (this) {
        MeasurementState.IDLE -> 2
        MeasurementState.INIT -> 3
        MeasurementState.PING -> 4
        MeasurementState.DOWNLOAD -> 5
        MeasurementState.INIT_UPLOAD -> 6
        MeasurementState.UPLOAD -> 7
        MeasurementState.JITTER -> 8
        MeasurementState.PACKET_LOSS -> 9
        MeasurementState.FINISH -> 10
        else -> 0
    }
}