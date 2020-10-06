//
//  MydayModel.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/12.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

struct MydayModel {
    
    enum TypeEnum {
        case walk
        case goal
        case sportTime
        case calorie
        case distance
        case sleepTime
        case bloodSugar
        case heartRate
        case none
    }
    
    var type: TypeEnum = .walk
    var value = ""
    var unit = ""
    var progress: CGFloat = 1
    var description = ""
}

/// 每一秒钟上报的运动数据
@objcMembers class SportRTModel:NSObject {
    var sportType:UInt8 = 0
    var HR: UInt8 = 0
    var HRState: UInt8 = 0
    var step: UInt32 = 0

    var distance: UInt32 = 0
    var calorie: UInt32 = 0
    var mac: String = ""
    var sleepTotalHours: UInt8 = 0
    var sleepTotalMinutes: UInt8 = 0

}

/// 每一秒钟上报的睡眠数据
struct SleepRTModel {
    
    var sleepType:UInt8 = 0
    var lightSleep: UInt16 = 0
    var deepSleep: UInt16 = 0
    var wakeSleep: UInt16 = 0
    
    var sleepStartTime: UInt32 = 0
    var sleepEndTime: UInt32 = 0
    var mac: String = ""
}

/// 每分钟上报的运动数据
struct SportUnitMinuteModel: Encodable {
    
    var step:UInt16 = 0
    var distance:UInt16 = 0
    var calorie:UInt32 = 0
    var HR:UInt8 = 0
    var HRStatus:UInt8 = 0
    var timeStamp:UInt32 = 0
    
    var mac: String = ""
    var uploadFlag: String = ""
    
}


/// 每分钟上报的睡眠数据
struct SleepUnitMinuteModel: Encodable {
    
    var sleepType:UInt8 = 0
    var calorie:UInt32 = 0
    var HR:UInt8 = 0
    var HRStatus:UInt8 = 0
    var step:UInt16 = 0
    var distance:UInt16 = 0
    var timeStamp:UInt32 = 0
    var mac: String = ""
    var uploadFlag: String = ""
    
}



struct WorkoutDataModel:Encodable {
    var workout_Type:UInt8 = 0
    var workout_Time:UInt32 = 0
    var workout_HR:UInt8 = 0
    var workout_HRStatus:UInt8 = 0
    var workout_Step:UInt16 = 0
    var workout_Distance:UInt16 = 0
    var workout_Calorie:UInt32 = 0
    var workout_Duration:UInt32 = 0
}


/// 数据库中查出数据时，使用该Model.
struct workout2HourModel {
    var sum2HStep:Int64 = 0
    var sum2HDistance:Int64 = 0
    var sum2HCalorie:Int64 = 0
    var sum2HCount:Int64 = 0
    var hour = "0"
}

/// 每分钟上报的数据（Daily数据。 手环每分钟会保存，如果App与手环连接且使能了，就每分钟会上报数据）
struct DailyDetailModel: Encodable {

    var userid = ""
    var bt_mac = ""
    var isupload  = ""

    var typeData = ""
    var index = ""
    var timeStamp = ""
    var hr = ""

    var hrStatus = ""
    var step = ""
    var distance = ""
    var calorie = ""

    var sleepValue = ""
}

/// 日汇总数据（手环不上报，用做App汇总显示用）
struct DailySummaryModel: Encodable {
    var userId = ""
    var btMac = ""
    var uploadFlag  = ""

    var timeStamp = ""
    var distance = ""
    var calorie = ""
    var step = ""

    var deepSleepTime = ""
    var lightSleepTime = ""
    var awakeTime = ""
}

struct SleepScheduleModel: Encodable {
    var userId = ""
    var btMac = ""
    var uploadFlag  = ""

    var startHourTime = ""
    var startMinuteTime = ""
    var endHourTime = ""
    var endMinuteTime = ""
    var switchOfNofication = ""
}

/**以下是以数据库文档新建的Model*/

//实时数据
struct CurrentDataModel: Encodable, Equatable {
    var userid = ""
    var bt_mac = ""
    var isupload  = ""

    var time = ""
    var device_state = ""
    var hr = ""
    var hr_stateus = ""

    var step = ""
    var distance = ""
    var calorie = ""
    var sleep_hour = ""
    var sleep_minutes = ""

    var light_sleep_time = ""
    var deep_sleep_time = ""
    var wake_sleep_time = ""
    var start_sleep_time = ""
    var end_sleep_time = ""
    
    
    /// 遵守Equatable协议，并实现该方法 可以让model具有 == 功能 去掉当前时间戳的比较。
    static func == (lhs: CurrentDataModel, rhs: CurrentDataModel) -> Bool {
        return  lhs.userid == rhs.userid &&
            lhs.bt_mac == rhs.bt_mac &&
            lhs.isupload == rhs.isupload &&
            lhs.device_state == rhs.device_state &&
            lhs.hr == rhs.hr &&
            lhs.hr_stateus == rhs.hr_stateus &&
            lhs.step == rhs.step &&
            lhs.distance == rhs.distance &&
            lhs.calorie == rhs.calorie &&
            lhs.sleep_hour == rhs.sleep_hour &&
            lhs.sleep_minutes == rhs.sleep_minutes &&
            lhs.light_sleep_time == rhs.light_sleep_time &&
            lhs.deep_sleep_time == rhs.deep_sleep_time &&
            lhs.wake_sleep_time == rhs.wake_sleep_time &&
            lhs.start_sleep_time == rhs.start_sleep_time &&
            lhs.end_sleep_time == rhs.end_sleep_time
        
    }

}

//日明细数据
struct DailyDataModel: Encodable {
    var userid = ""
    var bt_mac = ""
    var isupload  = ""

    var time = ""
    var type_data = ""
    var step = ""
    var distance = ""
    var calorie = ""
    var hr = ""
    var hr_status = ""
}
//运动明细
struct SportDetailDataModel: Encodable {
    var userid = ""
    var bt_mac = ""
    var isupload  = ""

    var time = ""
    var type_data = ""
    var step = ""
    var distance = ""
    var calorie = ""
    var hr = ""
    var hr_status = ""
}
//运动概要
struct SportSummaryDataModel: Encodable {
    var userid = ""
    var bt_mac = ""
    var isupload  = ""

    var sportid = ""
    var steps = ""
    var calories = ""
    var kilometres = ""

    var reached = ""
    var rate = ""
    var date = ""
    var goal = ""

    var sport_duration = ""
    
}
//睡眠明细
struct SleepDetailDataModel: Encodable {
    var userid = ""
    var bt_mac = ""
    var isupload  = ""

    var sleep_time = ""
    var sleep_value = ""  //0 ther, 1 light sleep, 2 deep sleep, 3 sober
    var calorie = ""

    var hr = ""
    var hr_status = ""
    var step = ""
    var distance = ""


}
//睡眠概要
struct SleepSummaryDataModel: Encodable {
    var userid = ""
    var bt_mac = ""
    var isupload  = ""

    var date = ""
    var start_time = ""
    var end_time = ""
    var deep_sleep = ""
    var light_sleep = ""
    var awake = ""
    var sleep_quality = ""
    var sleep_durtaion = ""
    var reached = ""

}


//网络同步的结果
enum NetworkoutSyncError {
    case notNeedUpload
    case networkNotReachability
    case dataBaseError
    case timeout
    case other
}

enum NetworkoutSyncResult {
    case failure(NetworkoutSyncError)
    case success()
}

