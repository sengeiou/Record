//
//  BleCharacterModel.swift
//  BLESwiftModule
//
//  Created by WANG DONG on 2018/6/2.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit
import CoreBluetooth

open class BleCharacterModel: NSObject {

    public var bleCharacteristic:CBCharacteristic!
    public var characteristicProperties:CBCharacteristicProperties!
}



open class BlePeripheralModel:NSObject {
    
    public var peripheral:CBPeripheral!
    public var macAdress:String!
    public var deviceName:String!
    public var RSSI:NSNumber!
    public var advertisementData: [String : Any]!
    
}
