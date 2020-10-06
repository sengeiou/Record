//
//  WorkoutSummaryDataHelper.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/18.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit
import SQLite

class WorkoutSummaryDataHelper: DataHelperProtocol {

    static let TABLE_NAME = "t_workout_summary"

    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let isupload = Expression<String>("isupload")

    static let workout_id = Expression<String>("workout_id")
    static let workout_type = Expression<String>("workout_type")
    static let start_time = Expression<String>("start_time")
    static let end_time = Expression<String>("end_time")

    static let hr = Expression<String>("hr")
    static let hr_state = Expression<String>("hr_state")
    static let steps = Expression<String>("steps")
    static let distances = Expression<String>("distances")
    static let calories = Expression<String>("calories")

    static let workout_duration = Expression<String>("workout_duration")
    static let target = Expression<String>("target")
    static let target_value = Expression<String>("target_value")
    static let date = Expression<String>("date")

    static let table = Table(TABLE_NAME)

    typealias T = WorkoutSummaryModel

    //协议方法
    static func createTable() throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try connection.run( table.create(ifNotExists: true) {t in
                t.column(userid)
                t.column(bt_mac)
                t.column(isupload)

                t.column(date)
                t.column(workout_type)
                t.column(start_time)
                t.column(end_time)

                t.column(hr)
                t.column(hr_state)
                t.column(steps)
                t.column(distances)
                t.column(calories)

                t.column(workout_duration)
                t.column(target)
                t.column(target_value)
                t.column(workout_id)

                t.primaryKey(userid, bt_mac, start_time)
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
}

//自定义方法
extension WorkoutSummaryDataHelper {

    /*
     INSERT INTO t_workout_summary (userid,bt_mac,isupload,
     workout_id,workout_type,start_time,
     end_time,hr,hr_state,
     steps,distances,calories,
     workout_duration,target,target_value,
     date)
     VALUES ("518248981c", 'FA:35:79:99:3C:08', "0", '66', "2",
     "1490385600","1", '77', "2", '765',
     "343","34567","18765456", '5', "27",
     '2018-3-25')
     */
    static func insertOrUpdate(items: [T], complete:() -> Void) throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        try connection.transaction(.deferred, block: {
            for (index, item) in items.enumerated() {
                if try connection.run(table.filter(item.userid == userid).filter(item.bt_mac == bt_mac).filter(item.date == date).update(item)) > 0 {
                    print("updated")
                } else {
                    let _ =  try connection.run(table.insert(item))
                    print("insert")
                }

                if index == items.count - 1 {
                    complete()
                }
            }
        })

    }


    static func update(item: T) throws -> Bool {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        let alice = table.filter(item.userid == userid).filter(item.bt_mac == bt_mac).filter(item.date == date)
        if try connection.run(alice.update(item)) > 0 {
            return true
        } else {
            return false
        }

    }

    static func find(userID: String) throws -> [T] {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let items = try connection.prepare(table.filter(userid == userID))
        var retArray = [T]()
        for item in  items {
            retArray.append(T.init(userid: item[userid],
                                   bt_mac: item[bt_mac],
                                   isupload: item[isupload],
                                   workout_id: item[workout_id],
                                   workout_type: item[workout_type],
                                   start_time: item[start_time],
                                   end_time: item[end_time],
                                   hr: item[hr],
                                   hr_state: item[hr_state],
                                   steps: item[steps],
                                   distances: item[distances],
                                   calories: item[calories],
                                   workout_duration: item[workout_duration],
                                   target: item[target],
                                   target_value: item[target_value],
                                   date: item[date]))
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
            retArray.append(T.init(userid: item[userid],
                                   bt_mac: item[bt_mac],
                                   isupload: item[isupload],
                                   workout_id: item[workout_id],
                                   workout_type: item[workout_type],
                                   start_time: item[start_time],
                                   end_time: item[end_time],
                                   hr: item[hr],
                                   hr_state: item[hr_state],
                                   steps: item[steps],
                                   distances: item[distances],
                                   calories: item[calories],
                                   workout_duration: item[workout_duration],
                                   target: item[target],
                                   target_value: item[target_value],
                                   date: item[date]))
        }
        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }

    static func FindLatestWorkoutTarget(userID: String, macAddress: String) throws -> T {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }


        let itemOptional = try connection.pluck(table.filter(userID == userid).filter(macAddress == bt_mac).order(date.desc))
        
        guard let item = itemOptional else {
            var defaultModel = WorkoutSummaryModel()
            //0 距离 1 时长
            defaultModel.target = "0"
            defaultModel.target_value = "5"

            defaultModel.userid = userID
            defaultModel.bt_mac = macAddress

            try! insertOrUpdate(items: [defaultModel], complete: {})

            return defaultModel
        }

        return T.init(userid: item[userid],
                      bt_mac: item[bt_mac],
                      isupload: item[isupload],
                      workout_id: item[workout_id],
                      workout_type: item[workout_type],
                      start_time: item[start_time],
                      end_time: item[end_time],
                      hr: item[hr],
                      hr_state: item[hr_state],
                      steps: item[steps],
                      distances: item[distances],
                      calories: item[calories],
                      workout_duration: item[workout_duration],
                      target: item[target],
                      target_value: item[target_value],
                      date: item[date])





    }

    static func find(_ userId: String, _ macAddress: String) throws -> [WorkoutHistoryModel] {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let queryMonthDataSQLiteStr = "select sum(distances) as distanceTotal, strftime('%Y/%m',start_time,'unixepoch','localtime')as 'yearMonth' from t_workout_summary group by yearMonth order by start_time desc"

        var array = [[String: String]]()

        let stm = try connection.prepare(queryMonthDataSQLiteStr)

        for row in stm {
            var resultDic = [String: String]()
            for (index, name) in stm.columnNames.enumerated() {

                if let value = row[index] as? String {
                    resultDic[name] = value
                }else if let value = row[index] as? Double {
                    resultDic[name] = value.description
                }else if let value = row[index] as? Int64 {
                    resultDic[name] = value.description
                }
            }
            array.append(resultDic)
        }



        var dataSource = [WorkoutHistoryModel]()
        for resultDict in array {


            let yearMonth = resultDict["yearMonth"] ?? ""

            if !yearMonth.isEmpty {

                let distanceTotal = resultDict["distanceTotal"]
                var historyModel2 = WorkoutHistoryModel()

                var sumModel2 = WorkoutHistorySummaryModel()
                sumModel2.monthDate = yearMonth
                sumModel2.summaryDistance = distanceTotal ?? ""

                var detailModels = [WorkoutHistoryDetailModel]()

                let queryDayDataSQLiteStr = "select * from t_workout_summary where strftime('%Y/%m', start_time,'unixepoch','localtime') = '\(yearMonth)' order by start_time desc"

                let stm = try connection.prepare(queryDayDataSQLiteStr)

                for row in stm {

                    var detailModel5 = WorkoutHistoryDetailModel()
                    for (index, name) in stm.columnNames.enumerated() {
                        if name == "workout_type" {
                            detailModel5.type = row[index] as! String
                        }else if name == "distances" {

                            detailModel5.distance = row[index] as! String
                        }else if name == "workout_duration" {

                            detailModel5.schedule = row[index] as! String
                        }else if name == "steps" {
                            detailModel5.step = row[index] as! String

                        }else if name == "calories" {
                            detailModel5.calorie = row[index] as! String

                        }else if name == "date" {

                            detailModel5.dayDate = row[index] as! String
                        }

                    }
                    detailModels.append(detailModel5)
                }

            historyModel2.summaryModel = sumModel2
            historyModel2.detailModels = detailModels

            dataSource.append(historyModel2)
            }
        }

        return dataSource

    }

}
