//
//  HistoryManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/14.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

struct HistoryManager {

    /// 获取历史大圆圈的值
    ///
    /// - Returns: 使用实时数据。没有的就使用默认值
    static func getCurrentDayDataModel(_ timstamp: String?) -> [MydayModel] {

        var queryStr = timstamp
        if timstamp == nil {
            queryStr = Date().startOfDayTimestamp
        }

        var model = try! CurrentDataHelper.findFirstRow(userID: CurrentUserID, macAddress: CurrentMacAddress,currentDate: queryStr!) ?? CurrentDataModel()
        //CurrentDataModel

        //算出要显示的进度值
        let stepFloat = Float(model.step) ?? 0
        let goal = String(format: "%.2f", stepFloat / Float(CurrentTargetStep.toCGFloat()))

        var dataSouceDisplay = [MydayModel]()
        if model.step.isEmpty {
            model.step = "0"
        }
        //Walk
        dataSouceDisplay.append(MydayModel.init(type: .walk, value: model.step, unit: "MydayVC_step_unit".localiz(), progress: goal.toCGFloat(), description: ""))
        //Goal
        dataSouceDisplay.append(MydayModel.init(type: .goal, value: setGoalValue(goal), unit: "%", progress: goal.toCGFloat(), description: ""))

        //Sport time
        let queryStre = FDDateHandleTool.coverTimeStampToDateStr(timeStampStr: queryStr!, formatStr: "yyyy/MM/dd")
        //要显示运动时长，要在运动详情表中查出运动的条数
        let dataArray = try? DailyDetailDataHelper.getDataGroupByDay(dayStr: queryStre)


        var sportCount: Int = 0
        if let array = dataArray {
            for resultDict in array {
                let countStr = resultDict["count"] ?? "0"
                sportCount += Int(countStr) ?? 0
            }
        }

        dataSouceDisplay.append(MydayModel.init(type: .sportTime, value: getSportDurationString(sportCount.description), unit: "MydayVC_time_unit".localiz(), progress: 0, description: ""))
        //Calorie
        dataSouceDisplay.append(MydayModel.init(type: .calorie, value: model.calorie, unit: "MydayVC_calorie_unit".localiz(), progress: goal.toCGFloat(), description: ""))
        //Distance
        dataSouceDisplay.append(MydayModel.init(type: .distance, value: model.distance, unit: "MydayVC_distance_unit".localiz(), progress: goal.toCGFloat(), description: ""))
        //"0H:0M"
        //Sleep time
        if model.sleep_hour.isEmpty {
            model.sleep_hour = "0"
        }

        if model.sleep_minutes.isEmpty {
            model.sleep_minutes = "0"
        }

        let sleepTime = model.sleep_hour + "H:" + model.sleep_minutes + "M"

        dataSouceDisplay.append(MydayModel.init(type: .sleepTime, value: sleepTime, unit: "MydayVC_time_unit".localiz(), progress: 0, description: ""))
        //BollSugar
        dataSouceDisplay.append(MydayModel.init(type: .bloodSugar, value: "Medium", unit: "Low/medium \n /hight", progress: goal.toCGFloat(), description: ""))
        if model.hr.isEmpty {
            model.hr = "---"
        }
        //HR
        dataSouceDisplay.append(MydayModel.init(type: .heartRate, value: model.hr, unit: "MydayVC_HR_unit".localiz(), progress: goal.toCGFloat(), description: ""))

        return dataSouceDisplay

    }

    static func getSportDurationString(_ minuteStr: String) ->String {

        let minuteInt = Int(minuteStr) ?? 0
        let minute = (minuteInt % 60).description
        let hour = (minuteInt / 60).description

        return hour + "H:" + minute + "M"
    }

    static func setGoalValue(_ originalValue: String) -> String {

        var goal = originalValue
        let goalCGFloat = goal.toCGFloat()
        if goalCGFloat > CGFloat(1) {
            goal = "100"
        }else  if goalCGFloat == CGFloat(0) {
            goal = MydayConstant.normalNoValuePlace
        }else if goalCGFloat.isNaN {
            goal = MydayConstant.normalNoValuePlace
        }else {
            goal = String(format: "%.2f", (originalValue.toCGFloat() * CGFloat(100)))
        }

        return goal
    }

}
