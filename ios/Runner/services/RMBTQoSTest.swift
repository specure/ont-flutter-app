//
//  RMBTQoSTest.swift
//  Runner
//
//  Created by Polina Gurina on 29.09.22.
//  From: https://github.com/rtr-nettest/open-rmbt-ios/blob/master/Sources/RMBTQoSTest.swift

import UIKit

enum RMBTQoSTestStatus: Int {
    case unknown
    case ok
    case error
    case timeout
    
    var name: String {
        switch self {
        case .unknown: return "UKNOWN"
        case .ok: return "OK"
        case .timeout: return "TIMEOUT"
        case .error: return "ERROR"
        }
    }
}

@objc class RMBTQoSTest: Operation {
    static let kDefaultTimeoutNanos: UInt64 = 10 * NSEC_PER_SEC
    
    var status: RMBTQoSTestStatus = .unknown

    @objc private(set) var concurrencyGroup: UInt = 0
    @objc private(set) var uid: UInt64 = 0
    private(set) var timeoutNanos: UInt64 = RMBTQoSTest.kDefaultTimeoutNanos
    
    @objc private(set) var result: [String: Any] = [:]
    @objc private(set) var durationNanos: Int64 = 0
    private var startedAtNanos: UInt64 = 0

    init?(with params: [String: Any]) {
        concurrencyGroup = params["concurrency_group"] as? UInt ?? 0
        
        guard let uid = params["id"] as? UInt64
        else { return nil }
        
        self.uid = uid
        
        if let timeoutSec = params["timeout"] as? UInt64 {
            timeoutNanos = timeoutSec * NSEC_PER_SEC
        }
    }
    
    func timeoutSeconds() -> Int {
        return max(1, Int(timeoutNanos / NSEC_PER_SEC))
    }
    
    func statusName() -> String? {
        return self.status.name
    }
    
    override func start() {
        if (self.isCancelled) {
            print("Test \(self) cancelled.")
        }
        
        assert(!self.isFinished)
        
        if (!self.isCancelled) { print("Test \(self) started.") }
        
        startedAtNanos = RMBTHelpers.RMBTCurrentNanos()
        super.start()
        durationNanos = Int64(RMBTHelpers.RMBTCurrentNanos() - startedAtNanos)
        if (!self.isCancelled) { print("Test \(self) finished.") }
    }
}
