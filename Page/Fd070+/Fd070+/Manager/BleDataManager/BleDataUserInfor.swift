//
//  BleDataUserInfor.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/27.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import CoreBluetooth

/// BLE Characteristics
public enum BLEUserInforCharacteristics : String {

    // UserInfor characteristic UUID
    case UserInfoSettingCharacterUUID        = "46440002-4245-4665-6E64-61536D617274"

    // BLECharacteristics uuid
    public var uuid: CBUUID {
        return CBUUID.init(string: self.rawValue)
    }
}

enum UserInforCommand: UInt8 {
    case setUserInfor = 0x01
    case getUserInfor = 0x81

    case getWorkoutTarger = 0x82
    case setWorkoutTarger = 0x02
    
    case setSleepTimePeriod = 0x03
    case getSleepTimePeriod = 0x83
    
    var value: UInt8 {
        return rawValue
    }
}

extension BleDataManager {

    /// 发送用户信息到设备
    
    func sendUserInformationToDevice() {
        do {
            let item = try UserinfoDataHelper.findFirstRow(userID: CurrentUserID) 
            //Set Userinfo model
            guard let heightValue = NumberFormatter().number(from: item.height) else { return }
            guard let weightValue = NumberFormatter().number(from: item.weight) else { return }

            let height = UInt16(truncating: heightValue  )
            let weight = UInt16(truncating: weightValue )
            let gender = UInt8(item.gender)

            //2002-09-09
            let arr = item.birthday.components(separatedBy: "-")
            let year = UInt16(arr[safe: 0] ?? "0")
            let month = UInt8(arr[safe: 1] ?? "0")
            let day = UInt8(arr[safe: 2] ?? "0")

            var data = Data(bytes: [UserInforCommand.setUserInfor.value])
            data += height.littleEndian
            data += weight.littleEndian
            data += gender ?? 0
            data += month ?? 0
            data += day ?? 0
            data += (year ?? 0).littleEndian

            FDLog("height: \(height), weight: \(weight), gender:\(gender), month:\(month), day:\(day), year:\(year)")

            snedUserInforDataBasic(data)


        } catch _ {
            FDLog("getUserInfoTestData error")
        }
    }

    func sendGetUserInfoFromDevice() {
        //Set  data
        let originalData = Data(bytes: [UserInforCommand.getUserInfor.value])
        snedUserInforDataBasic(originalData)
    }

    /// 处理手环返回的用户信息
    ///
    /// - Parameter data: 返回的原始数据
    func handleUserInformation(data:Data) {

        let height: UInt16 = data.scanValue(at: 1)
        let weight: UInt16 = data.scanValue(at: 3)
        let gender: UInt8 = data.scanValue(at: 5)
        let month: UInt8 = data.scanValue(at: 6)
        let day: UInt8 = data.scanValue(at: 7)
        let year: UInt16 = data.scanValue(at: 8)

        FDLog("height: \(height), weight: \(weight), gender:\(gender), month:\(month), day:\(day), year:\(year)")
    }


    /// 设置workout目标
    func sendSetWorkoutTargetToDevice() {
        var data = Data(bytes: [UserInforCommand.setWorkoutTarger.value])
        
        let step:UInt32 = 2000
        data.append(coverIntValueToThressByteData(value: step))
        let Calorie:UInt32 = 2000
        data.append(coverIntValueToThressByteData(value: Calorie))
        let Distance:UInt32 = 2000
        data.append(coverIntValueToThressByteData(value: Distance))
        
        let splats:UInt16 = 100
        data += splats
        
        let number:UInt8 = 99
        data += number
        snedUserInforDataBasic(data)
        
    }

    /// 获取workout目标
    func sendGetWorkoutTargetFromDevice() {
        let originalData = Data(bytes: [UserInforCommand.getWorkoutTarger.value])
        snedUserInforDataBasic(originalData)
    }
    
    
    
    /// setting sleep time peroid
    func sendSetSleepTimePeriodToBand() {
        
        var data = Data(bytes: [UserInforCommand.setSleepTimePeriod.value])
        data += 20  //start sleep time hour
        data += 30  //start sleep time minute
        data += 8   //end sleep time hour
        data += 30   //end sleep time minute
        data += 0   //notify switch
        snedUserInforDataBasic(data)
    }
    
    
    /// get sleep time period
    func sendGetSleepTimerPeriodFromBand() {
        let originalData = Data(bytes: [UserInforCommand.getSleepTimePeriod.value])
        snedUserInforDataBasic(originalData)
    }


    /// 将用户信息的数发送到手环
    ///
    /// - Parameter originalData: 要发送的数据
    fileprivate func snedUserInforDataBasic(_ originalData: Data) {

        let data = self.dealDataToTwentyLengthPackage(data: originalData as Data)
        //Send  data
        self.bleOperationMana.sendDataFromAppToBand(data: data, serviceUUIDString: BLESettingServices.SettingService.rawValue, characteristicString: BLEUserInforCharacteristics.UserInfoSettingCharacterUUID.rawValue, writeType: .withoutResponse)

        let commandStr = data.hexEncodedString(options: .upperCase)
        let service = BLESettingServices.SettingService.rawValue
        let characteristic = BLEUserInforCharacteristics.UserInfoSettingCharacterUUID.rawValue
        FDLog("commandStr:\(commandStr) --- service:\(service) --- characteristic:\(characteristic)")

    }

    /// 处理workout目标数据
    ///
    /// - Parameter data: 手环返回的原始数据
    func handleWorkoutTarget(data:Data) {
        
        let byteArray = data.toByteArray()

        let step = byteArray[1,2,3]
        let calorie = byteArray[4,5,6]
        let distance = byteArray[7,8,9]

        let splats: UInt16 = data.scanValue(at: 10)
        let number: UInt8 = data.scanValue(at: 2)

        FDLog("step: \(step), calorie: \(calorie), distance:\(distance), splats:\(splats), number:\(number)")
    }
    
    /// 将值转换为3个字节的数据
    ///
    /// - Parameter value: 需要转化的数值
    /// - Returns: 返回拼接好的Data
    fileprivate func coverIntValueToThressByteData(value:UInt32) ->Data  {

        var originalData = Data.init()

        var valueResult:UInt32 = value
        var  testData = Data(bytes: &valueResult, count: UInt32.size)
        
        print("\(testData[0])--\(testData[1])--\(testData[2])--\(testData[3])")
        
        originalData.append(testData[2])
        originalData.append(testData[1])
        originalData.append(testData[0])

        return originalData

    }

}

