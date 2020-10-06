//
//  FDSleepDetailHelp.swift
//  FD070+
//
//  Created by WANG DONG on 2019/2/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit


/// 统计详情的类型
///
/// - day: 天是以分钟为单位
/// - month: 月是以天为单位
/// - year: 年是以月为单位
enum FDSleepDetailSummaryType {
    case day
    case month
    case year
}


/// 数据切换的方向
///
/// - ahead: 前一天数据
/// - current: 当前天的数据
/// - next: 后一天的数据
enum FDSleepLoadDataDirectionType: Int {
    
    case ahead = 0
    case current
    case next
}

/// 睡眠类型
///
/// - deep: 深睡
/// - light: 浅睡
/// - sober: 清醒
enum FDSleepType {
    case deep
    case light
    case sober
}



class FDSleepDetailHelp: NSObject {

    static func findSleepDetailData(_ dateString: String) -> FDSleepDetailOriginalModel  {

        var model = FDSleepDetailOriginalModel()

        model.date = dateString

        let dateTimStamp = Double(FDDateHandleTool.dateStringToTimeStamp(stringTime: dateString, timeForm: "yyyy/MM/dd")) ?? 0

        let startTimeStamp = dateTimStamp - (4 * 60 * 60)
        let endTimeStamp = Double(startTimeStamp + (60 * 60 * 24))

        let sqlStr = "select sleep_time,sleep_value from t_sleep_detail where (sleep_value = '1' or sleep_value = '2' or sleep_value = '3') and ( sleep_time between \(startTimeStamp) and \(endTimeStamp)) order by sleep_time"


        guard let DB = SQLiteDataStore.sharedInstance!.connection else {
            return model
        }

        let stmt = try! DB.prepare(sqlStr)

        var sleepTimestampMin = endTimeStamp
        var sleepTimestampMax = startTimeStamp

        var sleepResultArray = [sleepOriginalModel]()
        for row in stmt {
            var sleepDetailModel = sleepOriginalModel()

            for (index, name) in stmt.columnNames.enumerated() {
                let vaule = row[index] ?? ""
                if name == "sleep_time" {
                    let sleepTimestamp = Double(vaule as! String) ?? 0
                    sleepDetailModel.sleepDate = sleepTimestamp
                    if sleepTimestamp < sleepTimestampMin {
                        sleepTimestampMin = sleepTimestamp
                    }
                    if sleepTimestamp > sleepTimestampMax {
                        sleepTimestampMax = sleepTimestamp
                    }

                }else if name == "sleep_value" {
                    sleepDetailModel.sleepType = getSleepState(vaule as! String)
                }


            }
            sleepResultArray.append(sleepDetailModel)
        }
        model.sleepDetailArray = sleepResultArray

        let sleepCount = try! SleepDetailDataHelper.findSleepCount(startTimeStamp.description, endTimeStamp.description)
        model.sleepLightCount = sleepCount.0
        model.sleepDeepCount = sleepCount.1
        model.sleepSoberCount = sleepCount.2
        model.sleepTotalCount = sleepCount.0 + sleepCount.1 + sleepCount.2
        //睡眠横坐标是固定的。
//        model.sleepStart = sleepTimestampMin
//        model.sleepEnd = sleepTimestampMax

        model.sleepStart = startTimeStamp
        model.sleepEnd = endTimeStamp

        return model
    }

    static func getSleepState(_ originalValue: String) -> FDSleepType {
        if originalValue == "1" {
            return .light
        }else if originalValue == "2" {
            return .deep
        }else {
            return .sober
        }
    }


    static func getSleepMonthDataFromDB(_ monthStr: String) ->FDSleepMonthSummaryModel  {

        var sleepMonthSummary = FDSleepMonthSummaryModel()

        guard let connect = SQLiteDataStore.sharedInstance!.connection else {
            return sleepMonthSummary
        }

        var lightTotal = 0
        var deepTotal = 0
        var soberTotal = 0


        let queryStr = "select * ,strftime('%d', sleep_time,'unixepoch','localtime') as 'dayStr' from t_sleep_detail where  (sleep_value = '1' or sleep_value = '2' or sleep_value = '3') and strftime('%Y/%m', sleep_time,'unixepoch','localtime') = '\(monthStr)' group by strftime('%Y/%m/%d', sleep_time,'unixepoch','localtime')"
        
        let stm = try! connect.prepare(queryStr)

        for row in stm {
            var sleepDayModel = FDSleepDayDetailModel()


            for (index, name) in stm.columnNames.enumerated() {

                if name == "dayStr" {
                    let value = row[index] as! String
                    sleepDayModel.date = value

                    let dateStr = monthStr + "/" + value

                    let stmDayLight = try! connect.prepare("select count (*) as lightCount from t_sleep_detail where  (sleep_value = '1') and strftime('%Y/%m/%d', sleep_time,'unixepoch','localtime') = '\(dateStr)' group by strftime('%Y/%m/%d', sleep_time,'unixepoch','localtime')")

                    for row in stmDayLight {
                        for (index, soberCountName) in stmDayLight.columnNames.enumerated() {
                            if soberCountName == "lightCount" {
                                let value = Int(row[index] as! Int64)
                                sleepDayModel.sleepLightTotal = value
                                lightTotal += value
                            }
                        }
                    }


                    let stmDayDeep = try! connect.prepare("select count (*) as deepCount  from t_sleep_detail where  (sleep_value = '2') and strftime('%Y/%m/%d', sleep_time,'unixepoch','localtime') = '\(dateStr)' group by strftime('%Y/%m/%d', sleep_time,'unixepoch','localtime')")

                    for row in stmDayDeep {
                        for (index, soberCountName) in stmDayDeep.columnNames.enumerated() {
                            if soberCountName == "deepCount" {
                                let value = Int(row[index] as! Int64)
                                sleepDayModel.sleepDeepTotal = value
                                deepTotal += value
                            }
                        }
                    }


                    let stmDaySober = try! connect.prepare("select count (*) as soberCount from t_sleep_detail where  (sleep_value = '3') and strftime('%Y/%m/%d', sleep_time,'unixepoch','localtime') = \(dateStr) group by strftime('%Y/%m/%d', sleep_time,'unixepoch','localtime')")

                    for row in stmDaySober {
                        for (index, soberCountName) in stmDaySober.columnNames.enumerated() {
                            if soberCountName == "soberCount" {
                                let value = Int(row[index] as! Int64)
                                sleepDayModel.sleepsoberTotal = value
                                soberTotal += value
                            }
                        }
                    }


                    let sleepTotal = sleepDayModel.sleepsoberTotal + sleepDayModel.sleepLightTotal + sleepDayModel.sleepDeepTotal

                    var layerModel = FDSleepDiffColorLayer()
                    layerModel.deepColor = UIColor.red
                    layerModel.lightColor = UIColor.yellow
                    layerModel.soberColor = UIColor.brown



                    layerModel.deepProportion = filterNaNValue(Double(sleepDayModel.sleepDeepTotal)/Double(sleepTotal))
                    layerModel.lightProportion = filterNaNValue(Double(sleepDayModel.sleepLightTotal)/Double(sleepTotal))
                    layerModel.soberProportion = filterNaNValue(Double(sleepDayModel.sleepsoberTotal)/Double(sleepTotal))

                    sleepDayModel.sleepViewData = layerModel
                    sleepMonthSummary.sleepValues.append(sleepDayModel)

                }
            }

        }


        sleepMonthSummary.month = monthStr
        sleepMonthSummary.sleepDeepTotal = deepTotal
        sleepMonthSummary.sleepLightTotal = lightTotal
        sleepMonthSummary.sleepsoberTotal = soberTotal


        return sleepMonthSummary
    }

    static func getSleepYeaDataFromDB(_ yearStr: String) ->FDSleepMonthSummaryModel  {



        var sleepMonthSummary = FDSleepMonthSummaryModel()

        guard let connect = SQLiteDataStore.sharedInstance!.connection else {
            return sleepMonthSummary
        }

        var lightTotal = 0
        var deepTotal = 0
        var soberTotal = 0


        let queryStr = "select * ,strftime('%m', sleep_time,'unixepoch','localtime') as 'monthStr' from t_sleep_detail where  (sleep_value = '1' or sleep_value = '2' or sleep_value = '3') and strftime('%Y', sleep_time,'unixepoch','localtime') = '\(yearStr)' group by strftime('%Y/%m', sleep_time,'unixepoch','localtime')"

        let stm = try! connect.prepare(queryStr)

        for row in stm {
            var sleepDayModel = FDSleepDayDetailModel()


            for (index, name) in stm.columnNames.enumerated() {

                if name == "monthStr" {
                    let value = row[index] as! String
                    sleepDayModel.date = value

                    let dateStr = yearStr + "/" + value

                    let stmDayLight = try! connect.prepare("select count (*) as lightCount from t_sleep_detail where  (sleep_value = '1') and strftime('%Y/%m', sleep_time,'unixepoch','localtime') = '\(dateStr)' group by strftime('%Y/%m', sleep_time,'unixepoch','localtime')")

                    for row in stmDayLight {
                        for (index, soberCountName) in stmDayLight.columnNames.enumerated() {
                            if soberCountName == "lightCount" {
                                let value = Int(row[index] as! Int64)
                                sleepDayModel.sleepLightTotal = value
                                lightTotal += value
                            }
                        }
                    }


                    let stmDayDeep = try! connect.prepare("select count (*) as deepCount  from t_sleep_detail where  (sleep_value = '2') and strftime('%Y/%m', sleep_time,'unixepoch','localtime') = '\(dateStr)' group by strftime('%Y/%m', sleep_time,'unixepoch','localtime')")

                    for row in stmDayDeep {
                        for (index, soberCountName) in stmDayDeep.columnNames.enumerated() {
                            if soberCountName == "deepCount" {
                                let value = Int(row[index] as! Int64)
                                sleepDayModel.sleepDeepTotal = value
                                deepTotal += value
                            }
                        }
                    }


                    let stmDaySober = try! connect.prepare("select count (*) as soberCount from t_sleep_detail where  (sleep_value = '3') and strftime('%Y/%m', sleep_time,'unixepoch','localtime') = \(dateStr) group by strftime('%Y/%m', sleep_time,'unixepoch','localtime')")

                    for row in stmDaySober {
                        for (index, soberCountName) in stmDaySober.columnNames.enumerated() {
                            if soberCountName == "soberCount" {
                                let value = Int(row[index] as! Int64)
                                sleepDayModel.sleepsoberTotal = value
                                soberTotal += value
                            }
                        }
                    }


                    let sleepTotal = sleepDayModel.sleepsoberTotal + sleepDayModel.sleepLightTotal + sleepDayModel.sleepDeepTotal


                    var layerModel = FDSleepDiffColorLayer()
                    layerModel.deepColor = UIColor.red
                    layerModel.lightColor = UIColor.yellow
                    layerModel.soberColor = UIColor.brown



                    layerModel.deepProportion = filterNaNValue(Double(sleepDayModel.sleepDeepTotal)/Double(sleepTotal))
                    layerModel.lightProportion = filterNaNValue(Double(sleepDayModel.sleepLightTotal)/Double(sleepTotal))
                    layerModel.soberProportion = filterNaNValue(Double(sleepDayModel.sleepsoberTotal)/Double(sleepTotal))

                    sleepDayModel.sleepViewData = layerModel
                    sleepMonthSummary.sleepValues.append(sleepDayModel)

                }
            }

        }


        sleepMonthSummary.month = yearStr
        sleepMonthSummary.sleepDeepTotal = deepTotal
        sleepMonthSummary.sleepLightTotal = lightTotal
        sleepMonthSummary.sleepsoberTotal = soberTotal


        return sleepMonthSummary
    }

    static func filterNaNValue(_ value: Double) -> Double {

        if value.isNaN {
            return 0
        }

        return value
    }

}
