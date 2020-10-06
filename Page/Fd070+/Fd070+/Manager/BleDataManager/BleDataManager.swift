//
//  BleDataManager.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/21.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import FendaBLESwiftLib
import CoreBluetooth

public typealias snedDataReceiveCallBlock = (_ receiveData: Data) -> ()

typealias refreshCurrentRTDataBlock = (_ receiveData: CurrentDataModel) -> ()
typealias refreshWorkoutRTDataBlock = (_ receiveData: WorkoutRTDataModel) -> ()

class BleDataManager: NSObject,bleOperationDelegate {

    
    //单例
    //    public static let instance = BleDataManager.init()
    
    public var bleOperationMana:BleOperatorManager = BleOperatorManager.instance
    
    private static let sharedInstance = BleDataManager()
    
    
    /// 发送指令数据后的回应
    public var sendDataReceiveCallBlock:snedDataReceiveCallBlock?
    
    /// 发送指令数据后的回应
    public var gluReceiveCallBlock:snedDataReceiveCallBlock?
    
    /// 判断过来的实时汇总数据是否有更新
    public var rtDataLastModel:CurrentDataModel = CurrentDataModel()

    /// 上一个实时WorkoutModel
    public var rtDataWorkoutLastModel:WorkoutRTDataModel = WorkoutRTDataModel()
    
    /// 判断过来的实时汇总数据是否有更新
    public var rtDataCurentModel:CurrentDataModel = CurrentDataModel()
    
    /// 返回实时刷新的汇总数据
    public var refreshCurrentRTDataCallBlock:refreshCurrentRTDataBlock?

    /// 判断过来的Workout汇总数据是否有更新
    public var rtDataWorkoutModel:WorkoutRTDataModel = WorkoutRTDataModel()

    /// 返回Workout刷新的汇总数据
    public var refreshWorkoutRTDataCallBlock:refreshWorkoutRTDataBlock?
    
    //运动每分钟的打点数据
    public var dailySportUniteArrayData:[DailyDetailModel] = Array()
    //睡眠每分钟的打点数据
    public var dailySleepUniteArrayData:[SleepDetailDataModel] = Array()
    
    //Workout每分钟的打点数据
    public var workoutUniteArrayData:[WorkoutDetailModel] = Array()
    
    /// 当前正在操作的Model
    public var currentHandleDeviceModel:DeviceInfoModel?
    
    class var instance:BleDataManager {
        
        return sharedInstance
    }
    

    var glucoseCollectModels = [GlucoseCollectModel]()


    override init() {
        super.init()
        self.bleOperationMana = BleOperatorManager.instance
        self.bleOperationMana.delegate = self
        BleSingleton.instance.delegate = self

        
        self.bleOperationMana.connectedDeviceAfterInitCommunicatStream = {
            
            self.currentHandleDeviceModel = try! DeviceInfoDataHelper.findFirstRow(macAddress: CurrentMacAddress) ?? DeviceInfoModel()
            self.sendSetCurrentTime()
            self.getBatteryLevel()
            self.getFrimwareAndSofewareVersion()
            self.sendGetDailyDataFromDevice()
            self.sendGetWorkoutDataFromDevice()

        }
        print("12345")
    }
    
    
    func didReceiveDataFromBand(data: Data, characteristic: CBCharacteristic) {

        let value = String.init(format: "%@", data as CVarArg)

        let printStr = "The original data: " + "\(value)"
        FDLog("Received original data：\(printStr)\n----\(characteristic.uuid.uuidString)")

        switch characteristic.uuid.uuidString {
        case BLEDeviceSettingCharacteristics.deviceInfoSetting.rawValue:
            if self.sendDataReceiveCallBlock != nil {
                self.sendDataReceiveCallBlock!(data)
            }

            let byteArray = data.toByteArray()
            let type = DeviceSettingCommand.init(rawValue: UInt8(byteArray[0]))

            switch type {
            case .Header_ContinuousHRTest?:
                self.handleContinuousHRData(data: data)

            default:
                break
            }

            break
        case BLEDeviceSettingCharacteristics.firmwareData.rawValue:
            var firmware =  NSString(data:data,encoding: String.Encoding.ascii.rawValue)
            
            FDLog("手环硬件版本号:\(String(describing: firmware))")
            if  (firmware?.contains("V"))! {
            }else {
                
                firmware = NSString.init(format: "V%@", firmware!)
            }
            UserDefaults.DeviceInfoUserDefault.Device_FirmVersion.store(value: firmware)
            break
        case BLEDeviceSettingCharacteristics.softwareData.rawValue:
            var sofeware = NSString(data:data ,encoding: String.Encoding.ascii.rawValue)
            FDLog("手环软件版本号:\(String(describing: sofeware))")
            if (sofeware?.contains("V"))! {
            }else {
                sofeware = NSString.init(format: "V%@", sofeware!)
            }
            
            UserDefaults.DeviceInfoUserDefault.Device_SoftVersion.store(value: sofeware)
            
            self.currentHandleDeviceModel?.band_version = sofeware! as String
            let _ =  try! DeviceInfoDataHelper.update(item: self.currentHandleDeviceModel!)


        //处理每秒上报的实时数据
        case SportDataSyncCharacteristics.Data_RealTimeCharacteristics.rawValue:
            UserDefaults.BLEDataSyncFlag.isDataSyncingKey.store(value: false)
            self.handleSportRTData(data: data)
            break
        //处理每分钟实时的数据以及历史数据 handleUnitMinuteDeailyData
        case SportDataSyncCharacteristics.Data_DailyChannelCharacteristics.rawValue:
            UserDefaults.BLEDataSyncFlag.isDataSyncingKey.store(value: true)
         
            self.handleUnitMinuteDeailyData(data: data)
            break
        //处理workout发送过来的数据，包括历史数据和实时汇总数据
        case SportDataSyncCharacteristics.Data_WorkoutChannelCharacteristics.rawValue:
            UserDefaults.BLEDataSyncFlag.isDataSyncingKey.store(value: true)

            self.handleWorkoutData(data: data)
            break;

        case BLEUserInforCharacteristics.UserInfoSettingCharacterUUID.rawValue:  //处理接收到的用户信息
            let byteArray = data.toByteArray()
            let type = UserInforCommand.init(rawValue: UInt8(byteArray[0]))

            switch type {
            case .setUserInfor?:
                self.handleUserInformation(data: data)
                //            case .setWorkoutTarger?:
            ////                self.handleWorkoutTarget(data: data)
            default:
                break
            }
        //
        case GlucoseCharacteristics.characteristicsGlucoseData.rawValue:
            //采数的数据，不是真正的血糖数据。4.11
            //            self.handleGlucoseCollecting(data: data)
            break
        case GlucoseCharacteristics.characteristicsGlucoseCommand.rawValue:
            let byteArray = data.toByteArray()
            let type = GlucoseCommand.init(rawValue: UInt8(byteArray[0]))

            switch type {

            case .startRespond?:
                self.handleHasStartCollect(data: data)
            case .collectingRespond?:
                self.handleCollecting(data: data)
            case .timeOverRespond?:
                self.handleCollectTimeOver(data: data)
                if self.sendDataReceiveCallBlock != nil {
                    self.sendDataReceiveCallBlock!(data)
                }
            case .stopRespond?:
                self.handleStopCollect(data: data)
                if self.sendDataReceiveCallBlock != nil {
                    self.sendDataReceiveCallBlock!(data)
                }
            case .glycemicResultRespond?:

                self.handleGlycemicResult(data: data)


            default:
                break
            }
            
            if self.gluReceiveCallBlock != nil {
                self.gluReceiveCallBlock!(data)
            }
        default:
            break
        }

    }
    
    func enableSpecialCharacteristicsaNotify(characteristic: CBCharacteristic) {
        
        switch characteristic.uuid.uuidString {
        //电量通知使能
        case BLEDeviceSettingCharacteristics.batteryData.rawValue,
             //使能设备设置信息
        BLEDeviceSettingCharacteristics.deviceInfoSetting.rawValue,
        //使能获取版本号
        BLEDeviceSettingCharacteristics.softwareData.rawValue,
        BLEDeviceSettingCharacteristics.firmwareData.rawValue,

        //使能用户设置信息
        BLEUserInforCharacteristics.UserInfoSettingCharacterUUID.rawValue,
        SportDataSyncCharacteristics.Data_RealTimeCharacteristics.rawValue,
        SportDataSyncCharacteristics.Data_WorkoutChannelCharacteristics.rawValue,
        SportDataSyncCharacteristics.Data_DailyChannelCharacteristics.rawValue,
        SportDataSyncCharacteristics.Data_OtherCommandCharacteristics.rawValue,
        //使能血糖数据
        //屏蔽使能血糖数据，该数据现在只是算法使用 4.11
        //        GlucoseCharacteristics.characteristicsGlucoseData.rawValue,
        //使能血糖指令
        GlucoseCharacteristics.characteristicsGlucoseCommand.rawValue:
            //使能对应的特性
            self.bleOperationMana.ownPeripheral.setNotifyValue(true, for: characteristic)
            FDLog("Set notify able\(characteristic)")
            break
        default:
            break
        }
    }
    
    
}

extension BleDataManager:BleHandleMacProtocol {
    
    
    /// 处理Mac地址
    ///<aaaafc13 c3112449>
    /// - Parameter tempMac: 需要处理的mac地址
    /// - Returns: 返回处理好的Mac地址
    func bleHandleBleMac(tempMac: String) -> String {
        
        var macAddress = tempMac
        macAddress = macAddress.replacingOccurrences(of: "<", with: "")
        macAddress = macAddress.replacingOccurrences(of: ">", with: "")
        macAddress = macAddress.replacingOccurrences(of: " ", with: "")
        macAddress = macAddress.uppercased()
        if macAddress.count >= 14  {

            macAddress = String.init(format: "%@:%@:%@:%@:%@:%@",
                                     macAddress[safe:14 ... 15] ?? "FF",
                                     macAddress[safe:12 ... 13] ?? "FF",
                                     macAddress[safe:10 ... 11] ?? "FF",
                                     macAddress[safe:8 ... 9] ?? "FF",
                                     macAddress[safe:6 ... 7] ?? "FF",
                                     macAddress[safe:4 ... 5] ?? "FF")
        }
        DispatchQueue.main.async {
            print("Handle Mac:\(macAddress)")
        }
        
        return macAddress
    }
    
    func dealDataToTwentyLengthPackage(data : Data) -> Data {
        let mutData = NSMutableData.init(data: data)
        if data.count < 20 {
            for _ in 0 ..< 19 - data.count {
                var byte:UInt8 = 0x00
                mutData.append(&byte, length: 1)
            }
            var end:UInt8 = 0x00
            mutData.append(&end, length: 1)
        }
        return mutData as Data
    }
}

// MARK: - Data base update public func
extension BleDataManager {
    func updateCalendarDataFlag(_ timestamp: String) {
        let startOfDayDate = FDDateHandleTool.timestampToDateObject(timestamp: timestamp).startOfDay
        let startOfDayTimestamp = String(format: "%.f", startOfDayDate.timeIntervalSince1970)
        let flagModel = HistroyDataFlagModel.init(timeStamp: startOfDayTimestamp, userId: CurrentUserID, btMac: CurrentMacAddress, dataFlag: "1")
        try! CurrentDayFlagDataHelper.insertOrUpdate(items: [flagModel], complete: {})
    }
}

