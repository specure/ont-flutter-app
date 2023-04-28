//
//  CarrierInfoService.swift
//  Runner
//
//  Created by Polina Gurina on 15.02.23.
//

import Foundation

class CarrierInfoService: CallHandlerServiceProtocol {
    static let FLUTTER_CHANNEL_ID = "nettest/carrierInfo"
    static let instance = CarrierInfoService()
    
    private let carrier = Carrier()
    
    private init() {}
    
    func callHandler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getIosInfo":
            result(carrier.carrierInfo)
        default:
            result(nil)
        }
    }
}
