//
//  BleDataDeviceWorkout.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/24.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import CoreBluetooth

/// BLE Servereices
public enum SportDataSyncServices: String {
    
    //setting  service UUID
    case SportDataSyncServices  = "46440101-4245-4665-6E64-61536D617274"
    
    // BLE servies uuid
    public var uuid: CBUUID {
        return CBUUID.init(string: self.rawValue)
    }
}
/// BLE Characteristics
public enum SportDataSyncCharacteristics : String {
    
    // workout real time summary data and unit point data
    case Data_WorkoutChannelCharacteristics         = "46440102-4245-4665-6E64-61536D617274"
    
    // daily real time data and unit point data
    case Data_DailyChannelCharacteristics         = "46440103-4245-4665-6E64-61536D617274"
    
    // Current_Data characteristic UUID
    case Data_RealTimeCharacteristics        = "46440104-4245-4665-6E64-61536D617274"

    //WokroutDataDetail UUID
    case Data_OtherCommandCharacteristics         = "46440105-4245-4665-6E64-61536D617274"
    
    // BLECharacteristics uuid
    public var uuid: CBUUID {
        return CBUUID.init(string: self.rawValue)
    }
}

/// workout 数据类型
///
/// - Header_WorkoutHistory_Minute: 每分钟的打点数据
/// - Header_Workout_RT_Summary: workout的汇总数据
/// - Header_WorkoutHistory_End: workout打点数据上传结束标志
enum workoutDatatypeCommand:UInt8 {
    case Header_WorkoutHistory_Minute = 0x04
    case Header_Workout_RT_Summary = 0x05
    case Header_WorkoutHistory_End = 0x06
}



/// workout 操作指令
///
/// - workout_UnknowMode: 位置类型
/// - workout_WalkMode: 走
/// - workout_RunMode: 跑
/// - workout_BikeMode: 骑行
/// - workout_RowMode: 行
/// - workout_Header: 包头
/// - workout_AllDataEnd: 所有workout上传完成
enum workoutActiveCommand:UInt8 {
    
    case workout_UnknowMode = 0x00
    case workout_WalkMode = 0x01
    case workout_RunMode = 0x02
    case workout_BikeMode = 0x03
    case workout_RowMode = 0x04
    case workout_Header = 0x05
    case workout_AllDataEnd = 0x06
}



//其他指令操作
enum DataOtherCommandHeader: UInt8 {
    case Header_ErasureFlash = 0x01
    case Header_GetWorkoutData = 0x02
    case Header_GetDailyData = 0x03
    
    var value: UInt8 {
        return rawValue
    }
}

extension BleDataManager {
    
    
    /// 向设备请求daily数据
    func sendGetDailyDataFromDevice() {

        let originalData = Data(bytes: [DataOtherCommandHeader.Header_GetDailyData.value])
        let data = dealDataToTwentyLengthPackage(data: originalData)
        bleOperationMana.sendDataFromAppToBand(data: data, serviceUUIDString: SportDataSyncServices.SportDataSyncServices.rawValue, characteristicString: SportDataSyncCharacteristics.Data_OtherCommandCharacteristics.rawValue, writeType: .withoutResponse)
        
        //获取daily数据时，清除缓存运动以及睡眠对应的数组。
        
        self.dailySleepUniteArrayData = Array()
        self.dailySportUniteArrayData = Array()


        let commandStr = data.hexEncodedString(options: .upperCase)
        let service = SportDataSyncServices.SportDataSyncServices.rawValue
        let characteristic = SportDataSyncCharacteristics.Data_OtherCommandCharacteristics.rawValue
        FDLog("commandStr:\(commandStr) --- service:\(service) --- characteristic:\(characteristic)")

        
    }
    
    
    /// 向设备请求workout的数据
    func sendGetWorkoutDataFromDevice() {


        let originalData = Data(bytes: [DataOtherCommandHeader.Header_GetWorkoutData.value])
        let data = dealDataToTwentyLengthPackage(data: originalData)
        bleOperationMana.sendDataFromAppToBand(data: data, serviceUUIDString: SportDataSyncServices.SportDataSyncServices.rawValue, characteristicString: SportDataSyncCharacteristics.Data_OtherCommandCharacteristics.rawValue, writeType: .withoutResponse)


        let commandStr = data.hexEncodedString(options: .upperCase)
        let service = SportDataSyncServices.SportDataSyncServices.rawValue
        let characteristic = SportDataSyncCharacteristics.Data_OtherCommandCharacteristics.rawValue
        FDLog("commandStr:\(commandStr) --- service:\(service) --- characteristic:\(characteristic)")
    }
    
    
    /// 擦除设备存储的数据
    func sendErasureFlashToDevice() {
        let originalData = Data(bytes: [DataOtherCommandHeader.Header_ErasureFlash.value])
        let data = dealDataToTwentyLengthPackage(data: originalData)
        bleOperationMana.sendDataFromAppToBand(data: data, serviceUUIDString: SportDataSyncServices.SportDataSyncServices.rawValue, characteristicString: SportDataSyncCharacteristics.Data_OtherCommandCharacteristics.rawValue, writeType: .withoutResponse)

        let commandStr = data.hexEncodedString(options: .upperCase)
        let service = SportDataSyncServices.SportDataSyncServices.rawValue
        let characteristic = SportDataSyncCharacteristics.Data_OtherCommandCharacteristics.rawValue
        FDLog("commandStr:\(commandStr) --- service:\(service) --- characteristic:\(characteristic)")


    }
    
    func handleWorkoutData(data:Data) {
        let byteArray = data.toByteArray()
        let commandType = workoutDatatypeCommand.init(rawValue: UInt8(byteArray[0]))
        
        var uint8:UInt8 = 0
        var uint16:UInt16 = 0
        var uint32:UInt32 = 0
        
        let  workoutDataType = {(data: Data) ->WorkoutDetailModel in
            var workoutModel:WorkoutDetailModel = WorkoutDetailModel()
            uint8 = data.scanValue(at: 1)
            workoutModel.workout_type = String(uint8)
            uint32 = data.scanValue(at: 2)
            workoutModel.time = String(uint32)
            uint8 = data.scanValue(at: 6)
            workoutModel.hr = String(uint8)
            uint8 = data.scanValue(at: 7)
            workoutModel.hr_status = String(uint8)
            uint16 = data.scanValue(at: 8)
            workoutModel.step = String(uint16)
            uint32 = data.scanValue(at: 10)
            workoutModel.distance = String(uint32)
            uint16 = data.scanValue(at: 14)
            workoutModel.calorie = String(uint16)
            uint32 = data.scanValue(at: 16)
            workoutModel.workout_duration = String(uint32)
            
            workoutModel.bt_mac = CurrentMacAddress
            workoutModel.userid = CurrentUserID
            workoutModel.isupload = "0"
            return workoutModel
        }
        
        let workoutSummaryDataType = {(data: Data) ->WorkoutSummaryModel in
            var model:WorkoutSummaryModel = WorkoutSummaryModel()

            uint8 = data.scanValue(at: 1)
            model.workout_type = String(uint8)
            uint32 = data.scanValue(at: 2)
            model.start_time = String(uint32)
            model.date = FDDateHandleTool.coverTimeStampToDateStr(timeStampStr: String(uint32), formatStr: "yyyy-MM-dd")
            uint8 = data.scanValue(at: 6)
            model.hr = String(uint8)
            uint8 = data.scanValue(at: 7)
            model.hr_state = String(uint8)

            uint16 = data.scanValue(at: 8)
            model.steps = String(uint16)
            uint32 = data.scanValue(at: 10)
            model.distances = String(uint32)
            uint16 = data.scanValue(at: 14)
            model.calories = String(uint16)
            uint32 = data.scanValue(at: 16)
            model.workout_duration = String(uint32)

            model.end_time = String(Int(model.start_time)! + Int(model.workout_duration)!)

            model.target = "0"
            model.target_value = "5"
            model.bt_mac = CurrentMacAddress
            model.userid = CurrentUserID
            model.isupload = "0"
            return model
        }

        let workoutRTDataModel = {(data: Data) ->WorkoutRTDataModel in
            var model: WorkoutRTDataModel = WorkoutRTDataModel()

            uint8 = data.scanValue(at: 1)
            model.workout_type = String(uint8)
            uint32 = data.scanValue(at: 2)
            model.time = String(uint32)
            uint8 = data.scanValue(at: 6)
            model.hr = String(uint8)
            uint8 = data.scanValue(at: 7)
            model.heartStatus = String(uint8)

            uint16 = data.scanValue(at: 8)
            model.step = String(uint16)
            uint32 = data.scanValue(at: 10)
            model.distance = String(uint32)
            uint16 = data.scanValue(at: 14)
            model.calorie = String(uint16)
            uint32 = data.scanValue(at: 16)
            model.workoutDuration = String(uint32)

            return model
        }
        
        switch commandType {
        //04
        case .Header_WorkoutHistory_Minute?:

            let workoutDetailModel = workoutDataType(data)
            FDLog("UnitMinute workoutDetailModel:\(workoutDetailModel)")
            self.workoutUniteArrayData.append(workoutDetailModel)

            updateCalendarDataFlag(workoutDetailModel.time)


        //05
        case .Header_Workout_RT_Summary?:

            let workoutRTDataModel = workoutRTDataModel(data)
            FDLog("workoutRTDataModel:\(workoutRTDataModel)")
            self.rtDataWorkoutModel = workoutRTDataModel

            if self.rtDataWorkoutLastModel == self.rtDataWorkoutModel {
                print("两次上报的workout数据相同")
                return
            }

            if self.refreshWorkoutRTDataCallBlock != nil {
                self.refreshWorkoutRTDataCallBlock!(self.rtDataWorkoutModel)
            }
            self.rtDataWorkoutLastModel = self.rtDataWorkoutModel

            do {

                try WorkoutSummaryDataHelper.insertOrUpdate(items: [workoutSummaryDataType(data)]) {
                    print("插入Workout汇总数据")
                }

            } catch {
                print("插入Workout汇总数据失败")
            }

            //有Workout详情数据。 更新日历是否有数据的标志
            updateCalendarDataFlag(rtDataWorkoutLastModel.time)

        //06
        case .Header_WorkoutHistory_End?:
            
            if self.workoutUniteArrayData.count>0 {
                
                do {
                    
                    try WorkoutDetialDataHelper.insertOrUpdate(items: self.workoutUniteArrayData) {
                        print("插入WorkOut历史打点数据")
                    }
                    
                } catch {
                    print("插入WorkOut历史打点数据错误")
                }
            }
            break
            
        default:
            break
        }
    }

}



