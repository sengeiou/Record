//
//  BleSingleton.swift
//  BLESwiftModule
//
//  Created by WANG DONG on 2018/6/2.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit
import CoreBluetooth

@objc public protocol BleHandleMacProtocol {
    @objc optional  func bleHandleBleMac(tempMac:String) -> String
}

open class BleSingleton: NSObject {

    
   public var delegate:BleHandleMacProtocol?
    
    public static let instance = BleSingleton()
    private let synLock:NSLock = NSLock.init()
    private let synScanLock:NSLock = NSLock.init()
    
    
    public func handleBleAdvertisementData(peripheralArray:[BlePeripheralModel],advertisementData:NSDictionary,peripheral:CBPeripheral,RSSI:NSNumber) -> [BlePeripheralModel]{
        
        var peripheralSubArray:[BlePeripheralModel] = Array(peripheralArray)
        let peripheralModel:BlePeripheralModel = BlePeripheralModel()

        let resultArray = peripheralSubArray.filter { (item) -> Bool in
            return item.peripheral.identifier.uuidString == peripheral.identifier.uuidString
        }
        //如果原先数组中有相同的Identifier，则说明搜索到的设备已经放入数据，则直接返回
        if resultArray.count > 0 {
            return peripheralSubArray
        }
        
        var macAddress:String = BLE_DEFAULT_MAC
        
        //若广播包中不包含自定义的Mac地址字段，则不需要更新对应的数据Buff
        if let data = advertisementData[KCBADV_DATAMANU_Data] as? Data {
            macAddress = NSString.localizedStringWithFormat("%@", data as CVarArg) as String
            
            if self.delegate != nil{
                macAddress = (self.delegate?.bleHandleBleMac!(tempMac: macAddress))!
            }
            
            peripheralModel.peripheral = peripheral
            peripheralModel.RSSI = RSSI
            peripheralModel.deviceName = (advertisementData[KCBADV_DATALOCAL_NAME] != nil) ? advertisementData[KCBADV_DATALOCAL_NAME] as? String : "UNKNOW"
            
            peripheralModel.macAdress = macAddress
            peripheralModel.advertisementData = (advertisementData as! [String : Any])
            
            peripheralSubArray.append(peripheralModel)
        }
        
        return peripheralSubArray
    }

    
    // MARK:按照设备信号强度对设备进行排序
    public func rankPeripheralArrayWithRSSI(peripheralsArray:[BlePeripheralModel]) -> [BlePeripheralModel] {
        
        return peripheralsArray.sorted(by: { (item1, item2) -> Bool in
            return item1.RSSI.intValue > item2.RSSI.intValue
        })
    }

}
