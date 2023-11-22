//
//  Carrier.swift
//  Runner
//
//  Created by Polina Gurina on 15.02.23.
//
//  Fixed version of https://github.com/Zfinix/carrier_info/blob/main/ios/Classes/Carrier.swift

import Foundation
import UIKit
import CoreTelephony

enum ShortRadioAccessTechnologyList: String {
    case gprs = "GPRS"
    case edge = "Edge"
    case cdma = "CDMA1x"
    case lte  = "LTE"
    case nrnsa = "NRNSA"
    case nr = "NR"
    
    var generation: String {
        switch self {
        case .gprs, .edge, .cdma: return "2G"
        case .lte: return "4G"
        case .nrnsa, .nr: return "5G"
        }
    }
}

/// Wraps CTRadioAccessTechnologyDidChange notification
public protocol CarrierDelegate: AnyObject {
    func carrierRadioAccessTechnologyDidChange()
}

@available(iOS 12.0, *)
final public class Carrier {
    
    // MARK: - Private Properties
    private let networkInfo = CTTelephonyNetworkInfo()
    private let planProvisioning = CTCellularPlanProvisioning()
    private var carriers = [String : CTCarrier]()
    private var changeObserver: NSObjectProtocol!
    
    public init() {
        
        changeObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.CTRadioAccessTechnologyDidChange, object: nil, queue: nil) { [unowned self](notification) in
            DispatchQueue.main.async {
                self.delegate?.carrierRadioAccessTechnologyDidChange()
            }
        }
        
        self.carriers = networkInfo.serviceSubscriberCellularProviders ?? [:]
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(changeObserver!)
    }
    
    public weak var delegate: CarrierDelegate?
    
    /// Returns current radio access technology type used (GPRS, Edge, LTE, etc.) with the carrier.
    public var carrierRadioAccessTechnologyTypeList: [[String:Any?]] {
        var technologyList  =  [[String:Any?]]()
        

        let prefix = "CTRadioAccessTechnology"
        guard let currentTechnologies = networkInfo.serviceCurrentRadioAccessTechnology else {
            return []
        }
        
        for techKey in currentTechnologies.keys {
            guard let technology = currentTechnologies[techKey] else {continue}
            let name = technology.hasPrefix(prefix) ? String(technology.dropFirst(prefix.count)) : String(technology)
            technologyList.append([
                "name": name,
                "carrierId": techKey,
                "isActive": networkInfo.dataServiceIdentifier == techKey
            ])
            
        }
        
        return technologyList
        
    }
    
    /// Returns current radio access technology type used (GPRS, Edge, LTE, etc.) with the carrier.
    public var carrierRadioAccessTechnologyGenerationList: [[String: Any?]] {
        var technologyList  =  [[String: Any?]]()

        let prefix = "CTRadioAccessTechnology"
        guard let currentTechnologies = networkInfo.serviceCurrentRadioAccessTechnology else {
            return []
        }
        
        
        for techKey in currentTechnologies.keys {
            guard let technology = currentTechnologies[techKey] else {continue}
            
            let name = technology.hasPrefix(prefix) ? String(technology.dropFirst(prefix.count)) : String(technology)
            let generation = ShortRadioAccessTechnologyList(rawValue: name)?.generation ?? "3G"
            
            technologyList.append([
                "name": generation,
                "carrierId": techKey,
                "isActive": networkInfo.dataServiceIdentifier == techKey
            ])
            
        }
        
        return technologyList
        
    }
    
    
    /// Returns all available info about the carrier.
    public var carrierInfo: [String: Any?] {
        
        var dataList =  [[String: Any?]]()
        
        for carrKey in carriers.keys {
            guard let carr = carriers[carrKey] else {continue}
            dataList.append([
                "carrierName": carr.carrierName,
                "carrierId": carrKey,
                "isActive": networkInfo.dataServiceIdentifier == carrKey,
                "isoCountryCode": carr.isoCountryCode,
                "mobileCountryCode": carr.mobileCountryCode,
                "mobileNetworkCode": carr.mobileNetworkCode,
                "carrierAllowsVOIP": carr.allowsVOIP,
            ])
            
        }
        
       if #available(iOS 16.0, *) {
            return [
                "carrierData": dataList,
                "carrierRadioAccessTechnologyTypeList": carrierRadioAccessTechnologyTypeList,
                "carrierRadioAccessTechnologyGenerationList": carrierRadioAccessTechnologyGenerationList,
                "supportsEmbeddedSIM": planProvisioning.supportsEmbeddedSIM,
                "serviceCurrentRadioAccessTechnology": networkInfo.serviceCurrentRadioAccessTechnology,
            ]
        }else {
            return [
                "carrierData": dataList,
                "carrierRadioAccessTechnologyTypeList": carrierRadioAccessTechnologyTypeList,
                "carrierRadioAccessTechnologyGenerationList": carrierRadioAccessTechnologyGenerationList,
                "serviceCurrentRadioAccessTechnology": networkInfo.serviceCurrentRadioAccessTechnology,
            ]
        }
    }
}
