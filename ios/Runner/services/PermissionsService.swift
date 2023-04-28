//
//  PermissionsService.swift
//  Runner
//
//  Created by Polina Gurina on 06.02.23.
//

import Foundation
import Flutter
import SwiftLocation
import CoreLocation

class PermissionsService: NSObject, CallHandlerServiceProtocol, CLLocationManagerDelegate {
    static let FLUTTER_CHANNEL_ID = "nettest/permissions"
    static let PERMISSIONS_CHANGED_EVENT = "permissionsChanged"
    static let LOCATION_PERMISSION_GRANTED_KEY = "locationPermissionsGranted"
    
    static let instance = PermissionsService()
    
    var methodChannel: FlutterMethodChannel?
    
    private var locationManager: CLLocationManager?
    
    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager!.delegate = self
    }

    func callHandler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(nil)
    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch(manager.authorizationStatus){
        case .authorized:
            setLocationPermissionGranted()
        case .authorizedAlways:
            setLocationPermissionGranted()
        case .authorizedWhenInUse:
            setLocationPermissionGranted()
        default:
            setLocationPermissionDenied()
        }
    }
    
    private func setLocationPermissionGranted() {
        methodChannel?.invokeMethod(PermissionsService.PERMISSIONS_CHANGED_EVENT, arguments: [
            PermissionsService.LOCATION_PERMISSION_GRANTED_KEY: true
        ])
    }
    
    private func setLocationPermissionDenied() {
        methodChannel?.invokeMethod(PermissionsService.PERMISSIONS_CHANGED_EVENT, arguments: [
            PermissionsService.LOCATION_PERMISSION_GRANTED_KEY: false
        ])
    }
}
