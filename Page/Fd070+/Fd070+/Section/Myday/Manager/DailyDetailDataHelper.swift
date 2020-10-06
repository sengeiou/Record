//
//  SportUnitMinutesHelp.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/25.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import SQLite

class DailyDetailDataHelper: DataHelperProtocol {
    
    static let TABLE_NAME = "t_daily_detail"
    
    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let isupload = Expression<String>("isupload")

    static let typeData = Expression<String>("typeData")
    static let index = Expression<String>("index")
    static let timeStamp = Expression<String>("timeStamp")
    static let hr = Expression<String>("hr")

    static let hrStatus = Expression<String>("hrStatus")
    static let step = Expression<String>("step")
    static let distance = Expression<String>("distance")
    static let calorie = Expression<String>("calorie")

    static let sleepValue = Expression<String>("sleepValue")

    static let table = Table(TABLE_NAME)
    
    typealias T = DailyDetailModel
    
    static func createTable() throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try connection.run( table.create(ifNotExists: true) {t in
                t.column(userid)
                t.column(bt_mac)
                t.column(isupload)

                t.column(typeData)
                t.column(index)
                t.column(timeStamp)
                t.column(hr)

                t.column(hrStatus)
                t.column(step)
                t.column(distance)
                t.column(calorie)

                t.column(sleepValue)

                t.primaryKey(userid, bt_mac, timeStamp)
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
    
}

// MARK: - 自定义方法
extension DailyDetailDataHelper {

    /**
     insert into t_daily_detail (userid,bt_mac,isupload,
     typeData,'index',timeStamp,hr,
     hrStatus,step,distance,calorie,
     sleepValue)
     values ("518248981c", "FA", "0",
     '6', "2","149d0385600","66",
     '9', "233","7654","3452",
     "1234")
     */
    static func insertOrUpdate(items: [T], complete: () -> Void) throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        try connection.transaction(.deferred, block: {
            for (indexInt, item) in items.enumerated() {
                if try connection.run(table.filter(item.userid == userid).filter(item.bt_mac == bt_mac).filter(item.timeStamp == timeStamp).update(item)) > 0 {
                    print("updated")
                } else {
                    let _ =  try connection.run(table.insert(item))
                    print("insert")
                }
                if indexInt == items.count - 1 {
                    complete()
                }
            }
        })

    }
    static func find(queryStr: String) throws -> [T] {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let items = try connection.prepare(table.filter(userid == queryStr))
        var retArray = [T]()
        for item in  items {

            retArray.append(DailyDetailModel.init(userid: item[userid],
                                                  bt_mac: item[bt_mac],
                                                  isupload: item[isupload],
                                                  typeData: item[typeData],
                                                  index: item[index],
                                                  timeStamp: item[timeStamp],
                                                  hr: item[hr],
                                                  hrStatus: item[hrStatus],
                                                  step: item[step],
                                                  distance: item[distance],
                                                  calorie: item[calorie],
                                                  sleepValue: item[sleepValue]))
        }

        return retArray

    }



    static func findNotUpdateData() throws -> [T]? {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let items = try connection.prepare(table.filter(isupload == "0"))
        var retArray = [T]()
        for item in items {
            retArray.append(DailyDetailModel.init(userid: item[userid],
                                                  bt_mac: item[bt_mac],
                                                  isupload: item[isupload],
                                                  typeData: item[typeData],
                                                  index: item[index],
                                                  timeStamp: item[timeStamp],
                                                  hr: item[hr],
                                                  hrStatus: item[hrStatus],
                                                  step: item[step],
                                                  distance: item[distance],
                                                  calorie: item[calorie],
                                                  sleepValue: item[sleepValue]))
        }
        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }
}

// MARK: - 数据库原始语句操作
extension DailyDetailDataHelper {

    static func getDataGroupByDay(monthStr: String) throws -> [[String: String]] {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let sqlSt = "select sum(step) as step ,sum(distance) as distance , sum(calorie) as calorie ,count(*) as count,strftime('%d', timeStamp,'unixepoch','localtime') as 'dayStr' from t_daily_detail where strftime('%Y/%m', timeStamp,'unixepoch','localtime') = '\(monthStr)' group by strftime('%Y/%m/%d', timeStamp,'unixepoch','localtime')"

        let stm = try connection.prepare(sqlSt)
        var resultArray = [[String: String]]()
        for row in stm {
            var resultDic = [String: String]()
            for (index, name) in stm.columnNames.enumerated() {
                if let value = row[index] as? String {
                    resultDic[name] = value
                }else {
                    resultDic[name] = String(row[index] as! Int64)
                }
            }
            resultArray.append(resultDic)
        }
        return resultArray

    }

    static func getDataGroupByMonth(yearStr: String) throws -> [[String: String]] {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let sqlSt = "select sum(step) as step ,sum(distance) as distance , sum(calorie) as calorie ,count(*) as count,strftime('%m', timeStamp,'unixepoch','localtime') as 'monthStr' from t_daily_detail where strftime('%Y', timeStamp,'unixepoch','localtime') = '\(yearStr)' group by strftime('%Y/%m', timeStamp,'unixepoch','localtime')"

        let stm = try connection.prepare(sqlSt)
        var resultArray = [[String: String]]()
        for row in stm {
            var resultDic = [String: String]()
            for (index, name) in stm.columnNames.enumerated() {
                if let value = row[index] as? String {
                    resultDic[name] = value
                }else if let value = row[index] as? Double {
                    resultDic[name] = String(value)
                }else if let value = row[index] as? Int64 {
                    resultDic[name] = String(value)
                }else if let value = row[index] as? Int {
                    resultDic[name] = String(value)
                }
            }
            resultArray.append(resultDic)
        }

        return resultArray

    }

    static func getDataGroupByDay(dayStr: String) throws -> [[String: String]] {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }


        let startStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(dayStr) 00:00:00", timeForm: "yyyy/MM/dd HH:mm:ss")
        let endDateStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(dayStr) 23:59:59", timeForm: "yyyy/MM/dd HH:mm:ss")


        let sqlSt = "select sum(step) as step ,sum(distance) as distance, sum(calorie)as calorie  ,count(*) as count,strftime('%H',timeStamp,'unixepoch','localtime')as hour from t_daily_detail where timeStamp between \(startStr) and \(endDateStr) group by hour"

        let stm = try connection.prepare(sqlSt)

         var resultArray = [[String: String]]()
        for row in stm {
            var resultDic:Dictionary = [String: String]()
            for (index, name) in stm.columnNames.enumerated() {

                if let value = row[index] as? String {
                    resultDic[name] = value
                }else {
                    resultDic[name] = String(row[index] as! Int64)
                }
            }

            resultArray.append(resultDic)
        }

        return resultArray
    }


    static func getWorkoutBy2Hour(date:String, macAddress: String) throws -> [workout2HourModel] {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }


        let startStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(date) 00:00:00", timeForm: "yyyy/MM/dd HH:mm:ss")
        let endDateStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(date) 23:59:59", timeForm: "yyyy/MM/dd HH:mm:ss")

        //
        let sqlSt = "select sum(step) ,sum(distance), sum(calorie),count(*),strftime('%H',timeStamp,'unixepoch','localtime')as hour from t_daily_detail where bt_mac='\(macAddress)' and timeStamp between \(startStr) and \(endDateStr) group by hour"

        //        print(sqlSt)
        let stm = try connection.prepare(sqlSt)
        var dataArray = [workout2HourModel]()

        for row in stm {
            var resultDic:Dictionary = Dictionary<String, Any>()
            for (index, name) in stm.columnNames.enumerated() {

                resultDic[name] = row[index] ?? ""
            }

            var workout2HModel = workout2HourModel()

            workout2HModel.sum2HStep =  resultDic["sum(step)"] as! Int64
            workout2HModel.sum2HDistance = resultDic["sum(distance)"] as! Int64
            workout2HModel.sum2HCalorie = resultDic["sum(calorie)"] as! Int64
            workout2HModel.sum2HCount = resultDic["count(*)"] as! Int64
            workout2HModel.hour = resultDic["hour"] as! String
            dataArray.append(workout2HModel)
        }

        return self.handleHourTo2hour(workoutHour:dataArray)
    }

    static func handleHourTo2hour(workoutHour:[workout2HourModel]) -> [workout2HourModel] {

        var resultDataArray = [workout2HourModel]()
        for index in 0 ..< 12 {
            let indexOne = index*2
            let indexTwo = index*2+1

            let tempArray = workoutHour.filter({ (item) -> Bool in

                return (Int(item.hour) == indexOne) || (Int(item.hour) == indexTwo)
            })

            if (tempArray.count) > 0 {
                var workout2HModel = workout2HourModel()
                for item in tempArray {

                    workout2HModel.sum2HStep = item.sum2HStep + workout2HModel.sum2HStep
                    workout2HModel.sum2HDistance = item.sum2HDistance + workout2HModel.sum2HDistance
                    workout2HModel.sum2HCalorie = item.sum2HCalorie + workout2HModel.sum2HCalorie
                    workout2HModel.sum2HCount = item.sum2HCount + workout2HModel.sum2HCount
                    workout2HModel.hour = String(index)
                }

                if workout2HModel.sum2HStep != 0 {
                    resultDataArray.append(workout2HModel)
                }
            }
        }

        return resultDataArray
    }

    /// 单独查找心率数据。
    ///
    /// - Parameter queryStr: 要查询的日期(2018/01/03)
    /// - Returns: 查询到心率数据
    /// - Throws: 错误抛出
    static func findHRData(date: String, macAddress: String) throws -> [T] {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let startStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(date) 00:00:00", timeForm: "yyyy/MM/dd HH:mm:ss")
        let endDateStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(date) 23:59:59", timeForm: "yyyy/MM/dd HH:mm:ss")

        let query = table.filter((timeStamp > startStr) && (timeStamp < endDateStr)).filter(bt_mac == macAddress)

        let items = try connection.prepare(query)

        var retArray = [T]()
        for item in  items {
            retArray.append(DailyDetailModel.init(userid: item[userid],
                                                  bt_mac: item[bt_mac],
                                                  isupload: item[isupload],
                                                  typeData: item[typeData],
                                                  index: item[index],
                                                  timeStamp: item[timeStamp],
                                                  hr: item[hr],
                                                  hrStatus: item[hrStatus],
                                                  step: item[step],
                                                  distance: item[distance],
                                                  calorie: item[calorie],
                                                  sleepValue: item[sleepValue]))
        }

        return retArray
    }

}
