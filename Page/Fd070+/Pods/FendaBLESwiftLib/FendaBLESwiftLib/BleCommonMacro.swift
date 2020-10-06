//
//  BleCommonMacro.swift
//  BLESwiftModule
//
//  Created by WANG DONG on 2017/7/26.
//  Copyright © 2017年 WANG DONG. All rights reserved.
//

import Foundation


//我们将原本oc中不需要接受参数的宏，定义成let常量，将需要接受参数的宏定义成函数即可，由于我们的整个项目共享命名空间，我们就可以在项目内的任何地方直接使用Const.swift中定义的这些公共的常量和函数

/// 系统蓝牙的开关状态
public let SYSTEM_BLUETOOTH_STATE = "bluetoothOpenState"


/// 连接设备的UUID
public let BLEConnectedPeripheralUUID = "BLEConnectedPeripheralUUID"


/// 与外设的连接状态
public let BLECONNECTSTATE = "BLECONNECTSTATE"


/// 连接的外设的蓝牙地址
public let BLEBANDMACADDRESS = "BleBandMacAddress"

/// 蓝牙重新连接
public let BLERECONNECTACTION = "BleReconnectAction"

/// 控制台打印开关状态
public let DEBUGPRINTSWITCH = "DebugPrintSwitch"
//Name of device in Broadcase package
public let KCBADV_DATALOCAL_NAME = "kCBAdvDataLocalName"

//Manufacturer of device in Broadcase package
public let KCBADV_DATAMANU_Data = "kCBAdvDataManufacturerData"

//Default mac
public let BLE_DEFAULT_MAC = "F0:13:C3:FF:FF:FF"



