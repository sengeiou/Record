//
//  DeviceScanModel.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/21.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

class DeviceScanModel: NSObject {
    public var scanDevceiArray:Array<Any>?
    public var scanDeviceMacDic:Dictionary<String, Any>?
    public var scanDeviceNameDic:Dictionary<String, Any>?
    public var scanDeripheralRssiDic:Dictionary<String, Any>?
    
    
    init(scanArray:Array<Any>?,scanMacDic:Dictionary<String, Any>?,scanNameDic:Dictionary<String, Any>?,scanRssiDic:Dictionary<String, Any>?) {
        
        self.scanDevceiArray = scanArray
        self.scanDeviceMacDic = scanMacDic
        self.scanDeviceNameDic = scanNameDic
        self.scanDeripheralRssiDic = scanRssiDic
        
        
    }
    
    override init() {
        
    }
}
