//
//  WorkoutHistoryManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/11.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

struct WorkoutHistoryManager {
    static func getWorkoutHistoryModel() ->[WorkoutHistoryModel] {
        let dataSource = try! WorkoutSummaryDataHelper.find(CurrentUserID, CurrentMacAddress)
        return dataSource
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


    static func coverDistanceValue(distance: String) -> (String, String) {

        var value = distance
        if value.contains(".") {
            value = String(value.dropLast().dropLast())
        }
        let valueFloat = value.toCGFloat()

        var distanceResult = ""
        var distanceUnit = ""
        if valueFloat > 100000 {

            distanceResult = String(format: "%.2f", (valueFloat / CGFloat(100000)))
            distanceUnit = "MydayVC_distance_unitKM".localiz()
        }else {
            distanceResult = String(format: "%.2f", (valueFloat / CGFloat(100)))
            distanceUnit = "MydayVC_distance_unitM".localiz()
        }

        return (distanceResult, distanceUnit)

    }

    static func coverCalorieValue(calorie: String) -> (String, String) {

        var value = calorie
        if value.contains(".") {
            value = String(value.dropLast().dropLast())
        }
        let valueFloat = value.toCGFloat()
        
        var calorieResult = ""
        var calorieUnit = ""
        if valueFloat > 1000 {

            calorieResult = String(format: "%.2f", (valueFloat / CGFloat(1000)))
            calorieUnit = "MydayVC_calorie_unitK".localiz()
        }else {
            calorieResult = String(format: "%.2f", (valueFloat))
            calorieUnit = "MydayVC_calorie_unit".localiz()
        }

        return (calorieResult, calorieUnit)

    }
    
}
