//
//  WorkoutDetialDataHelper.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/18.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit
import SQLite

class WorkoutDetialDataHelper: DataHelperProtocol {

    static let TABLE_NAME = "t_workout_detail"

    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let isupload = Expression<String>("isupload")

    static let sportid = Expression<String>("sportid")
    static let workout_type = Expression<String>("workout_type")
    static let time = Expression<String>("time")
    static let hr = Expression<String>("hr")
    static let hr_status = Expression<String>("hr_status")

    static let step = Expression<String>("step")
    static let calorie = Expression<String>("calorie")
    static let distance = Expression<String>("distance")
    static let workout_duration = Expression<String>("workout_duration")

    static let table = Table(TABLE_NAME)

    typealias T = WorkoutDetailModel

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
                t.column(workout_type)
                t.column(sportid)
                t.column(hr)
                t.column(hr_status)

                t.column(step)
                t.column(calorie)
                t.column(distance)
                t.column(workout_duration)

                t.primaryKey(userid, bt_mac, time)
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }


}
extension WorkoutDetialDataHelper {

    static func insertOrUpdate(items: [T], complete: () -> Void) throws -> Void {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        try connection.transaction(block: {
            for (index, item) in items.enumerated() {

                if try connection.run(table.filter(item.userid == userid).filter(item.bt_mac == bt_mac).filter(item.time == time).update(item)) > 0 {
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
                                   sportid: item[sportid],
                                   workout_type: item[workout_type],
                                   time: item[time],
                                   hr: item[hr],
                                   hr_status: item[hr_status],
                                   step: item[step],
                                   calorie: item[calorie],
                                   distance: item[distance],
                                   workout_duration: item[workout_duration]))
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
                                   sportid: item[sportid],
                                   workout_type: item[workout_type],
                                   time: item[time], hr: item[hr],
                                   hr_status: item[hr_status],
                                   step: item[step],
                                   calorie: item[calorie],
                                   distance: item[distance],
                                   workout_duration: item[workout_duration]))
        }
        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }
}
