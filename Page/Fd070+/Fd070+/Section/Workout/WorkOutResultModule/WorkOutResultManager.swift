//
//  WorkOutResultManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/26.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

struct WorkOutResultManager {
    static func getWorkOutResultModel() ->WorkOutResultModel {

        let workoutSummaryModelLatest = try! WorkoutSummaryDataHelper.FindLatestWorkoutTarget(userID: CurrentUserID, macAddress: CurrentMacAddress)

        var workOutResultModel = WorkOutResultModel()

        let startDateStr = FDDateHandleTool.coverTimeStampToDateStr(timeStampStr: workoutSummaryModelLatest.start_time, formatStr: "HH:mm")
        let endDateStr = FDDateHandleTool.coverTimeStampToDateStr(timeStampStr: workoutSummaryModelLatest.end_time, formatStr: "HH:mm")

        workOutResultModel.title = startDateStr + "-" + endDateStr
        workOutResultModel.value = workoutSummaryModelLatest.steps
        workOutResultModel.value.filterDBStoredString(workoutSummaryModelLatest.steps)

        var model0 = WorkOutResultItemModel()
        model0.type = .heartRate
        model0.mainColor = UIColor.RGB(r: 111, g: 111, b: 190)
        model0.icon = "home_heart_rate"
        //默认的心率值
        model0.value = "0"
        model0.value.filterDBStoredString(workoutSummaryModelLatest.hr)
        model0.unit = "BPM"
        if model0.value == "0" {
            model0.progress = -1
        }else {
            model0.progress = -2
        }

        model0.describe = "静息心率"

        let scheduleStored = Float(workoutSummaryModelLatest.workout_duration) ?? 0
        let distanceStored = Float(workoutSummaryModelLatest.distances) ?? 0

        var goalPercent = "0"
        let target_value = Float(workoutSummaryModelLatest.target_value) ?? 0
        //目标类型(0 距离，1 时长)
        if workoutSummaryModelLatest.target == "0" {
            //蓝牙过来，数据库中存的是厘米 。页面UI的是千米
            goalPercent = String(format: "%.2f", distanceStored / (target_value * 1000 * 100))
        }else {
            //蓝牙过来，数据库中存的是秒 。页面UI的是分钟8
            goalPercent = String(format: "%.2f", scheduleStored / (target_value * 60))
        }

        var model1 = WorkOutResultItemModel()
        model1.type = .distance
        model1.mainColor = UIColor.RGB(r: 0, g: 144, b: 255)
        model1.icon = "home_distance"
        model1.value.filterDBStoredString(workoutSummaryModelLatest.distances)
        model1.unit = "千米"
        model1.progress = goalPercent.toCGFloat()
        model1.describe = "运动距离"


        var model2 = WorkOutResultItemModel()
        model2.type = .schedule
        model2.mainColor = UIColor.RGB(r: 44, g: 64, b: 165)
        model2.icon = "home_time"
        model2.value = getWorkoutDurationString(workoutSummaryModelLatest.workout_duration)
        model2.unit = ""
        model2.progress = goalPercent.toCGFloat()
        model2.describe = "运动时间"


        var model3 = WorkOutResultItemModel()
        model3.type = .calorie
        model3.mainColor = UIColor.RGB(r: 255, g: 218, b: 0)
        model3.icon = "home_calories"
        model3.value.filterDBStoredString(workoutSummaryModelLatest.calories)
        model3.unit = "千卡"
        model3.progress = goalPercent.toCGFloat()
        model3.describe = "消耗卡路里"

        
        workOutResultModel.workOutResultItemModels = [model0, model2, model3,model1]
        return workOutResultModel
    }

    static func getLatestResultModel() ->WorkOutResultModel {

        let workoutSummaryModelLatest = try! WorkoutSummaryDataHelper.FindLatestWorkoutTarget(userID: CurrentUserID, macAddress: CurrentMacAddress)

        var workOutResultModel = WorkOutResultModel()

        workOutResultModel.date = "上一次锻炼总步数"
        workOutResultModel.value.filterDBStoredString(workoutSummaryModelLatest.steps)

        var model0 = WorkOutResultItemModel()
        model0.type = .heartRate
        model0.mainColor = UIColor.RGB(r: 111, g: 111, b: 190)
        model0.icon = "home_heart_rate"
        //默认的心率值
        model0.value = "0"
        model0.value.filterDBStoredString(workoutSummaryModelLatest.hr)
        model0.unit = "BPM"
        if model0.value == "0" {
            model0.progress = -1
        }else {
            model0.progress = -2
        }

        model0.describe = "静息心率"
        let scheduleStored = Float(workoutSummaryModelLatest.workout_duration) ?? 0
        let distanceStored = Float(workoutSummaryModelLatest.distances) ?? 0

        var goalPercent = "0"
        let target_value = Float(workoutSummaryModelLatest.target_value) ?? 0
        //目标类型(0 距离，1 时长)
        if workoutSummaryModelLatest.target == "0" {
            //蓝牙过来，数据库中存的是厘米 。页面UI的是千米
            goalPercent = String(format: "%.2f", distanceStored / (target_value * 1000 * 100))
        }else {
            //蓝牙过来，数据库中存的是秒 。页面UI的是分钟8
            goalPercent = String(format: "%.2f", scheduleStored / (target_value * 60))
        }


        var model1 = WorkOutResultItemModel()
        model1.type = .distance
        model1.mainColor = UIColor.RGB(r: 0, g: 144, b: 255)
        model1.icon = "home_distance"
        model1.value.filterDBStoredString(workoutSummaryModelLatest.distances)
        model1.unit = "千米"
        model1.progress = goalPercent.toCGFloat()
        model1.describe = "运动距离"

        var model2 = WorkOutResultItemModel()
        model2.type = .schedule
        model2.mainColor = UIColor.RGB(r: 44, g: 64, b: 165)
        model2.icon = "home_time"
        model2.value = getWorkoutDurationString(workoutSummaryModelLatest.workout_duration)
        model2.unit = ""
        model2.progress = goalPercent.toCGFloat()
        model2.describe = "运动时间"

        var model3 = WorkOutResultItemModel()
        model3.type = .calorie
        model3.mainColor = UIColor.RGB(r: 255, g: 218, b: 0)
        model3.icon = "home_calories"
        model3.value.filterDBStoredString(workoutSummaryModelLatest.calories)
        model3.unit = "千卡"
        model3.progress = goalPercent.toCGFloat()
        model3.describe = "消耗卡路里"

        workOutResultModel.workOutResultItemModels = [model0, model2, model3,model1]
        return workOutResultModel
    }


}

// MARK: -  private func
extension WorkOutResultManager {
    static func highlightSportScheduleWords(_ originalString: String) -> NSMutableAttributedString{

        let timeComponents = originalString.components(separatedBy: ":")
        let attributes = [[NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.auto())]]
        let highHour = timeComponents.first!.highlightWordsIn(highlightedWords: "H", attributes: attributes)
        let highMin = timeComponents.last!.highlightWordsIn(highlightedWords: "M", attributes: attributes)

        let tempAttAtr = NSAttributedString.init(string: " ")


        highHour.insert(tempAttAtr, at: highHour.length - 1)
        highMin.insert(tempAttAtr, at: highMin.length - 1)

        highHour.append(highMin)
        return highHour
    }

    static func coverDistanceValue(distance: String) -> (String, String) {

        var distanceResult = ""
        var distanceUnit = ""
        if distance > "100000" {

            distanceResult = String(format: "%.2f", (distance.toCGFloat() / CGFloat(100000)))
            distanceUnit = "MydayVC_distance_unitKM".localiz()
        }else {
            distanceResult = String(format: "%.2f", (distance.toCGFloat() / CGFloat(1000)))
            distanceUnit = "MydayVC_distance_unitM".localiz()
        }

        return (distanceResult, distanceUnit)

    }

    static func coverCalorieValue(calorie: String) -> (String, String) {

        var calorieResult = ""
        var calorieUnit = ""
        if calorie > "1000" {

            calorieResult = String(format: "%.2f", (calorie.toCGFloat() / CGFloat(1000)))
            calorieUnit = "MydayVC_calorie_unitK".localiz()
        }else {
            calorieResult = String(format: "%.2f", (calorie.toCGFloat() / CGFloat(1000)))
            calorieUnit = "MydayVC_calorie_unit".localiz()
        }

        return (calorieResult, calorieUnit)

    }
    static func getWorkoutDurationString(_ sendondStr: String) ->String {

        let sendonds = Int(sendondStr) ?? 0

        let minute = (sendonds / 60).description
        let hour = (sendonds / (60 * 60)).description
        return hour + "H:" + minute + "M"
    }

}

// MARK: - Filter data base sting
extension String {
    mutating func filterDBStoredString(_ DBString: String) {

        if !DBString.isEmpty {
            self = DBString
        }
    }
}
