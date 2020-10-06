//
//  BleStateManager.swift
//  BLESwiftModule
//
//  Created by WANG DONG on 2017/7/26.
//  Copyright © 2017年 WANG DONG. All rights reserved.
//

import UIKit

open class BleStateManager: NSObject {

    public static func getCurrentSystemBluetoothState() -> Bool {
        
        return  BleOperatorManager.instance.centralManager.state == .poweredOn ? true : false  //UserDefaults.standard.bool(forKey: SYSTEM_BLUETOOTH_STATE)
        
    }
    
    public static func getCurrentBleConnectState() -> Bool {
        return UserDefaults.standard.bool(forKey: BLECONNECTSTATE)
    }
    
    public static func getConnectedPeripheralMacAddress() -> String {
        
        if let macAddress = UserDefaults.standard.string(forKey: BLEBANDMACADDRESS) as String? {
            
            return macAddress
        }
        else {
            return "F0:13:C3:FF:FF:FF"
        }
    }
    
    public static func getReConnectedPeripheralIdentifier() -> String {
        if let identifier = UserDefaults.standard.string(forKey:BLEConnectedPeripheralUUID) as String? {
            return identifier
        }
        else {
            return ""
        }
    }
    
    
    public static func disableBleConnectState() {
        UserDefaults.standard.set(false, forKey: BLECONNECTSTATE)
        UserDefaults.standard.set("", forKey: BLEBANDMACADDRESS)
        UserDefaults.standard.synchronize()
    }
    
}


