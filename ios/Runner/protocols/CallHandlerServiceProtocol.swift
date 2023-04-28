//
//  CallHandlerServiceProtocol.swift
//  Runner
//
//  Created by Polina Gurina on 16.11.22.
//

import Foundation

protocol CallHandlerServiceProtocol {
    func callHandler(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void
}
