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
            SwiftLocation.gpsLocation(accuracy: .neighborhood).then { [self] filtered in
                if let location = parseLocation(gpsResult: filtered) {
                    result(location)
                } else {
                    SwiftLocation.gpsLocation().then { [self] unfiltered in
                        result(parseLocation(gpsResult: unfiltered))
                    }
                }
            }
        default:
            result(nil)
        }
    }
    
    private func parseLocation(gpsResult: Result<CLLocation, LocationError>) -> String? {
        if let location = gpsResult.location, let json = try? JSONSerialization.data(withJSONObject: [
            "lat": location.coordinate.latitude,
            "long": location.coordinate.longitude
        ]) {
            return String(data: json, encoding: .utf8)
        } else {
            return nil
        }
    }
    
}
