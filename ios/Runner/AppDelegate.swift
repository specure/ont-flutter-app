import UIKit
import Flutter
import RMBTClient
import ObjectMapper

enum EClientSuffix: String {
    case albania = "al"
    case norway = "no"
    case nettest = "nt"
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    static let testStartedMessage = "TEST_STARTED"
    static let testStoppedMessage = "TEST_STOPPED"
    
    var rmbtClient = RMBTClient(withClient: .nkom)
    let zeroMeasurementSynchronizer = RMBTZeroMeasurementSynchronizer.shared
    let operationQueue = OperationQueue()
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        registerFlutterChannels()
        configureRMBTClient()
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func registerFlutterChannels() {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let measurementsChannel : FlutterMethodChannel = FlutterMethodChannel(name: TestClientDelegate.FLUTTER_CHANNEL_ID, binaryMessenger: controller.binaryMessenger )
        measurementsChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch(call.method) {
            case "startTest":
                if let arguments = call.arguments as? [String:Any] {
                    self?.parseMeasurementArguments(arguments)
                }
                self?.rmbtClient.delegate = TestClientDelegate(flutterChannel: measurementsChannel)
                self?.rmbtClient.startMeasurement();
                result(AppDelegate.testStartedMessage)
            case "stopTest":
                self?.rmbtClient.stopMeasurement();
                self?.rmbtClient.delegate = nil;
                result(AppDelegate.testStoppedMessage)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        let dnsTestChannel: FlutterMethodChannel = FlutterMethodChannel(name: RMBTQoSDNSTest.FLUTTER_CHANNEL_ID, binaryMessenger: controller.binaryMessenger)
        dnsTestChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch(call.method) {
            case "startDnsTest":
                if let arguments = call.arguments as? [String: Any] {
                    let test = RMBTQoSDNSTest(with: arguments)
                    if let test = test {
                        test.completionBlock = {
                            let json = try? JSONSerialization.data(withJSONObject: test.result)
                            if let json = json {
                                result(String(data: json, encoding: .utf8))
                            }
                            result("")
                        }
                        self.operationQueue.addOperation(test)
                    }
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        let prefsChannel: FlutterMethodChannel = FlutterMethodChannel(name: PreferencesService.FLUTTER_CHANNEL_ID, binaryMessenger: controller.binaryMessenger )
        prefsChannel.setMethodCallHandler(PreferencesService.instance.callHandler)
        
        let locationChannel: FlutterMethodChannel = FlutterMethodChannel(name: LocationService.FLUTTER_CHANNEL_ID, binaryMessenger: controller.binaryMessenger )
        locationChannel.setMethodCallHandler(LocationService.instance.callHandler)
        
        let permissionsChannel: FlutterMethodChannel = FlutterMethodChannel(name: PermissionsService.FLUTTER_CHANNEL_ID, binaryMessenger: controller.binaryMessenger )
        permissionsChannel.setMethodCallHandler(PermissionsService.instance.callHandler)
        PermissionsService.instance.methodChannel = permissionsChannel
        
        let carrierInfoChannel: FlutterMethodChannel = FlutterMethodChannel(name: CarrierInfoService.FLUTTER_CHANNEL_ID, binaryMessenger: controller.binaryMessenger )
        carrierInfoChannel.setMethodCallHandler(CarrierInfoService.instance.callHandler)
    }
    
    private func configureRMBTClient() {
        let configuration = RMBTConfigurationProtocol()
        
        RMBTConfig.sharedInstance.configNewCS(server: configuration.RMBT_CONTROL_SERVER_URL)
        RMBTConfig.sharedInstance.configNewCS_IPv4(server: configuration.RMBT_CONTROL_SERVER_IPV4_URL)
        RMBTConfig.sharedInstance.configNewCS_IPv6(server: configuration.RMBT_CONTROL_SERVER_IPV6_URL)
        
        RMBTConfig.sharedInstance.RMBT_VERSION_NEW = configuration.RMBT_VERSION_NEW
        RMBTConfig.sharedInstance.settingsMode = configuration.RMBT_SETTINGS_MODE
    }
    
    private func parseMeasurementArguments(_ arguments: [String:Any]) {
        if let appVersion = arguments["appVersion"] as? String {
            RMBTConfig.sharedInstance.appVersion = appVersion
        }
        
        if let clientIdentifier = arguments["flavor"] as? String {
            RMBTConfig.sharedInstance.clientIdentifier = clientIdentifier
        } else {
            RMBTConfig.sharedInstance.clientIdentifier = EClientSuffix.nettest.rawValue
        }
        
        if let clientUUID = arguments["clientUUID"] as? String {
            RMBTConfig.updateUUID(clientUUID)
        }
        
        if let location = arguments["location"] as? [String:Any] {
            let map = Map(mappingType: .fromJSON, JSON: location)
            RMBTLocationTracker.sharedTracker.predefinedGeoLocation = GeoLocation(map: map)
        }
        
        if let measurementServerId = arguments["selectedMeasurementServerId"] as? NSNumber {
            RMBTConfig.sharedInstance.measurementServer = MeasurementServerInfoResponse.Servers(id: measurementServerId)
        }
        
        if var loopModeSettings = arguments["loopModeSettings"] as? [String:Any] {
            if let _ = loopModeSettings["loop_uuid"] as? String {
            } else {
                loopModeSettings["loop_uuid"] = UUID().uuidString.lowercased()
            }
            RMBTConfig.sharedInstance.loopModeInfo = loopModeSettings
        }
        
        if let enableAppJitterAndPacketLoss = arguments["enableAppJitterAndPacketLoss"] as? Bool, enableAppJitterAndPacketLoss == true {
            self.rmbtClient = RMBTClient(withClient: .standard)
        }
        
        if let locationPermissionGranted = arguments["locationPermissionGranted"] as? Bool {
            RMBTConfig.sharedInstance.locationPermissionGranted = locationPermissionGranted
        }
        
        if let uuidPermissionGranted = arguments["uuidPermissionGranted"] as? Bool {
            RMBTConfig.sharedInstance.uuidPermissionGranted = uuidPermissionGranted
        }
    }
}
