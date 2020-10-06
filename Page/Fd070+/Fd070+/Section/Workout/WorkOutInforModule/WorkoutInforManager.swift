//
//  WorkoutInforManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/26.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

struct WorkoutInforManager {

    static func getWorkoutInforModel() ->WorkoutInforModel {

        var model = WorkoutInforModel()
        model.type = "home_steps"
        model.state = "运动中"
        model.value = "00"

        model.step = "0"
        model.durationSecond = "00:00:00"
        model.calorie = "0"
        model.hearRate = "--"

        return model

    }

    static func getWorkoutDurationString(_ sendondStr: String) ->String {

        let sendonds = Int(sendondStr) ?? 0
        var senond = (sendonds % 60).description
        var minute = (sendonds / 60).description
        var hour = (sendonds / (60 * 60)).description

        if senond.count < 2 {
            senond.insert("0", at: senond.startIndex)
        }

        if minute.count < 2 {
            minute.insert("0", at: minute.startIndex)
        }

        if hour.count < 2 {
            hour.insert("0", at: hour.startIndex)
        }

        return hour + ":" + minute + ":" + senond
    }

}
