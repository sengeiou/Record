//
//  BleDataDevcieDaily.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/24.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import Foundation

/// 每分钟daily数据的包头
///
/// - Header_UnitMinuteDaily: 包头
/// - Header_UnitMinuteEndDaily: 结束符
enum DailyCommand: UInt8 {
    case Header_UnitMinuteRTDaily = 0x02
    case Header_UnitMinuteHistoryDaily = 0x01
    case Header_UnitMinuteHistoryEndDaily = 0x03
}
/// 每分钟上报数据的类型
///
/// - deily_NodeDataType: Node数据
/// - deily_SleepDataType: sleep数据
enum DailyUnitMinutesDataType:UInt8 {
    case deily_NodeDataType = 0x01
    case deily_SleepDataType = 0x02

}

/// 心率当前测试的模式
///
/// - HR_DefaultModel: 默认模式
/// - HR_AppTestModel: APP触发测试心率
/// - HR_ManualtestModel: 设备端手动触发测试心率
/// - HR_AlgorithmtestModel: 算法启动测试心率
enum DailyHRTestModel:UInt8 {
    case HR_DefaultModel = 0x00
    case HR_AppTestModel = 0x01
    case HR_ManualtestModel = 0x02
    case HR_AlgorithmtestModel = 0x03
}


/// 睡眠的具体类型
///
/// - sleep_otherType: 为止类型
/// - sleep_lightType: 浅睡
/// - sleep_deepType: 深睡
/// - sleep_wakeType: 清醒
enum Daily_SleepType:UInt8 {
    case sleep_otherType = 0x00
    case sleep_lightType = 0x01
    case sleep_deepType = 0x02
    case sleep_wakeType = 0x03
    
}



/// Daily 实时数据的类型
///
/// - Header_UnknowMode: 未知类型
/// - Header_WalkMode: 走
/// - Header_RunMode: 跑
/// - Header_BikeMode: 骑行
/// - Header_RowMode: 原始数据
/// - Header_SleepMode: 睡眠数据
/// - Header_SecondMode: 第二包的包头
enum DeviceDailyRTCommand: UInt8 {
    case Header_UnknowMode = 0x00
    case Header_WalkMode = 0x01
    case Header_RunMode = 0x02
    case Header_BikeMode = 0x03
    case Header_RowMode = 0x04
    case Header_SleepMode = 0x05
    case Header_SecondMode = 0x06
}
extension BleDataManager {
    
    /// 处理实时的汇总数据
    ///
    /// - Parameter data: 需要解析的数据
    func handleSportRTData(data:Data) {

        let byteArray = data.toByteArray()
        let type = DeviceDailyRTCommand.init(rawValue: UInt8(byteArray[0]))

        
        var uint8:UInt8 = 0
        var uint16:UInt16 = 0
        var uint32:UInt32 = 0

        
        if type == .Header_SecondMode {   //current second Data
            
            uint16 = data.scanValue(at: 1)
            self.rtDataCurentModel.light_sleep_time = String(uint16)
            uint16 = data.scanValue(at: 3)
            self.rtDataCurentModel.deep_sleep_time = String(uint16)
            uint16 = data.scanValue(at: 5)
            self.rtDataCurentModel.wake_sleep_time = String(uint16)
            uint32 = data.scanValue(at: 7)
            self.rtDataCurentModel.start_sleep_time = String(uint32)
            uint32 = data.scanValue(at: 11)
            self.rtDataCurentModel.end_sleep_time = String(uint32)
            self.rtDataCurentModel.bt_mac = BleConnectState.getCurrentConnectMacAdress()
            self.rtDataCurentModel.isupload = "0"
            self.rtDataCurentModel.userid = CurrentUserID
            self.rtDataCurentModel.time = Date().startOfDayTimestamp
            
            //MARK: 使用实时数据上传的定时性，可以检测数据定时上传，可以检测是否在同步数据，对于数据刷新，更新UI, 内部可以判断。所有这里屏蔽了。
            //            if self.rtDataLastModel == self.rtDataCurentModel {
            //                print("两次上报的实时数据相同")
            //                return
            //            }

            if self.refreshCurrentRTDataCallBlock != nil {
                self.refreshCurrentRTDataCallBlock!(self.rtDataCurentModel)
            }
            self.rtDataLastModel = self.rtDataCurentModel
            
            do {
                try CurrentDataHelper.insertOrUpdate(items: [self.rtDataCurentModel], complete: {})

            } catch _ {
                FDLog("inster default DeviceInfo  error")
            }
            //有Dail汇总数据。 更新日历是否有数据的标志
            updateCalendarDataFlag(rtDataCurentModel.time)
        }else {
            
            uint8 = data.scanValue(at: 0)
            self.rtDataCurentModel.device_state = String(uint8)
            uint8 = data.scanValue(at: 1)
            self.rtDataCurentModel.hr = String(uint8)
            uint8 = data.scanValue(at: 2)
            self.rtDataCurentModel.hr_stateus = String(uint8)
            uint32 = data.scanValue(at: 3)
            self.rtDataCurentModel.step = String(uint32)
            uint32 = data.scanValue(at: 7)
            self.rtDataCurentModel.distance = String(uint32)
            uint32 = data.scanValue(at: 11)
            self.rtDataCurentModel.calorie = String(uint32)
            uint8 = data.scanValue(at: 15)
            self.rtDataCurentModel.sleep_hour = String(uint8)
            uint8 = data.scanValue(at: 16)
            self.rtDataCurentModel.sleep_minutes = String(uint8)

            print(self.rtDataCurentModel)
            
        }
        
    }
    
    
    /// 处理每分钟上报的数据
    ///
    /// - Parameter data: 设备发送过来的数据
    func handleUnitMinuteDeailyData(data:Data) {
        
        let byteArray = data.toByteArray()
        let commandType = DailyCommand.init(rawValue: UInt8(byteArray[0]))
        let type = DailyUnitMinutesDataType.init(rawValue: UInt8(byteArray[5]))
        
        var uint8:UInt8 = 0
        var uint16:UInt16 = 0
        var uint32:UInt32 = 0
        
        let  nodeDataType = {(data: Data) ->DailyDetailModel in
            var sportMinuteModel:DailyDetailModel = DailyDetailModel()
            uint32 = data.scanValue(at: 1)
            sportMinuteModel.timeStamp = String(uint32)
            uint8 = data.scanValue(at: 5)
            sportMinuteModel.typeData = String(uint8)
            uint16 = data.scanValue(at: 6)
            sportMinuteModel.step = String(uint16)
            uint32 = data.scanValue(at: 8)
            sportMinuteModel.distance = String(uint32)
            uint16 = data.scanValue(at: 12)
            sportMinuteModel.calorie = String(uint16)
            uint8 = data.scanValue(at: 14)
            sportMinuteModel.hr = String(uint8)
            uint8 = data.scanValue(at: 15)
            sportMinuteModel.hrStatus = String(uint8)
            
            sportMinuteModel.bt_mac = CurrentMacAddress
            sportMinuteModel.userid = CurrentUserID
            sportMinuteModel.isupload = "0"
            return sportMinuteModel
        }
        
        let  sleepDataType = {(data: Data) ->SleepDetailDataModel in
            var sleepMinuteModel:SleepDetailDataModel = SleepDetailDataModel()
            uint32 = data.scanValue(at: 1)
            sleepMinuteModel.sleep_time = String(uint32)
            uint8 = data.scanValue(at: 6)
            sleepMinuteModel.sleep_value = String(uint8)
            uint32 = data.scanValue(at: 7)
            sleepMinuteModel.calorie = String(uint32)
            uint8 = data.scanValue(at: 11)
            sleepMinuteModel.hr = String(uint8)
            uint8 = data.scanValue(at: 12)
            sleepMinuteModel.hr_status = String(uint8)
            uint16 = data.scanValue(at: 13)
            sleepMinuteModel.step = String(uint16)
            uint16 = data.scanValue(at: 15)
            sleepMinuteModel.distance = String(uint16)
            
            sleepMinuteModel.bt_mac = CurrentMacAddress
            sleepMinuteModel.userid = CurrentUserID
            sleepMinuteModel.isupload = "0"
            return sleepMinuteModel
        }
        
        switch commandType {

        //01
        case .Header_UnitMinuteHistoryDaily?:   //处理历史打点数据
            switch type {
            case .deily_NodeDataType?:
                let dailyDetailModel = nodeDataType(data)
                FDLog("Histroy dailyDetailModel:\(dailyDetailModel)")
                dailySportUniteArrayData.append(dailyDetailModel)

                updateCalendarDataFlag(dailyDetailModel.timeStamp)
                break
            case .deily_SleepDataType?:
                let sleepDetailDataModel = sleepDataType(data)
                FDLog("Histroy sleepDetailDataModel:\(sleepDetailDataModel)")
                dailySleepUniteArrayData.append(sleepDetailDataModel)

                updateCalendarDataFlag(sleepDetailDataModel.sleep_time)
                break
            case .none:
                break
            }
            break

        //02
        case .Header_UnitMinuteRTDaily?: //处理实时每分钟的打点数据
            switch type {
            case .deily_NodeDataType?:

                let dailyDetailModel = nodeDataType(data)
                FDLog("UnitMinute dailyDetailModel:\(dailyDetailModel)")
                try? DailyDetailDataHelper.insertOrUpdate(items: [dailyDetailModel], complete: {})

                updateCalendarDataFlag(dailyDetailModel.timeStamp)

            case .deily_SleepDataType?:

                let sleepDetailDataModel = sleepDataType(data)
                FDLog("UnitMinute sleepDetailDataModel:\(sleepDetailDataModel)")
                try? SleepDetailDataHelper.insertOrUpdate(items: [sleepDetailDataModel], complete: {})

                updateCalendarDataFlag(sleepDetailDataModel.sleep_time)

            case .none:
                break
            }



        //03
        case .Header_UnitMinuteHistoryEndDaily?:
            if dailySportUniteArrayData.count>0 {
                
                do {
                    try DailyDetailDataHelper.insertOrUpdate(items: dailySportUniteArrayData) {
                        print("插入历史运动打点数据")
                    }
                    
                } catch {
                    print("插入历史数据错误")
                }
            }
            
            if dailySleepUniteArrayData.count>0 {
                
                do {
                    try SleepDetailDataHelper.insertOrUpdate(items: dailySleepUniteArrayData) {
                        print("插入历史睡眠打点数据")
                    }
                    
                } catch {
                    print("插入历史数据错误")
                }
            }
            print("daily 历史数据同步完成，更新数据库操作并发出通知")
            break
        default:
            break
        }
    }

}
