//
//  BleConnectState.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/21.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import FendaBLESwiftLib


typealias reconnectCallBlock = () -> ()

struct BleConnectState {
    
    /// 获取当前蓝牙的连接状态
    ///
    /// - Returns: 返回True or false
    public static func getSystemBleState() -> Bool {
        
       return BleStateManager.getCurrentSystemBluetoothState()
    }
    
    
    /// 获取当前蓝牙的连接状态
    ///
    /// - Returns:返回True 或者False
    public static func getCurrentBleState() -> Bool {
        
        return BleStateManager.getCurrentBleConnectState()
    }
    
    
    /// 获取当前蓝牙的Mac adress
    ///
    /// - Returns: 返回 字符串
    public static func getCurrentConnectMacAdress() -> String {
        
        return BleStateManager.getConnectedPeripheralMacAddress()
    }
    
    
    public static func getReconnectIdentifier() -> String {
        return BleStateManager.getReConnectedPeripheralIdentifier()
    }
    
    
    /// 获取当前蓝牙的Mac adress
    ///
    /// - Returns: 返回 字符串
    public static func BleReconnectHandle(timer:Int = 15 ,timeouthandle:@escaping reconnectCallBlock)->Bool {
        
        if self.getCurrentBleState() == false {
            if self.getSystemBleState() && self.getReconnectIdentifier().count>0  {
                let bleOperation = BleDataManager.instance.bleOperationMana
                bleOperation.isAutoReconnect = true
                bleOperation.reconnectPeripheral()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(timer)) {
                    if self.getCurrentBleState() == false {
                        timeouthandle()
                    }
                }
                
                print("正在重连。。。。")
                return true
            }
        }
        
        print("重连提交不符合。。。")
        return false
    }

}
