//
//  WorkoutModel.swift
//  FD070+
//
//  Created by WANG DONG on 2019/1/3.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

///  Workout target model
struct WorkoutTargetModel: Encodable {
    var userid = ""
    var bt_mac = ""
    var isupload = ""

    var step = ""
    var calorie = ""
    var distance = ""
    var splatpts = ""
    var number = ""
}


struct WorkoutDetailModel: Encodable {
    var userid = ""
    var bt_mac = ""
    var isupload  = ""

    var sportid = ""
    var workout_type = ""
    var time = ""
    var hr = ""
    var hr_status = ""
    var step = ""
    var calorie = ""
    var distance = ""
    var workout_duration = ""

}
struct WorkoutSummaryModel: Encodable {
    var userid = ""
    var bt_mac = ""
    var isupload  = ""

    var workout_id = ""
    var workout_type = ""
    var start_time = ""
    var end_time = ""

    var hr = ""
    var hr_state = ""
    var steps = ""
    var distances = ""
    var calories = ""

    var workout_duration = ""
    var target = "" //目标类型(0 距离，1 时长)
    var target_value = ""
    var date = ""
}

//Workoutd 实时数据
struct WorkoutRTDataModel: Encodable {

    var workout_type = ""
    var time = ""
    var hr = ""
    var heartStatus = ""

    var step = ""
    var distance = ""
    var calorie = ""
    var workoutDuration = ""


    /// 遵守Equatable协议，并实现该方法 可以让model具有 == 功能 去掉当前时间戳的比较。
    static func == (lhs: WorkoutRTDataModel, rhs: WorkoutRTDataModel) -> Bool {
        return  lhs.workout_type == rhs.workout_type &&
            lhs.hr == rhs.hr &&
            lhs.heartStatus == rhs.heartStatus &&

            lhs.step == rhs.step &&
            lhs.distance == rhs.distance &&
            lhs.calorie == rhs.calorie &&
            lhs.workoutDuration == rhs.workoutDuration

    }

}
