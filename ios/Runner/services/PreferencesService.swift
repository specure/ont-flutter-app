//
//  PreferencesService.swift
//  Runner
//
//  Created by Polina Gurina on 29.03.2022.
//

import Foundation
import Flutter
import RMBTClient

class PreferencesService: CallHandlerServiceProtocol {
    static let FLUTTER_CHANNEL_ID = "nettest/preferences"
    static let STANDARD_UUID_KEY = "client_uuid"
    static let NKOM_LEGACY_UUID_KEY = "uuid_nettest-p-web.nettfart.no"
    static let ONT_LEGACY_UUID_KEY = "uuid_nettest.org"
    static let RATEL_LEGACY_UUID_KEY = "uuid_ratel.customers.nettest.org"
    static let RU_LEGACY_UUID_KEY = "uuid_ru.customers.nettest.org"
    static let EKIP_LEGACY_UUID_KEY = "uuid_ekip.customers.nettest.org"
    
    static let instance = PreferencesService()
    
    private init() {}
    
    func callHandler(call: FlutterMethodCall, result: (Any?) -> Void) {
        switch(call.method) {
        case "getClientUuid":
            result(clientUuid)
        case "removeClientUuid":
            result(removeClientUuid())
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    var clientUuid: String? {
        var uuid = UserDefaults.checkStoredUUID(uuidKey: PreferencesService.STANDARD_UUID_KEY)
        
        // Check for old NKOM
        if uuid == nil {
            uuid = UserDefaults.checkStoredUUID(uuidKey: PreferencesService.NKOM_LEGACY_UUID_KEY)
        }
        
        // Check for old ONT
        if uuid == nil {
            uuid = UserDefaults.checkStoredUUID(uuidKey: PreferencesService.ONT_LEGACY_UUID_KEY)
        }
        
        // Check for old RATEL
        if uuid == nil {
            uuid = UserDefaults.checkStoredUUID(uuidKey: PreferencesService.RATEL_LEGACY_UUID_KEY)
        }
        
        // Check for old RU
        if uuid == nil {
            uuid = UserDefaults.checkStoredUUID(uuidKey: PreferencesService.RU_LEGACY_UUID_KEY)
        }
        
        // Check for old EKIP
        if uuid == nil {
            uuid = UserDefaults.checkStoredUUID(uuidKey: PreferencesService.EKIP_LEGACY_UUID_KEY)
        }
        
        return uuid
    }
    
    func removeClientUuid() -> Bool {
        for key in [PreferencesService.STANDARD_UUID_KEY, PreferencesService.NKOM_LEGACY_UUID_KEY, PreferencesService.ONT_LEGACY_UUID_KEY, PreferencesService.RATEL_LEGACY_UUID_KEY, PreferencesService.RU_LEGACY_UUID_KEY, PreferencesService.EKIP_LEGACY_UUID_KEY] {
            UserDefaults.clearStoredUUID(uuidKey: key)
        }
        return true
    }
}
