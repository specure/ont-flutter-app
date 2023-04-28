//
//  LocationService.swift
//  Runner
//
//  Created by Polina Gurina on 02.02.23.
//

import Foundation
import SwiftLocation
import CoreLocation

class LocationService: CallHandlerServiceProtocol {
    static let FLUTTER_CHANNEL_ID = "nettest/location"
    
    static let instance = LocationService()
    
    private init() {}
    
    func callHandler(call: FlutterMethodCall, result: @escaping (Any?) -> Void) {
        switch call.method {
        case "isLocationServiceEnabled":
            result(CLLocationManager.locationServicesEnabled())
        case "getLatestLocation":
            SwiftLocation.gpsLocation().then {
                if let location = $0.location, let json = try? JSONSerialization.data(withJSONObject: [
                    "lat": location.coordinate.latitude,
                    "long": location.coordinate.longitude
                ]) {
                    result(String(data: json, encoding: .utf8))
                } else {
                    result(nil)
                }
            }
        default:
            result(nil)
        }
    }
    
}
