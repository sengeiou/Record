//
//  MydayManager.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/12.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

private struct Constant {
    
    static var currentHours = 10
}

struct MydayManager {
    
    static var userModel = UserInfoModel()
    static var currentModel = CurrentDataModel()
    
    
    //models
    static var mainDataSource = [MydayModel]()
    static var chartDataSource = [ChartModel]()
    
    static var pointModelsStep = [DescModel]()
    static var pointModelsGoal = [DescModel]()
    static var pointModelsSprotTime = [DescModel]()
    static var pointModelsCalorie = [DescModel]()
    static var pointModelsDistance = [DescModel]()
    static var pointModelsSleepTime = [DescModel]()
    static var pointModelsBloodGlucoss = [DescModel]()
    static var pointModelsHR = [DescModel]()
    
}
// MARK: - Access dataBase
extension MydayManager {
    
    fileprivate static func getUserModel() {
        
        //Query userinfor data
        userModel = try! UserinfoDataHelper.findFirstRow(userID: CurrentUserID) 


    }
    
    fileprivate  static func getCurrentModel() {
        let queryStr = Date().startOfDayTimestamp
        currentModel = try! CurrentDataHelper.findFirstRow(userID: CurrentUserID, macAddress: CurrentMacAddress,currentDate: queryStr) ?? CurrentDataModel()

    }

    static func getCurrentMydatData(dayModelCompletion: @escaping ([MydayModel]) -> Void, chartModelCompletion: @escaping ([ChartModel]) -> Void ) {
        
        DispatchQueue.global().sync {

            initModels()

            getUserModel()
            getCurrentModel()

            let todayDateStr = FDDateHandleTool.getCurrentDate(dateType: "yyyy/MM/dd")
            let dataArray = try? DailyDetailDataHelper.getWorkoutBy2Hour(date: todayDateStr, macAddress: CurrentMacAddress)
            var bloodGlucossArr = try? BloodSugarTestDataHelp.findCurrentData(date: todayDateStr, macAddress: CurrentMacAddress)
            let dataHRArray = try? DailyDetailDataHelper.findHRData(date: todayDateStr, macAddress: CurrentMacAddress)

            handleDatabaseCurrentData(&bloodGlucossArr)
            handleDatabaseSportUnitMinuteHRData(dataHRArray)
            handleDatabaseSportUnitMinutesSportData(dataArray)

            handleMaydaySummaryData()
            handleMaydayDetailData()

            DispatchQueue.main.async {
                //                print("mainDataSource.count\(mainDataSource.count)")
                //Callback myday data summary
                dayModelCompletion(mainDataSource)

                //Callback myday data detail
                chartModelCompletion(chartDataSource)
            }


        }

    }
}
// MARK: - Handle database Data
extension MydayManager {
    static func handleDatabaseSportUnitMinutesSportData(_ dataArray: [workout2HourModel]? ) {

        guard let data = dataArray else {
            return
        }

        for model in data {
            
            let description = model.hour
            //步数
            let poinModelStep = DescModel.init(description, [PointModel.init(.none, CGFloat(model.sum2HStep))])
            pointModelsStep.append(poinModelStep)
            
            //目标百分比
            let percent = String(format: "%.2f", ((CGFloat(model.sum2HStep) * 100) / userModel.goal.toCGFloat()))
            let percentFloat = percent.toCGFloat()
            let percentValue = percentFloat > 100 ? "100" : percent
            
            let poinModelGoal = DescModel.init(description, [PointModel.init(.none, percentValue.toCGFloat())])
            pointModelsGoal.append(poinModelGoal)
            
            //卡路里单位换算
            let sum2HCalorie = CGFloat(model.sum2HCalorie)
            //            if sum2HCalorie > 1000 {
            //                sum2HCalorie /= 1000
            //            }
            let poinModelCalorie = DescModel.init(description, [PointModel.init(.none, sum2HCalorie)])
            pointModelsCalorie.append(poinModelCalorie)
            
            //距离单位换算
            let sum2HDistance = CGFloat(model.sum2HDistance)
            //            if sum2HDistance > 1000 {
            //                sum2HDistance /= 1000
            //            }

            let poinModelDistance = DescModel.init(description, [PointModel.init(.none, sum2HDistance)])
            pointModelsDistance.append(poinModelDistance)
            
            let poinModelCount = DescModel.init(description, [PointModel.init(.none, CGFloat(model.sum2HCount))])
            pointModelsSprotTime.append(poinModelCount)
            
        }
    }
    
    static func handleDatabaseCurrentData(_ bloodGlucossArr: inout [BloodSugarResultModel]?) {

        guard var data = bloodGlucossArr else {
            return
        }

        //插入一个默认值 3.5
        if data.count == 0 {
            data.append(BloodSugarResultModel())
        }
        
        for model in data {
            let poinModelBloodGlucoss = DescModel.init(model.start_time, [PointModel.init(.none, model.boolsugar.toCGFloat())])
            pointModelsBloodGlucoss.append(poinModelBloodGlucoss)
        }
    }
    
    //处理操作每分钟的运动数据。得到心率数组
    static func handleDatabaseSportUnitMinuteHRData(_ dataHRArray: [DailyDetailModel]?) {

        guard let data = dataHRArray else {
            return
        }
        
        for model in data {
            let poinModelHR = DescModel.init(model.timeStamp, [PointModel.init(.none,  model.hr.toCGFloat())])
            pointModelsHR.append(poinModelHR)
        }
    }
    
}
// MARK: - Handle display Data
extension MydayManager {
    static func handleMaydaySummaryData() {

        mainDataSource.removeAll()

        var currentStep = currentModel.step
        if currentStep == "" {
            currentStep = MydayConstant.normalNoValuePlace
        }
        
        let unitTuple = getUnitsString()
        
        let currentModelStepGoalValue = currentModel.step.toCGFloat()
        
        let goal = String(format: "%.2f", (currentModelStepGoalValue / userModel.goal.toCGFloat()))
        let goalFloat = goal.toCGFloat()

        //Walk
        let stepModel = MydayModel.init(type: .walk, value: currentStep, unit: unitTuple.0, progress: goalFloat, description: "")
        mainDataSource.append(stepModel)// 1360/10000
        
        //Goal
        let goalModel = MydayModel.init(type: .goal, value: setGoalValue(goal), unit: unitTuple.1, progress: goalFloat, description: "")
        mainDataSource.append(goalModel)

        //Sport time
        var pointsSport = [PointModel]()
        for item in pointModelsSprotTime {
            pointsSport.append(item.points.first!)
        }
        let sportTimeTotal = pointsSport.reduce(0, {$0 + $1.yValue})
        let sportTime = setTimeDuration(sportTimeTotal.description)
        let sportTimeModel = MydayModel.init(type: .sportTime, value: sportTime, unit: unitTuple.2, progress: 0, description: "")
        mainDataSource.append(sportTimeModel)
        
        //Calorie
        var currentCalorie = currentModel.calorie
        if currentCalorie == "" {
            currentCalorie = MydayConstant.normalNoValuePlace
        }
        let calorieModel = MydayModel.init(type: .calorie, value: currentCalorie, unit: unitTuple.3, progress: goalFloat, description: "")
        mainDataSource.append(calorieModel)
        
        //Distance
        var currentDistance = currentModel.distance
        if currentDistance == "" {
            currentDistance = MydayConstant.normalNoValuePlace
        }
        let distanceModel = MydayModel.init(type: .distance, value: currentModel.distance, unit: unitTuple.4, progress: goalFloat, description: "")
        mainDataSource.append(distanceModel)
        
        
        //Sleep time
        let sleepTimeModel = MydayModel.init(type: .sleepTime, value: packagingSleepTiem(currentModel), unit: unitTuple.5, progress: 0, description: "")
        mainDataSource.append(sleepTimeModel)
        
        
        //BollSugar
        let bollSugarValue =  MydayManager.coverBloodGluModelResultValue(BloodSugarTestDataHelp.getBloodGluresult())
        let bloodSugarModel = MydayModel.init(type: .bloodSugar, value: bollSugarValue, unit: unitTuple.6, progress: 0, description: "")
        mainDataSource.append(bloodSugarModel)
        
        //TODO: 日汇总没有心率
        //HR
        var currentHR = currentModel.hr
        if currentHR == "" ||  currentHR == " "{
            currentHR = MydayConstant.normalNoValuePlace
        }
        let HRModel = MydayModel.init(type: .heartRate, value: currentHR, unit: unitTuple.7, progress: 0, description: "")
        mainDataSource.append(HRModel)
    }
    
    static func handleMaydayDetailData() {

        chartDataSource.removeAll()

        let unitTuple = getUnitsString()
        
        //Walk
        let walkValueLatest = setNormalChartsValueNoValuePlace(pointModelsStep.last?.points.last?.yValue.description)
        let chartModelWalk = ChartModel.init(type: .walk, value: walkValueLatest, unit: unitTuple.0, descModel: pointModelsStep)
        chartDataSource.append(chartModelWalk)
        
        //Goal
        let goalValueLatest = setNormalChartsValueNoValuePlace(pointModelsGoal.last?.points.first!.yValue.description)
        var percent = String(format: "%.2f", ((goalValueLatest.toCGFloat() * 100) / userModel.goal.toCGFloat()))
        //过滤百分比的显示
        if percent == "nan" {
            percent = "--"
        }else {
            if percent.toCGFloat() > 100 {
                percent = "100"
            }
            percent = String(format: "%.2f", (percent.toCGFloat()))
        }
        
        let chartModelGoal = ChartModel.init(type: .goal, value: percent, unit: unitTuple.1, descModel: pointModelsGoal)
        chartDataSource.append(chartModelGoal)
        
        //Sport time
        let sportCountValueLatest = setTimeDuration(pointModelsSprotTime.last?.points.first!.yValue.description)
        let chartModelsportTime = ChartModel.init(type: .sportTime, value: sportCountValueLatest, unit: unitTuple.2, descModel: pointModelsSprotTime)
        chartDataSource.append(chartModelsportTime)
        
        //Caolorie
        let calorieValueLatest = setNormalChartsValueNoValuePlace(pointModelsCalorie.last?.points.first!.yValue.description)
        let calorieLatestTuple = coverCalorieValue(calorie: calorieValueLatest)
        let chartModelCal = ChartModel.init(type: .calorie, value: calorieLatestTuple.0, unit: calorieLatestTuple.1, descModel: pointModelsCalorie)
        chartDataSource.append(chartModelCal)
        
        //Distance
        let distanceValueLatest = setNormalChartsValueNoValuePlace(pointModelsDistance.last?.points.first!.yValue.description)
        let distanceLatestTuple = coverDistanceValue(distance: distanceValueLatest)
        let chartModelDistance = ChartModel.init(type: .distance, value: distanceLatestTuple.0, unit: distanceLatestTuple.1, descModel: pointModelsDistance)
        chartDataSource.append(chartModelDistance)
        
        //Sleep time
        let SleepCountValueLatest = setTimeDuration(pointModelsSprotTime.last?.points.first!.yValue.description)
        let chartModelsleepTime = ChartModel.init(type: .sleepTime, value: SleepCountValueLatest, unit: unitTuple.5, descModel: pointModelsSprotTime)
        chartDataSource.append(chartModelsleepTime)
        
        //Blood sugar
        let chartModelBloodSugar = ChartModel.init(type: .bloodSugar, value: "", unit: "", descModel: pointModelsBloodGlucoss)
        chartDataSource.append(chartModelBloodSugar)
        
        
        //HR
        let HRValueLatest = setNormalChartsValueNoValuePlace(pointModelsHR.last?.points.first!.yValue.description)
        
        let chartModelHR = ChartModel.init(type: .heartRate, value: HRValueLatest, unit: unitTuple.7, descModel: pointModelsHR)
        chartDataSource.append(chartModelHR)
        
    }
}
extension MydayManager {
    
    
    static func coverBloodGluModelResultValue(_ bloodGluModel: BloodSugarResultModel) -> String {
        if bloodGluModel.boolsugar == "1" {
            return "MydayVC_bloodSugarValue_low".localiz()
        }else if bloodGluModel.boolsugar == "2" {
            return "MydayVC_bloodSugarValue_normal".localiz()
        }else if bloodGluModel.boolsugar == "3" {
            return "MydayVC_bloodSugarValue_high".localiz()
        }
        
        return MydayConstant.bloodSugarNoValuePlace
        
    }
    static func coverBloodGluModelDate(_ model: BloodSugarResultModel) -> String {
        let date = Date.init(timeIntervalSince1970: Double(model.start_time) ?? 0)
        var hour = date.hour.description
        var minute = date.minute.description
        var second = date.second.description
        
        if hour.count < 2 {
            hour.insert("0", at: hour.startIndex)
        }
        if minute.count < 2 {
            minute.insert("0", at: minute.startIndex)
        }
        if second.count < 2 {
            second.insert("0", at: second.startIndex)
        }
        
        var latestDate = hour + ":" + minute + ":" + second
        
        if latestDate ==  "08:00:00" {
            latestDate = MydayConstant.normalNoValuePlace
        }
        return latestDate
        
        
        
    }
    
    static func setNormalChartsValueNoValuePlace(_ originalValue: String?) -> String {
        
        guard let originalString = originalValue else {
            return MydayConstant.normalNoValuePlace
        }
        
        if originalString == "0.0" {
            return MydayConstant.normalNoValuePlace
        }
        
        return originalString
        
        
    }
    
    static func setTimeDuration(_ originalValue: String?) -> String {
        
        guard let originalString = originalValue else {
            return "0H:0M"
        }
        
        let value = originalString.toCGFloat()
        let sportTimeHour = Int(value) / 60
        let sportTimeMinute = Int(value) % 60
        let description = sportTimeHour.description + "H" + ":" + sportTimeMinute.description + "M"
        
        return description
        
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
            goal = String(format: "%.2f", (originalValue.toCGFloat() * 100))
        }
        
        return goal
        
        
    }
    
    static func highlightDurationUnitWords(_ originalString: String) -> NSMutableAttributedString{

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

        var value = distance
        if value.contains(".") {
            value = String(value.dropLast().dropLast())
        }
        let valueFloat = value.toCGFloat()
        //距离单位只有千米 3.4
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
        //        var distance = "0"
        //        if currentModel.distance.toCGFloat() != 0 {
        //            distance = String(format: "%.2f", (currentModel.distance.toCGFloat() / CGFloat(100000)))
        //        }
        //        let distanceUnit = "MydayVC_distance_unitKM".localiz()
        //
        //        return (distance, distanceUnit)
    }
    
    static func coverCalorieValue(calorie: String) -> (String, String) {

        var value = calorie
        if value.contains(".") {
            value = String(value.dropLast().dropLast())
        }
        let valueFloat = value.toCGFloat()
        //卡路里单位只有千卡 3.4
        var calorieResult = ""
        var calorieUnit = ""
        if valueFloat > 1000 {

            calorieResult = String(format: "%.2f", (valueFloat / CGFloat(1000)))
            calorieUnit = "MydayVC_calorie_unitK".localiz()
        }else {
            calorieResult = String(format: "%.2f", valueFloat)
            calorieUnit = "MydayVC_calorie_unit".localiz()
        }

        return (calorieResult, calorieUnit)
        //        var distance = "0"
        //        if currentModel.calorie.toCGFloat() != 0 {
        //            distance = String(format: "%.2f", (currentModel.calorie.toCGFloat() / CGFloat(1000)))
        //        }
        //        let distanceUnit = "MydayVC_calorie_unitK".localiz()
        //
        //        return (distance, distanceUnit)
    }
    
    static func getUnitsString() ->(String, String, String, String, String, String, String, String) {
        
        let latestBloodGlures = BloodSugarTestDataHelp.getBloodGluresult()
        
        let walkUnitStr = "MydayVC_step_unit".localiz()
        let percentUnitStr = "%"
        let sportTimeUnitStr = "MydayVC_time_unit".localiz()
        let calorieUnitStr = "MydayVC_calorie_unit".localiz()
        
        let distanceUnitStr = "MydayVC_distance_unit".localiz()
        let sleepTimeUnitStr = "MydayVC_time_unit".localiz()
        let bloodSugarUnitStr = MydayManager.coverBloodGluModelDate(latestBloodGlures)
        let heartRateUnitStr = "MydayVC_HR_unit".localiz()
        
        return (walkUnitStr, percentUnitStr, sportTimeUnitStr, calorieUnitStr, distanceUnitStr,sleepTimeUnitStr, bloodSugarUnitStr, heartRateUnitStr)
    }

    static func packagingSleepTiem(_ model: CurrentDataModel) ->String {
        //Filter empty value
        var sleepHour = model.sleep_hour
        var sleepMinutes = model.sleep_minutes
        if sleepHour == "" {
            sleepHour = "0"
        }
        if sleepMinutes == "" {
            sleepMinutes = "0"
        }
        //"0H:0M"
        return sleepHour + "H:" + sleepMinutes + "M"
    }
    
    static func initModels() {
        //Init models
        mainDataSource = [MydayModel]()
        chartDataSource = [ChartModel]()
        
        mainDataSource.removeAll()
        chartDataSource.removeAll()
        
        pointModelsStep = [DescModel]()
        pointModelsGoal = [DescModel]()
        pointModelsSprotTime = [DescModel]()
        pointModelsCalorie = [DescModel]()
        pointModelsDistance = [DescModel]()
        pointModelsSleepTime = [DescModel]()
        pointModelsBloodGlucoss = [DescModel]()
        pointModelsHR = [DescModel]()
    }
}


// MARK: - BLE Data
extension MydayManager {
    
    static func realTimeData(_ receiveRealTime: @escaping ([MydayModel]) -> Void) {
        
        
        BleDataManager.instance.refreshCurrentRTDataCallBlock = {model in

            let stepFloat = Float(model.step) ?? 0
            //算出要显示的进度值
            let goal = String(format: "%.2f", (stepFloat / Float(userModel.goal.toCGFloat())))

            //算出要显示的睡眠值
            var dataSouceDisplay = [MydayModel]()
            //Walk
            dataSouceDisplay.append(MydayModel.init(type: .walk, value: model.step, unit: "", progress: goal.toCGFloat(), description: ""))
            //Goal
            dataSouceDisplay.append(MydayModel.init(type: .goal, value: setGoalValue(goal), unit: "", progress: goal.toCGFloat(), description: ""))
            //Sport time
            dataSouceDisplay.append(MydayModel.init(type: .sportTime, value: "", unit: "", progress: goal.toCGFloat(), description: ""))
            //Calorie
            dataSouceDisplay.append(MydayModel.init(type: .calorie, value: model.calorie, unit: "", progress: goal.toCGFloat(), description: ""))
            //Distance
            dataSouceDisplay.append(MydayModel.init(type: .distance, value: model.distance, unit: "", progress: goal.toCGFloat(), description: ""))
            //Sleep time
            dataSouceDisplay.append(MydayModel.init(type: .sleepTime, value: packagingSleepTiem(model), unit: "", progress: goal.toCGFloat(), description: ""))
            //BollSugar
            dataSouceDisplay.append(MydayModel.init(type: .bloodSugar, value: "", unit: "", progress: goal.toCGFloat(), description: ""))
            //HR
            dataSouceDisplay.append(MydayModel.init(type: .heartRate, value: model.hr, unit: "", progress: goal.toCGFloat(), description: ""))
            
            receiveRealTime(dataSouceDisplay)
        }

    }
    
}
//Custom UserDefaults Kes
extension UserDefaults {
    enum BLEDataSyncFlag: String, UserDefaultSettable {
        case isDataSyncingKey
    }
}

