//
//  RMBTQoSDNSTest.swift
//  Runner
//
//  Created by Polina Gurina on 29.09.22.
//  From: https://github.com/rtr-nettest/open-rmbt-ios/blob/master/Sources/RMBTQoSDNSTest.swift

import UIKit
import RMBTClient
import Sentry

@objc class RMBTQoSDNSTest: RMBTQoSTest {
    static let FLUTTER_CHANNEL_ID = "nettest/dnsTest"

    private var givenResolver: String?
    private var resolverHost: String?
    private var resolverPort: Int32 = NS_DEFAULTPORT
    private var host: String = ""
    private var record: String = ""
    private var rcode: String?
    private var ipv: Int32 = 0
    
    private var timedOut: Bool = false
    
    var entries: [[String: Any]]?

    private var timeoutSeconds: Int32 {
        return Int32(max(1, self.timeoutNanos / NSEC_PER_SEC))
    }
    
    override init?(with params: [String : Any]) {
        super.init(with: params)
        
        host = params["target"] as? String ?? ""
        record = params["entryType"] as? String ?? ""
        let resolver = params["resolver"] as? String ?? ""
        if (!resolver.isEmpty) {
            givenResolver = resolver
            let resolverArr = resolver
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
                .split(separator: ":")
            if resolverArr.count > 1 {
                resolverHost = String(resolverArr[0])
                if let resolverPort = Int32(resolverArr[1]) {
                    self.resolverPort = resolverPort
                }
            } else {
                resolverHost = resolver
            }
            self.setIPV()
        } else if let defaultDNSServerIpAndPort = GetDNSIP.getdnsIPandPort() {
            if let host = defaultDNSServerIpAndPort["host"] as? String {
                self.resolverHost = host
            }
            if let port = defaultDNSServerIpAndPort["port"] as? NSNumber {
                self.resolverPort = Int32(truncating: port)
            }
            if let ipv = defaultDNSServerIpAndPort["ipv"] as? NSNumber {
                self.ipv = Int32(truncating: ipv)
            }
        }
        if (resolverHost == nil || resolverHost?.isEmpty == true) {
            SentrySDK.capture(message: "Unable to detect default DNS server iOS")
        }
    }
    
    func setIPV()() -> void {

        var sin = sockaddr_in()
        var sin6 = sockaddr_in6()

        if self.resolverHost?.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
            self.ipv = 6
        } else if self.resolverHost?.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
            self.ipv = 4
        }
    }
    
    override func cancel() {
        super.cancel()
    }
    
    override func main() {
        assert(!self.isCancelled)
        
        let startTime = RMBTHelpers.RMBTCurrentNanos()
        
        let t = self.queryType()
        if (t == ns_t_invalid) {
            print("..unknown record type \(record), won't run")
            return
        }
        
        var res = __res_9_state()
        guard res_9_ninit(&res) == 0 else {
            return
        }
        
        res.retry = 1
        res.retrans = Int32(self.timeoutSeconds())
        
        if let resolverHost = self.resolverHost {
            // Custom DNS server
            var addr = in_addr()
            inet_aton(resolverHost, &addr)
            
            res.nsaddr_list.0.sin_addr = addr
            if (self.ipv == 6) {
                res.nsaddr_list.0.sin_family = sa_family_t(AF_INET6)
            } else {
                res.nsaddr_list.0.sin_family = sa_family_t(AF_INET)
            }
            res.nsaddr_list.0.sin_port = in_port_t(resolverPort).bigEndian
            res.nscount = 1
        }
        
        if (self.isCancelled) { return }
        
        entries = []
        
        var answer = [CUnsignedChar](repeating: 0, count: Int(NS_PACKETSZ))
        
        let len: CInt = res_9_nquery(&res, host, Int32(ns_c_in.rawValue), Int32(t.rawValue), &answer, Int32(answer.count))

        if (len == -1) {
            if (h_errno == HOST_NOT_FOUND) {
                rcode = "NXDOMAIN";
            } else if (h_errno == TRY_AGAIN) {
                let nanoSecondsAfterStart = RMBTHelpers.RMBTCurrentNanos() - startTime
                if (nanoSecondsAfterStart < UInt64(self.timeoutSeconds()) * NSEC_PER_SEC) {
                    rcode = "TRY_AGAIN"
                } else {
                    timedOut = true
                }
            } else if (h_errno == NO_DATA) {
                rcode = "NO_DATA"
            }
        } else {
            var handle = __ns_msg()
            res_9_ns_initparse(answer, len, &handle)

            let rcode = res_9_ns_msg_getflag(handle, Int32(ns_f_rcode.rawValue))
            if let rcodeCStr = res_9_p_rcode(rcode), let rcodeSwiftString = String(cString: rcodeCStr, encoding: .ascii) {
                self.rcode = rcodeSwiftString
            } else {
                self.rcode = "UNKNOWN" // or ERROR?
            }
            
            let answerCount = handle._counts.1
            if(answerCount > 0) {
                var rr = __ns_rr()
                
                for i in 0..<answerCount {
                    if (self.isCancelled) { break }

                    if(res_9_ns_parserr(&handle, ns_s_an, Int32(i), &rr) == 0) {
                        let ttl: UInt32 = rr.ttl
                        var result: [String: Any] = [ "resultTtl": String(ttl) ]

                        let uint32_rr_type = UInt32(rr.type)
                        
                        if uint32_rr_type == ns_t_a.rawValue {
                            var buf = [Int8](repeating: 0, count: Int(INET_ADDRSTRLEN + 1))
                            if inet_ntop(AF_INET, rr.rdata, &buf, socklen_t(INET_ADDRSTRLEN)) != nil {
                                result["resultAddress"] = String(cString: buf, encoding: .ascii)
                            }
                        } else if uint32_rr_type == ns_t_aaaa.rawValue {
                            var buf = [Int8](repeating: 0, count: Int(INET6_ADDRSTRLEN + 1))
                            if inet_ntop(AF_INET6, rr.rdata, &buf, socklen_t(INET6_ADDRSTRLEN)) != nil {
                                result["resultAddress"] = String(cString: buf, encoding: .ascii)
                            }
                        } else if uint32_rr_type == ns_t_mx.rawValue || uint32_rr_type == ns_t_cname.rawValue {
                            var buf = [Int8](repeating: 0, count: Int(NS_MAXDNAME))

                            if res_9_ns_name_uncompress(handle._msg, handle._eom, rr.rdata, &buf, buf.count) != -1 {
                                result["resultAddress"] = String(cString: buf, encoding: .ascii)

                                if uint32_rr_type == ns_t_mx.rawValue {
                                    result["resultPriority"] = String(res_9_ns_get16(rr.rdata))
                                }
                            }
                        }

                        entries?.append(result)
                    }
                }
            }
        }
        
        res_9_ndestroy(&res)
    }
    
    func queryType() -> ns_type {
        if (record == "A") {
            return ns_t_a
        } else if (record == "AAAA"){
            return ns_t_aaaa
        } else if (record == "MX") {
            return ns_t_mx
        } else if (record == "CNAME") {
            return ns_t_cname
        } else {
            return ns_t_invalid
        }
    }
    
    override var result: [String: Any] {
        var result: [String: Any] = [
            "givenResolver": givenResolver,
            "record": record,
            "host": host,
            "timeoutSeconds": self.timeoutNanos / NSEC_PER_SEC,
            "resultResolver": "\(resolverHost!)",
            "resultDurationNanos": self.durationNanos
        ]
        
        if (timedOut) {
            result["resultQueryStatus"] = "TIMEOUT"
        } else if (entries == nil) {
            result["resultQueryStatus"] = "ERROR"
        } else {
            result["resultQueryStatus"] = rcode != nil ? rcode : "UNKNOWN"
            result["dnsRecords"] = entries ?? NSNull()

        }

        return result
    }
    
    override var description: String {
        return String(format:"RMBTQoSDNSTest (uid=%d, cg=%ld, %@ %@@%@)",
                    self.uid,
                    self.concurrencyGroup,
                    record,
                    host,
                    resolverHost ?? "-")
    }
}
