//
//  SleepDetailDataHelper.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/20.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

class SleepDetailDataHelper: DataHelperProtocol {

    static let TABLE_NAME = "t_sleep_detail"

    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let isupload = Expression<String>("isupload")

    static let sleep_time = Expression<String>("sleep_time")
    static let sleep_value = Expression<String>("sleep_value")
    static let calorie = Expression<String>("calorie")

    static let hr = Expression<String>("hr")
    static let hr_status = Expression<String>("hr_status")
    static let step = Expression<String>("step")
    static let distance = Expression<String>("distance")

    static let table = Table(TABLE_NAME)

    typealias T = SleepDetailDataModel

    static func createTable() throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try connection.run( table.create(ifNotExists: true) {t in

                t.column(userid)
                t.column(bt_mac)
                t.column(isupload)

                t.column(sleep_time)
                t.column(sleep_value)
                t.column(calorie)

                t.column(hr)
                t.column(hr_status)
                t.column(step)
                t.column(distance)

                t.primaryKey(userid, bt_mac, sleep_time)

            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }


}

extension SleepDetailDataHelper {

    static func insertOrUpdate(items: [T], complete: () -> Void) throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        try connection.transaction(.deferred, block: {
            for (index, item) in items.enumerated() {

                if try connection.run(table.filter(item.userid == userid).filter(item.bt_mac == bt_mac).filter(item.sleep_time == sleep_time).update(item)) > 0 {
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

    static func findAllRow(userID: String, macAddress: String, startSleepTimestamp: String, endSleepTimestamp: String) throws -> [T]? {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let items = try connection.prepare(table.filter(userid == userID).filter(bt_mac == macAddress).filter(sleep_time >= startSleepTimestamp).filter(sleep_time <= endSleepTimestamp))
        var retArray = [T]()
        for item in  items {
            retArray.append(T.init(userid: item[userid],
                                   bt_mac: item[bt_mac],
                                   isupload: item[isupload],
                                   sleep_time: item[sleep_time],
                                   sleep_value: item[sleep_value],
                                   calorie: item[calorie],
                                   hr: item[hr],
                                   hr_status: item[hr_status],
                                   step: item[step],
                                   distance: item[distance]))
        }


        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }

    static func findNotUpdateData(_ timestamp: String? = nil) throws -> [T]? {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        var part = table
        if timestamp != nil {
            let timestampDouble = Double(timestamp!) ?? 0
//            let startSleepTimestamp = timestampDouble - (4 * 60 * 60)
//            let endSleepTimestamp = timestampDouble + (8 * 60 * 60)

                        let startSleepTimestamp = timestampDouble
                        let endSleepTimestamp = timestampDouble + (24 * 60 * 60)

            part = table.filter(isupload == "0").filter(sleep_time < endSleepTimestamp.description).filter(sleep_time > startSleepTimestamp.description) .order(sleep_time.asc)
        }else {

           part = table.filter(isupload == "0").order(sleep_time.asc)
        }

        let items = try connection.prepare(part)
        var retArray = [T]()
        for item in items {
            retArray.append(T.init(userid: item[userid],
                                   bt_mac: item[bt_mac],
                                   isupload: item[isupload],
                                   sleep_time: item[sleep_time],
                                   sleep_value: item[sleep_value],
                                   calorie: item[calorie],
                                   hr: item[hr],
                                   hr_status: item[hr_status],
                                   step: item[step],
                                   distance: item[distance]))
        }
        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }

    static func findSleepCount(_ startTimestamp: String, _ endTimestamp: String) throws ->(Int, Int, Int) {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let alace = table.filter(startTimestamp < sleep_time).filter(endTimestamp > sleep_time)

        let lightSleepCount = try connection.scalar(alace.filter(sleep_value == "1").count)
        let deepSleepCount =  try connection.scalar(alace.filter(sleep_value == "2").count)
        let soberSleepCount =  try connection.scalar(alace.filter(sleep_value == "3").count)

        return (lightSleepCount, deepSleepCount, soberSleepCount)
    }

    static func findSleepChunk(_ dateString: String) throws -> [Dictionary<String, String>] {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let startTimeStamp =  Double(FDDateHandleTool.dateStringToTimeStamp(stringTime: dateString, timeForm: "yyyy/MM/dd")) ?? 0
        let endTimeStamp = Double(startTimeStamp + (60 * 60 * 24))

        let sqlStr = "select sleep_time,sleep_value from t_sleep_detail where (sleep_value = '1' or sleep_value = '2' or sleep_value = '3') and ( sleep_time between \(startTimeStamp) and \(endTimeStamp)) order by sleep_time"

         var sleepTimeArray = [Dictionary<String,String>]()

        let stmt = try! connection.prepare(sqlStr)

        for row in stmt {
            var resultDic = Dictionary<String, String>()

            for (index, name) in stmt.columnNames.enumerated() {
                resultDic[name] = row[index] as? String ?? ""
            }

            sleepTimeArray.append(resultDic)
        }

        return sleepTimeArray
    }

    
}
