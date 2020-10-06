//
//  HistroySportChartsManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/13.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

struct HistorySportChartsManager {
    
    private static var calendar: Calendar = {
        var  calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        return calendar
    }()
    
    private static var components: DateComponents = {
        return Calendar.current.dateComponents([.year, .day , .month], from: Date())
    }()
    
    
    static func getHistorySportChartsModel(summaryType: HistorySportSummaryType, sportType: SportType, loadDataDirectionType: HistorySportLoadDataDirectionType, specifyDateStr: String?) -> HistorySportChartsModel? {
        
        var model = HistorySportChartsModel()
        
        model.summaryType = summaryType
        switch summaryType {
        case .day:
            if loadDataDirectionType == .next {
                components.day! += 1
            }else if loadDataDirectionType == .ahead {
                components.day! -= 1
            }
        case .month:
            if loadDataDirectionType == .next {
                components.month! += 1
            }else if loadDataDirectionType == .ahead {
                components.month! -= 1
            }
            
        case .year:
            if loadDataDirectionType == .next {
                components.year! += 1
            }else if loadDataDirectionType == .ahead {
                components.year! -= 1
            }
        }
        
        let date = calendar.date(from: components)!
        
        
        var dateString = ""
        
        switch summaryType {
        case .day:
            
            dateString = converseDateToDateString(date: date, dateFormat: "yyyy/MM/dd")
            
            if date > Date() {
                components.day! -= 1
                return nil
            }
            if specifyDateStr != nil {
                dateString = specifyDateStr!
            }
            let dataArray = try? DailyDetailDataHelper.getWorkoutBy2Hour(date: dateString, macAddress: CurrentMacAddress)
            
            var sportValueModels = [SportValueModel]()
            
            var stepTotalDay: Float = 0
            for model in dataArray! {
                
                var value = ""
                let dayStr = model.hour
                switch sportType {
                case .walk:
                    value = Int(model.sum2HStep).description
                case .target:
                    let stepFloat = (Float(model.sum2HStep.description) ?? 0)
                    let targetStep = Float(CurrentTargetStep) ?? 0
                    let targetStr = String(format: "%.2f", ((stepFloat * 100) / targetStep))
                    stepTotalDay += stepFloat
                    //算出要显示的进度值
                    value = filterPercent(targetStr)
                case .sportTime:
                    value = model.sum2HCount.description
                case .calorie:
                    value = model.sum2HCalorie.description
                case .distance:
                    value = model.sum2HDistance.description
                default:
                    break
                }
                
                let sportValueModel = SportValueModel.init(xValue: dayStr, yValue: value.toCGFloat())
                sportValueModels.append(sportValueModel)
                
            }
            model.values = sportValueModels
            
            //汇总数据
            
            if sportType == .target {
                let stepFloat = (Float(stepTotalDay)) * 100
                let targetStep = Float(CurrentTargetStep) ?? 0
                var targetStr = String(format: "%.2f", (stepFloat / targetStep))
                
                targetStr = filterPercent(targetStr)
                //算出要显示的进度值
                model.value = targetStr
            }else {
                let stepTotel = sportValueModels.reduce(0, {$0 + $1.yValue})
                model.value = stepTotel.description
            }
            
            
            
        case .month:
            
            dateString = converseDateToDateString(date: date, dateFormat: "yyyy/MM")
            
            if date > Date().endOfMonth {
                components.month! -= 1
                return nil
            }
            if specifyDateStr != nil {
                let arr = specifyDateStr?.components(separatedBy: "/")
                let year = arr?[safe: 0] ?? "0"
                let month = arr?[safe: 1] ?? "0"
                dateString = year + "/" + month
            }
            let resultArray = try! DailyDetailDataHelper.getDataGroupByDay(monthStr: dateString)
            var sportValueModels = [SportValueModel]()
            var dataCount: Float = 0
            var stepTotalMonth: Float = 0
            for resultDict in resultArray {
                dataCount = Float(resultDict["count"] ?? "0") ?? 0
                var value = ""
                
                //查出来的天数要减一。比如查询出的月份是1月，但是显示index是用0开始的
                let dayStrStored = resultDict["dayStr"] ?? "1"
                let dayInt = (Int(dayStrStored) ?? 1) - 1
                
                switch sportType {
                case .walk:
                    let stepInt = Int(resultDict["step"] ?? "0") ?? 0
                    value = String(stepInt)
                case .target:
                    let stepFloat = (Float(resultDict["step"] ?? "0") ?? 0) * 100
                    let targetStep = (Float(CurrentTargetStep) ?? 0 ) * dataCount
                    let targetStr = String(format: "%.2f", (stepFloat / targetStep))
                    stepTotalMonth += stepFloat
                    //算出要显示的进度值
                    value = filterPercent(targetStr)
                    
                case .sportTime:
                    value = resultDict["count"] ?? "0"
                case .calorie:
                    value = resultDict["calorie"] ?? "0"
                case .distance:
                    value = resultDict["distance"] ?? "0"
                default:
                    break
                }
                let sportValueModel = SportValueModel.init(xValue: dayInt.description, yValue: value.toCGFloat())
                sportValueModels.append(sportValueModel)
                
            }
            model.values = sportValueModels
            
            //汇总数据
            
            if sportType == .target {
                let stepFloat = (Float(stepTotalMonth)) * 100
                let targetStep = (Float(CurrentTargetStep) ?? 0) * dataCount
                let targetStr = String(format: "%.2f", (stepFloat / targetStep))
                
                //算出要显示的进度值
                model.value = filterPercent(targetStr)
            }else {
                let stepTotel = sportValueModels.reduce(0, {$0 + $1.yValue})
                model.value = stepTotel.description
            }
            
            
        case .year:
            
            dateString = converseDateToDateString(date: date, dateFormat: "yyyy")
            if (Int(dateString) ?? 0) > Date().year {
                components.year! -= 1
                return nil
            }
            
            if specifyDateStr != nil {
                let arr = specifyDateStr?.components(separatedBy: "/")
                dateString = arr?[safe: 0] ?? "0"
            }
            
            let resultArray = try! DailyDetailDataHelper.getDataGroupByMonth(yearStr: dateString)
            var sportValueModels = [SportValueModel]()
            
            var dataCount: Float = 0
            var stepTotalYear: Float = 0
            for resultDict in resultArray {
                dataCount = Float(resultDict["count"] ?? "0") ?? 0
                
                var value = ""
                //查出来的月份要减一。比如查询出的月份是1月，但是显示index是用0开始的
                let monthStrStored = resultDict["monthStr"] ?? "1"
                let monthInt = (Int(monthStrStored) ?? 1) - 1
                
                switch sportType {
                case .walk:
                    let stepInt = Int(resultDict["step"] ?? "0") ?? 0
                    value = String(stepInt)
                case .target:
                    let stepFloat = (Float(resultDict["step"] ?? "0") ?? 0) * 100
                    let targetStep = (Float(CurrentTargetStep) ?? 0 ) * dataCount
                    let targetStr = String(format: "%.2f", (stepFloat / targetStep))
                    //算出要显示的进度值
                    stepTotalYear += stepFloat
                    value = filterPercent(targetStr)
                case .sportTime:
                    value = resultDict["count"] ?? "0"
                case .calorie:
                    value = resultDict["calorie"] ?? "0"
                case .distance:
                    value = resultDict["distance"] ?? "0"
                default:
                    break
                }
                let sportValueModel = SportValueModel.init(xValue: monthInt.description, yValue: value.toCGFloat())
                sportValueModels.append(sportValueModel)
                
            }
            model.values = sportValueModels
            
            //汇总数据
            if sportType == .target {
                let stepFloat = (Float(stepTotalYear)) * 100
                let targetStep = (Float(CurrentTargetStep) ?? 0) * dataCount
                let targetStr = String(format: "%.2f", (stepFloat / targetStep))
                
                //算出要显示的进度值
                model.value = filterPercent(targetStr)
            }else {
                let stepTotel = sportValueModels.reduce(0, {$0 + $1.yValue})
                model.value = stepTotel.description
            }
            
        }
        
        model.date = dateString
        
        var unit = ""
        switch sportType {
        case .walk:
            unit = "步"
        case .target:
            unit = "%"
        case .sportTime:
            unit = ""
            model.value = setTimeDuration(model.value)
        case .calorie:
            let calorieTuple = coverCalorieValue(calorie: model.value)
            unit = calorieTuple.1
            model.value = calorieTuple.0
        case .distance:
            let distanceTuple = coverDistanceValue(distance: model.value)
            unit = distanceTuple.1
            model.value = distanceTuple.0
        default:
            break
        }
        model.unit = unit
        model.type = sportType
        
        return model
    }
    
}
extension HistorySportChartsManager {
    
    /// Cover date object to date string
    ///
    /// - Parameters:
    ///   - date: The date object
    ///   - dateFormat: The coverse dateFormat
    /// - Returns: The date string
    private static func converseDateToDateString(date: Date, dateFormat: String) -> String {
        
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = dateFormat
        let dateStr = dfmatter.string(from: date)
        return dateStr
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
            calorieResult = String(format: "%.2f", (valueFloat))
            calorieUnit = "MydayVC_calorie_unit".localiz()
        }
        
        return (calorieResult, calorieUnit)
        
    }
    static func setTimeDuration(_ originalValue: String) -> String {
        
        let value = originalValue.toCGFloat()
        let sportTimeHour = Int(value) / 60
        let sportTimeMinute = Int(value) % 60
        let description = sportTimeHour.description + "H" + ":" + sportTimeMinute.description + "M"
        
        return description
        
    }
    
    static func filterPercent(_ originalString: String) ->String {
        
        let originalFloat = originalString.toCGFloat()
        if originalFloat > 100 {
            return "100"
        }else {
            return originalString
        }
    }
    
}
extension Date {
    
    /// How many days in current month
    var sportDays: Int {
        get {
            return Calendar.current.range(of: .day, in: .month, for: self)!.count
        }
    }
}
