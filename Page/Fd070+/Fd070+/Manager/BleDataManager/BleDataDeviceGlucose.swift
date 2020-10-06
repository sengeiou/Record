//
//  BleDataDeviceGlucose.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/24.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import CoreBluetooth

/// BLE Servereices
public enum GlucoseServices: String {

    case servicesGlucoseData = "45121540-51F2-406E-927A-3E1E183412E0"
    case servicesGlucoseCommand  = "45121550-51F2-406E-927A-3E1E183412E0"

    // BLE servies uuid
    public var uuid: CBUUID {
        return CBUUID.init(string: self.rawValue)
    }

}
/// BLE Characteristics
public enum GlucoseCharacteristics : String {

    case characteristicsGlucoseData = "45121542-51F2-406E-927A-3E1E183412E0"
    case characteristicsGlucoseCommand = "45121551-51F2-406E-927A-3E1E183412E0"

    // BLECharacteristics uuid
    public var uuid: CBUUID {
        return CBUUID.init(string: self.rawValue)
    }
}


/// Row Data 数据的类型
///
/// - RowData_HR: 只有心率数据
/// - RowData_BloodGlucose: 只有血糖数据
/// - RowData_Step: 只有步数的数据
/// - RowData_BG_BP: 既有血糖的数据，又有血压的数据
enum RowData_type:UInt8 {
    case RowData_HR = 0x00
    case RowData_BloodGlucose = 0x01
    case RowData_Step = 0x02
    case RowData_BG_BP = 0x03
}



enum GlucoseCommand: UInt8 {
    case startCollect = 0x01
    case startRespond = 0x81
    case collectingRespond = 0x82
    case timeOverRespond = 0x83

    case stopCollect = 0x02
    case stopRespond = 0x84

    case glycemicResult = 0x04
    case glycemicResultRespond = 0x85

}

extension BleDataManager {


    /// 处理手环返回的血糖数据
    ///
    /// - Parameter data: 原始的血糖数据
    func handleGlucoseCollecting(data: Data) {
        let byteArray = data.toByteArray()

        let greenLightSignal = byteArray[0,1,2]
        let redLightSignal = byteArray[3,4,5]
        let IRLightSignal = byteArray[6,7,8]

        let accRatiionXAxis = byteArray[9,10]
        let accRatiionYAxis = byteArray[11,12]
        let accRatiionZAxis = byteArray[13,14]

        let greenLightCurrent = byteArray[15]
        let redLightCurrent = byteArray[16]
        let IRLightCurrent = byteArray[17]
        let packageNumber = byteArray[18]
        let packageTheTailToIdentify = byteArray[19]

        let model = GlucoseCollectModel.init(timeStamp: Date.timeStamp, userId: CurrentUserID, btMac: CurrentMacAddress,  greenLightSignal: greenLightSignal.description, redLightSignal: redLightSignal.description, IRLightSignal: IRLightSignal.description, accRatiionXAxis: accRatiionXAxis.description, accRatiionYAxis: accRatiionYAxis.description, accRatiionZAxis: accRatiionZAxis.description, greenLightCurrent: greenLightCurrent.description, redLightCurrent: redLightCurrent.description, IRLightCurrent: IRLightCurrent.description, packageNumber: packageNumber.description, packageTheTailToIdentify: packageTheTailToIdentify.description)

        glucoseCollectModels.append(model)

        FDLog("greenLightSignal:\(greenLightSignal) redLightSignal:\(redLightSignal) IRLightSignal:\(IRLightSignal) accRatiionXAxis:\(accRatiionXAxis) accRatiionYAxis:\(accRatiionYAxis) accRatiionZAxis:\(accRatiionZAxis) greenLightCurrent:\(greenLightCurrent) redLightCurrent:\(redLightCurrent) IRLightCurrent:\(IRLightCurrent) packageNumber:\(packageNumber) packageTheTailToIdentify:\(packageTheTailToIdentify) ")
        
        //判断测试时间是否已经到了
        let currentTimeStamp = Int(FDDateHandleTool.timeStamp)
        if currentTimeStamp! - AppDelegate.getDelegate().BloodStartTestTime > 60 {
            
            self.handleStopCollect(data: Data())
            //4.3 abating.
            AppDelegate.getDelegate().BloodStartTestTime = Int(FDDateHandleTool.timeStamp)!
//            print("测试血糖时间到")
        }
        else
        {
//            print("测试血糖时间未到\(currentTimeStamp! - AppDelegate.getDelegate().BloodStartTestTime)")
        }
    }

    /// 发送开始收集血糖数据的指令
    func sendStartCollectGlucoseDataToDevice(_ receiveCallBlock:@escaping snedDataReceiveCallBlock) {

        self.sendDataReceiveCallBlock = receiveCallBlock
        
        var command: UInt8 = UInt8(GlucoseCommand.startCollect.rawValue)
        let originalData = NSMutableData()

        let acquisitionTime = Int16(1 )

        originalData.append(&command, length: 1)
        originalData.appendInt16(value: Int16(acquisitionTime))
        setDataGlucoseCommand(data: originalData as Data)
    }
    
    /// 发送停止收集血糖数据的指令
    func sendStopCollectGlucoseDataToDevice(_ receiveCallBlock:@escaping snedDataReceiveCallBlock) {
        
        self.sendDataReceiveCallBlock = receiveCallBlock
        
        var command: UInt8 = UInt8(GlucoseCommand.stopCollect.rawValue)
        var data = Data.init()
        data.append(&command, count: 1)
        setDataGlucoseCommand(data: data)
    }
    
    
    
    

    /// 处理已经开始收集血糖的数据
    ///
    /// - Parameter data: 手环返回的原始数据
    func handleHasStartCollect(data: Data) {

    }

    /// 处理正在收集血糖的数据
    ///
    /// - Parameter data: 手环返回的原始数据
    func handleCollecting(data: Data) {

    }

    /// 处理收集血糖完成的数据
    ///
    /// - Parameter data: 手环返回的原始数据
    func handleCollectTimeOver(data: Data) {
        print("测试血糖手环端结束")
        self.sendStopCollectGlucoseDataToDevice { (receiveData) in
            
            let randomArray = ["2","2","2","2","2","2","2","2","2","1"]
            
            let value:String = randomArray[Int(arc4random()%10)]
            
            print("血糖结果值：\(value)")
            let currentTimeStamp = Int(FDDateHandleTool.timeStamp)
            if currentTimeStamp! - AppDelegate.getDelegate().BloodStartTestTime > 30 { //超过测量时间的一半才会出一个不准确的结构
                
                print("测试血压完成，插入数据库")
                //结束测试血糖测试时间标志为0
                AppDelegate.getDelegate().BloodStartTestTime = 0
                let model = BloodSugarResultModel.init(userid: CurrentUserID,
                                                       bt_mac: CurrentMacAddress,
                                                       isupload: "0",
                                                       start_time: FDDateHandleTool.timeStamp,
                                                       boolsugar: value)
                try? BloodSugarTestDataHelp.insertOrUpdate(items: [model], complete: {})
                self.sendGluResultToBand(value: UInt8(value)!)
            }
            
        }
    }


    /// 处理停止收集血糖数据
    ///
    /// - Parameter data: 手环返回的原始数据
    func handleStopCollect(data: Data) {
        
        self.sendStopCollectGlucoseDataToDevice { (receiveData) in
            
            let randomArray = ["2","2","2","2","2","2","2","2","2","1"]
            
            let value:String = randomArray[Int(arc4random()%10)]
            
            print("血糖结果值：\(value)")
            
            let currentTimeStamp = Int(FDDateHandleTool.timeStamp)
            if currentTimeStamp! - AppDelegate.getDelegate().BloodStartTestTime > 30 { //超过测量时间的一半才会出一个不准确的结构

                print("测试血压完成，插入数据哭")
                //结束测试血糖测试时间标志为0
                AppDelegate.getDelegate().BloodStartTestTime = 0
                let model = BloodSugarResultModel.init(userid: CurrentUserID,
                                                       bt_mac: CurrentMacAddress,
                                                       isupload: "0",
                                                       start_time: FDDateHandleTool.timeStamp,
                                                       boolsugar: value)
                
                try? BloodSugarTestDataHelp.insertOrUpdate(items: [model], complete: {})
                self.sendGluResultToBand(value: UInt8(value)!)
            }
        }
        
        try? GlucoseCollectDataHelper.insertOrUpdate(items: glucoseCollectModels, complete: {
            print("血糖数据保存数据库完成")
        })
    }

    /// 发送设置血糖结果
    func sendGluResultToBand(value:UInt8) {

        var command: UInt8 = UInt8(GlucoseCommand.glycemicResult.rawValue)
        var data = Data.init()
        var valueK = value
        
        data.append(&command, count: 1)
        data.append(&valueK, count: 1)
        setDataGlucoseCommand(data: data)
    }

    /// 处理发送血糖结果的数据
    ///
    /// - Parameter data: 手环返回的原始数据
    func handleGlycemicResult(data: Data) {
        
    }

    /// 将血糖有关的指令发送到手环
    ///
    /// - Parameter data: 要发送的数据
    fileprivate func setDataGlucoseCommand(data: Data) {

        let data = dealDataToFourLengthPackage(data: data)

        //Send data
        bleOperationMana.sendDataFromAppToBand(data: data, serviceUUIDString: GlucoseServices.servicesGlucoseData.rawValue, characteristicString: GlucoseCharacteristics.characteristicsGlucoseCommand.rawValue, writeType: .withoutResponse)

        let commandStr = data.hexEncodedString(options: .upperCase)
        let service = GlucoseServices.servicesGlucoseData.rawValue
        let characteristic = GlucoseCharacteristics.characteristicsGlucoseCommand.rawValue
        FDLog("commandStr:\(commandStr) --- service:\(service) --- characteristic:\(characteristic)")

    }

    /// 组成4字节的数据包
    ///
    /// - Parameter data: 原始的数据
    /// - Returns: 4字节的数据包
    fileprivate  func dealDataToFourLengthPackage(data : Data) -> Data {
        let mutData = NSMutableData.init(data: data)
        if data.count < 4 {
            for _ in 0 ..< 3 - data.count {
                var byte:UInt8 = 0x00
                mutData.append(&byte, length: 1)
            }
            var end:UInt8 = 0x00
            mutData.append(&end, length: 1)
        }
        return mutData as Data
    }
}
