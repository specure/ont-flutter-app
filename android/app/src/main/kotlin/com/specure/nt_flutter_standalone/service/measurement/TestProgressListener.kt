package com.specure.nt_flutter_standalone.service.measurement

import at.rtr.rmbt.client.helper.IntermediateResult
import at.rtr.rmbt.client.helper.TestStatus
import at.rtr.rmbt.client.v2.task.result.QoSTestResultEnum
import com.specure.nt_flutter_standalone.models.MeasurementState
import com.specure.nt_flutter_standalone.models.MeasurementTestResult

interface TestProgressListener {

    fun onProgressChanged(state: MeasurementState, progress: Int)

    fun onPingChanged(pingProgress: Float)

    fun onJitterChanged(jitterProgress: Float)

    fun onPacketLossChanged(packetLossPercent: Int)

    fun onDownloadSpeedChanged(progress: Int, speedBps: Long)

    fun onUploadSpeedChanged(progress: Int, speedBps: Long)

    fun onCompleted(result: MeasurementTestResult)

    fun onPhaseFinished(phase: TestStatus, result: IntermediateResult)

    fun onFinish()

    /**
     * Called when test is finished and client destroyed
     */
    fun onPostFinish()

    fun onError(errorMsg: String)

    fun onClientReady(testUUID: String?, loopUUID: String?, loopLocalUUID: String?, testStartTimeNanos: Long)

    fun onQoSTestProgressUpdate(tasksPassed: Int, tasksTotal: Int, progressMap: Map<QoSTestResultEnum, Int>)
}