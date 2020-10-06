//
//  CurrentDataHelper.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/19.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

class CurrentDataHelper: DataHelperProtocol {

    static let TABLE_NAME = "t_current"

    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let isupload = Expression<String>("isupload")

    static let time = Expression<String>("time")
    static let device_state = Expression<String>("device_state")
    static let hr = Expression<String>("hr")
    static let hr_stateus = Expression<String>("hr_stateus")

    static let step = Expression<String>("step")
    static let distance = Expression<String>("distance")
    static let calorie = Expression<String>("calorie")
    static let sleep_hour = Expression<String>("sleep_hour")
    static let sleep_minutes = Expression<String>("sleep_minutes")

    static let light_sleep_time = Expression<String>("light_sleep_time")
    static let deep_sleep_time = Expression<String>("deep_sleep_time")
    static let wake_sleep_time = Expression<String>("wake_sleep_time")
    static let start_sleep_time = Expression<String>("start_sleep_time")
    static let end_sleep_time = Expression<String>("end_sleep_time")

    static let table = Table(TABLE_NAME)

    typealias T = CurrentDataModel

    static func createTable() throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try connection.run( table.create(ifNotExists: true) {t in

                t.column(userid)
                t.column(bt_mac)
                t.column(isupload)

                t.column(time)
                t.column(device_state)
                t.column(hr)
                t.column(hr_stateus)

                t.column(step)
                t.column(distance)
                t.column(calorie)
                t.column(sleep_hour)
                t.column(sleep_minutes)

                t.column(light_sleep_time)
                t.column(deep_sleep_time)
                t.column(wake_sleep_time)
                t.column(start_sleep_time)
                t.column(end_sleep_time)

                t.primaryKey(userid, bt_mac, time)


            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
}

extension CurrentDataHelper {

    static func insertOrUpdate(items: [T], complete:() -> Void) throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        // 1. wrap everything in a transaction
        try connection.transaction{
            for (index, item) in items.enumerated() {
                // scope the update statement (any row in the word column that equals "hello")
                let alice = table.filter(item.userid == userid).filter(item.bt_mac == bt_mac).filter(item.time == time)
                // 2. try to update
                if try connection.run(alice.update(item)) > 0 {
                    print("updated success")
                } else { // update returned 0 because there was no match
                    // 4. insert the word
                    let rowId =  try connection.run(table.insert(item))
                    if rowId > 0 {
                        print("insert success")
                    }else {
                        print("insert faile")
                    }
                }// 5. if successful, transaction is commited

                if index == items.count - 1 {
                    complete()
                }
            }
        }
    }

    static func update(item: T) throws -> Bool {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        let alice = table.filter(item.userid == userid).filter(item.bt_mac == bt_mac).filter(item.time == time)
        if try connection.run(alice.update(item)) > 0 {
            return true
        } else {
            return false
        }

    }
    static func findNotUpdateData() throws -> [T]? {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        let query =  table.filter((isupload) == "0")


        let items = try connection.prepare(query)
        var retArray = [T]()
        for item in items {
            retArray.append(T.init(userid: item[userid],
                                   bt_mac: item[bt_mac],
                                   isupload: item[isupload],

                                   time: item[time],
                                   device_state: item[device_state],
                                   hr: item[hr],
                                   hr_stateus: item[hr_stateus],

                                   step: item[step],
                                   distance: item[distance],
                                   calorie: item[calorie],
                                   sleep_hour: item[sleep_hour],
                                   sleep_minutes: item[sleep_minutes],

                                   light_sleep_time: item[light_sleep_time],
                                   deep_sleep_time: item[deep_sleep_time],
                                   wake_sleep_time: item[wake_sleep_time],
                                   start_sleep_time: item[start_sleep_time],
                                   end_sleep_time: item[end_sleep_time]))
        }
        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }
    static func findFirstRow(userID: String, macAddress: String, currentDate: String) throws -> T? {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        if let item = try connection.pluck(table.filter(userid == userID).filter(bt_mac == macAddress).filter(time == currentDate)) {

            return T.init(userid: item[userid],
                          bt_mac: item[bt_mac],
                          isupload: item[isupload],

                          time: item[time],
                          device_state: item[device_state],
                          hr: item[hr],
                          hr_stateus: item[hr_stateus],

                          step: item[step],
                          distance: item[distance],
                          calorie: item[calorie],
                          sleep_hour: item[sleep_hour],
                          sleep_minutes: item[sleep_minutes],

                          light_sleep_time: item[light_sleep_time],
                          deep_sleep_time: item[deep_sleep_time],
                          wake_sleep_time: item[wake_sleep_time],
                          start_sleep_time: item[start_sleep_time],
                          end_sleep_time: item[end_sleep_time])
        }
        return nil
    }

    static func findAllRow(userID: String, macAddress: String) throws -> [T]? {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let items = try connection.prepare(table.filter(userid == userID).filter(bt_mac == macAddress))
        var retArray = [T]()
        for item in  items {
            retArray.append(T.init(userid: item[userid],
                                   bt_mac: item[bt_mac],
                                   isupload: item[isupload],

                                   time: item[time],
                                   device_state: item[device_state],
                                   hr: item[hr],
                                   hr_stateus: item[hr_stateus],

                                   step: item[step],
                                   distance: item[distance],
                                   calorie: item[calorie],
                                   sleep_hour: item[sleep_hour],
                                   sleep_minutes: item[sleep_minutes],

                                   light_sleep_time: item[light_sleep_time],
                                   deep_sleep_time: item[deep_sleep_time],
                                   wake_sleep_time: item[wake_sleep_time],
                                   start_sleep_time: item[start_sleep_time],
                                   end_sleep_time: item[end_sleep_time]))
        }

        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }
    static func findAllRow(userID: String) throws -> [T]? {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let items = try connection.prepare(table.filter(userid == userID))
        var retArray = [T]()
        for item in  items {
            retArray.append(T.init(userid: item[userid],
                                   bt_mac: item[bt_mac],
                                   isupload: item[isupload],

                                   time: item[time],
                                   device_state: item[device_state],
                                   hr: item[hr],
                                   hr_stateus: item[hr_stateus],

                                   step: item[step],
                                   distance: item[distance],
                                   calorie: item[calorie],
                                   sleep_hour: item[sleep_hour],
                                   sleep_minutes: item[sleep_minutes],

                                   light_sleep_time: item[light_sleep_time],
                                   deep_sleep_time: item[deep_sleep_time],
                                   wake_sleep_time: item[wake_sleep_time],
                                   start_sleep_time: item[start_sleep_time],
                                   end_sleep_time: item[end_sleep_time]))
        }

        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }

    static func checkColumnExists(item: T) throws -> Bool {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let alice = table.filter(item.userid == userid).filter(item.bt_mac == bt_mac).filter(item.time == time).exists

        let isExists = try connection.scalar(alice)
        return  isExists
    }

}
