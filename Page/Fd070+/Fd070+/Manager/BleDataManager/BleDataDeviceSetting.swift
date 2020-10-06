//
//  BleDataDeviceSetting.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/24.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth

enum DeviceSettingCommand: UInt8 {
    case Header_SetCurrentTime = 0x01,
    Header_GetCurrentTime = 0x81,
    
    Header_SetDisplayFormat = 0x02,
    Header_GetDisplayFormat = 0x82,
    
    Header_FactoryReset = 0x03,
    Header_StartOTA = 0x04,
    Header_DeviceReset = 0x05,
    
    Header_StartWorkout = 0x06,
    Header_PauseWorkout = 0x07,
    Header_StopWorkout = 0x08,
    
    Header_OpenPairWindow = 0x09,
    Header_BindingRequest = 0x0A,
    
    Header_ContinuousHRTest = 0x0B
    
    var value: UInt8 {
        return rawValue
    }
}

/// BLE Setting Servereices
public enum BLESettingServices: String {
    
    //setting  service UUID
    case SettingService  = "46440001-4245-4665-6E64-61536D617274"
    
    // device information data servcie UUID
    case DeviceInfo   = "180A"
    
    // battery information data services UUID
    case DevicebatteryInfo   = "180F"
    
    //    /// BLE servies uuid
    public var uuid: CBUUID {
        return CBUUID.init(string: self.rawValue)
    }
}
/// BLE Characteristics
public enum BLEDeviceSettingCharacteristics : String {
    
    // devict info characteristic UUID
    case deviceInfoSetting         = "46440003-4245-4665-6E64-61536D617274"
    
    // firmware data characteristic UUID
    case firmwareData        = "2A27"
    
    // soft data characteristic UUID
    case softwareData        = "2A26"
    
    //battery characteristic UUID
    case batteryData        = "2A19"
    
    
    //    /// BLECharacteristics uuid
    public var uuid: CBUUID {
        return CBUUID.init(string: self.rawValue)
    }
}

extension BleDataManager {
    
    /// 同步时间给设备
    func sendSetCurrentTime() {
        let now = Date()
        let timeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        let UTC = timeStamp
        
        let zone = NSTimeZone.local
        //China is 480
        let timeOffset = zone.secondsFromGMT() / 60
        var originalData = Data(bytes: [DeviceSettingCommand.Header_SetCurrentTime.value])
        
        originalData += UInt32(UTC)
        originalData += UInt16(timeOffset)

        sendDeviceSettingDataToDevice(data: originalData)
    }

    /// 获取设备时间
    func sendGetCurrentTime() {
        sendDeviceSettingDataToDevice(data: Data(bytes: [DeviceSettingCommand.Header_GetCurrentTime.value]))
    }
    
    
    /// Set display Setting
    func sendSetDisplayFormatToDevice() {
        
        do {
            
            var data = Data(bytes: [DeviceSettingCommand.Header_SetDisplayFormat.value])
            let item = try DeviceInfoDataHelper.findFirstRow(macAddress: CurrentMacAddress) ?? DeviceInfoModel()
            var uint8:UInt8 = UInt8(item.dial_style)!
            
            data += UInt8(0)    //time format 0:24h 1:12h
            data += UInt8(0)    //Date format 0:month/Day
            data += uint8    //Watch face  0~1
            uint8 = UInt8(item.customary_unit)!
            data += uint8    //Unit 0:Metric 1:Imperial
            data += UInt8(0)    //Language 0:English 1:Spanish 2:Arabic 3:Hebrew 4:Chinese 5:Japanese 6:Cantonese 7:French 8:French Canadian 9:German 10:Hindi
            sendDeviceSettingDataToDevice(data: data)
            
        } catch _ {
            FDLog("getUserInfoTestData error")
        }
    }
    
    
    /// get doisplay setting
    func sendGetDisplayFormatFromDevice() {
        sendDeviceSettingDataToDevice(data: Data(bytes: [DeviceSettingCommand.Header_GetDisplayFormat.value]))
    }

    /// 发送开始OTA模式
    func sendStartOTAToDevice() {
        sendDeviceSettingDataToDevice(data: Data(bytes: [DeviceSettingCommand.Header_StartOTA.value]))
    }
    
    
    /// 发送恢复出厂设置
    func sendFactoryResetToDevice() {
        sendDeviceSettingDataToDevice(data: Data(bytes: [DeviceSettingCommand.Header_FactoryReset.value]))
    }
    
    
    /// 发送重启设备
    func sendDeviceResetToDevice() {
        sendDeviceSettingDataToDevice(data: Data(bytes: [DeviceSettingCommand.Header_DeviceReset.value]))
    }
    
    
    /// Start workout
    func sendStartWorkoutToDevice() {
        sendDeviceSettingDataToDevice(data: Data(bytes: [DeviceSettingCommand.Header_StartWorkout.value]))
    }
    
    
    /// Pause workout
    func sendPauseWorkoutToDevice() {
        sendDeviceSettingDataToDevice(data: Data(bytes: [DeviceSettingCommand.Header_PauseWorkout.value]))
    }
    
    
    /// Stop workout
    func sendStopWorkoutToDevice() {
        sendDeviceSettingDataToDevice(data: Data(bytes: [DeviceSettingCommand.Header_StopWorkout.value]))
    }

    /// 发送握手配对
    func sendOpenPairWindowToDevice(_ receiveCallBlock:@escaping snedDataReceiveCallBlock) {
        
        self.sendDataReceiveCallBlock = receiveCallBlock
        sendDeviceSettingDataToDevice(data: Data(bytes: [DeviceSettingCommand.Header_OpenPairWindow.value]))
    }
    
    
    /// request device binding 
    func sendBindRequestToDevice() {
         sendDeviceSettingDataToDevice(data: Data(bytes: [DeviceSettingCommand.Header_BindingRequest.value]))
    }

    /// 发送测试心率
    func sendContinuousHRTestToDevice() {

        sendDeviceSettingDataToDevice(data: Data(bytes: [DeviceSettingCommand.Header_ContinuousHRTest.value]))
    }


    
    /// get the battery level
    ///
    /// - Parameter batteryLevelClorse: had get the battery level .battery level clorse
    func getBatteryLevel() {
        FDLog("getBatteryLevel")
        self.bleOperationMana.readDataFromBand(serviceUUIDString: BLESettingServices.DevicebatteryInfo.rawValue, characteristicString: BLEDeviceSettingCharacteristics.batteryData.rawValue)
        
    }
    
    /// 获取手环固件和软件版本
    func getFrimwareAndSofewareVersion() {
        FDLog("getFrimwareAndSofewareVersion")
        
        bleOperationMana.readDataFromBand(serviceUUIDString: BLESettingServices.DeviceInfo.rawValue, characteristicString: BLEDeviceSettingCharacteristics.firmwareData.rawValue)
        
        bleOperationMana.readDataFromBand(serviceUUIDString: BLESettingServices.DeviceInfo.rawValue, characteristicString: BLEDeviceSettingCharacteristics.softwareData.rawValue)
        
    }


    /// 处理开始测试心率的数据
    ///
    /// - Parameter data: 原始数据
    func handleContinuousHRData(data:Data) {
        let setStatus: UInt16 = data.scanValue(at: 1)
        FDLog("setStatus\(setStatus)")
    }
    
    /// 调用Lib中的API发送真是的Data数据
    ///
    /// - Parameter data: 对应的Data数据
    func sendDeviceSettingDataToDevice(data:Data) {


        self.bleOperationMana.sendDataFromAppToBand(data: handleSingleByteCommand(tempData: data), serviceUUIDString: BLESettingServices.SettingService.rawValue, characteristicString: BLEDeviceSettingCharacteristics.deviceInfoSetting.rawValue, writeType: .withoutResponse)
        
        let commandStr = handleSingleByteCommand(tempData: data).hexEncodedString(options: .upperCase)
        let service = BLESettingServices.SettingService.rawValue
        let characteristic = BLEDeviceSettingCharacteristics.deviceInfoSetting.rawValue
        FDLog("commandStr:\(commandStr) --- service:\(service) --- characteristic:\(characteristic)")
    }
    
    
    /// 封装对应的单字节指令
    ///
    /// - Parameter header: 对应的单指令
    /// - Returns: 返回补齐20字节的数据
    func handleSingleByteCommand(tempData:Data) -> Data {
        let data = self.dealDataToTwentyLengthPackage(data: tempData)
        return data
        
    }
    
    
}
