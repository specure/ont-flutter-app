//
//  TestClientDelegate.swift
//  Runner
//
//  Created by Polina on 30.07.2021.
//

import Flutter
import Foundation
import RMBTClient

class TestClientDelegate: RMBTClientDelegate {
    static let FLUTTER_CHANNEL_ID = "nettest/measurements"
    
    let flutterChannel : FlutterMethodChannel
    
    private var prevLoopUuid: String?
    
    init(flutterChannel : FlutterMethodChannel) {
        self.flutterChannel = flutterChannel
    }
    
    func measurementDidStart(client: RMBTClient) {
        if let loopUuid = RMBTConfig.sharedInstance.loopModeInfo?["loop_uuid"] as? String, loopUuid != prevLoopUuid {
            prevLoopUuid = loopUuid
            flutterChannel.invokeMethod("measurementRequestSent", arguments: ["loopUuid": loopUuid])
        }
    }
    
    func measurementDidCompleteVoip(_ client: RMBTClient, withResult: [String : Any]) {
        flutterChannel.invokeMethod("measurementDidCompleteVoip", arguments: withResult)
    }
    
    func measurementDidComplete(_ client: RMBTClient, withResult result: String) {
        flutterChannel.invokeMethod("measurementResultSubmitted", arguments: result)
    }
    
    func measurementDidFail(_ client: RMBTClient, withReason reason: RMBTClientCancelReason) {
        flutterChannel.invokeMethod("measurementDidFail", arguments: reason.message )
    }
    
    func speedMeasurementDidUpdateWith(progress: Float, inPhase phase: SpeedMeasurementPhase) {
        flutterChannel.invokeMethod("speedMeasurementDidUpdateWith", arguments: [ "phase": phase.rawValue, "progress": progress ] )
    }
    
    func speedMeasurementDidMeasureSpeed(throughputs: [RMBTThroughput], inPhase phase: SpeedMeasurementPhase) {
        flutterChannel.invokeMethod("speedMeasurementDidMeasureSpeed", arguments: [ "phase": phase.rawValue, "result": throughputs.last?.kilobitsPerSecond() ?? 0 ] )
    }
    
    func speedMeasurementDidStartPhase(_ phase: SpeedMeasurementPhase) {
        flutterChannel.invokeMethod("speedMeasurementDidStartPhase", arguments: [ "phase": phase.rawValue ] )
    }
    
    func speedMeasurementDidFinishPhase(_ phase: SpeedMeasurementPhase, withResult result: Double) {
        flutterChannel.invokeMethod("speedMeasurementDidFinishPhase", arguments: [ "phase": phase.rawValue, "result": result ] )
    }
    
    func speedMeasurementPhaseFinalResult(_ phase: SpeedMeasurementPhase, withResult result: Double) {
        flutterChannel.invokeMethod("speedMeasurementPhaseFinalResult", arguments: [ "phase": phase.rawValue, "finalResult": result ] )
    }
    
    func qosMeasurementDidStart(_ client: RMBTClient) {
        flutterChannel.invokeMethod("qosMeasurementDidStart", arguments: nil)
    }
    
    func qosMeasurementDidUpdateProgress(_ client: RMBTClient, progress: Float) {
        flutterChannel.invokeMethod("qosMeasurementDidUpdateProgress", arguments: progress)
    }
    
    func qosMeasurementList(_ client: RMBTClient, list: [QosMeasurementType]) {
        flutterChannel.invokeMethod("qosMeasurementList", arguments: nil)
    }
    
    func qosMeasurementFinished(_ client: RMBTClient, type: QosMeasurementType) {
        flutterChannel.invokeMethod("qosMeasurementFinished", arguments: type.rawValue)
    }
}

extension RMBTClientCancelReason {
    var message: String {
        switch self {
        case .userRequested:
            return "Test cancelled on users request."
        case .appBackgrounded:
            return "Test was aborted because the app went into background. Tests can only be performed while the app is running in foreground."
        case .mixedConnectivity:
            return "No connection to the measurement server. Could not load data."
        case .noConnection:
            return "No connection to the measurement server. Could not load data."
        case .errorFetchingSpeedMeasurementParams:
            return "The connection cannot be established. The probable cause is that your connection is very slow."
        case .errorFetchingQosMeasurementParams:
            return "The connection cannot be established. The probable cause is that your connection is very slow."
        case .errorSubmittingSpeedMeasurement:
            return "Test was completed, but the results couldn't be submitted to the test server."
        case .errorSubmittingQosMeasurement:
            return "Test was completed, but the results couldn't be submitted to the test server."
        default:
            return "Unknown error"
        }
    }
}
