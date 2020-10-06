//
//  FDReachability.swift
//  Orangetheory
//
//  Created by Payne on 2018/8/10.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkReachEnum: String {

    case notReachable
    case reachable
}
class FDReachability {

    //shared instance
    static let shared = FDReachability()
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")

    var reachability = false
    var reachabilityBlock: ((Bool) ->Void)?

    func startNetworkReachabilityObserver() {

        reachabilityManager?.listener = { status in
            switch status {

            case .notReachable, .unknown:
                FDLog("The network is not reachable")
                self.reachability = false
                if self.reachabilityBlock != nil {
                    self.reachabilityBlock!(false)
                }
                NotificationCenter.post(custom: .ReachabilityChanged, object: NetworkReachEnum.notReachable)
            case .reachable(.ethernetOrWiFi), .reachable(.wwan):
                FDLog("The network is reachable")
                self.reachability = true
                if self.reachabilityBlock != nil {
                    self.reachabilityBlock!(true)
                }
                NotificationCenter.post(custom: .ReachabilityChanged, object: NetworkReachEnum.reachable)
            }
        }

        // start listening
        reachabilityManager?.startListening()
    }
}
