//
//  SportSummaryDataHelper.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/20.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

class SportSummaryDataHelper: DataHelperProtocol {

    static let TABLE_NAME = "t_sport_summary"

    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let isupload = Expression<String>("isupload")

    static let sportid = Expression<String>("sportid")
    static let steps = Expression<String>("steps")
    static let calories = Expression<String>("calories")
    static let kilometres = Expression<String>("kilometres")

    static let reached = Expression<String>("reached")
    static let rate = Expression<String>("rate")
    static let date = Expression<String>("date")
    static let goal = Expression<String>("goal")

    static let sport_duration = Expression<String>("sport_duration")

    static let table = Table(TABLE_NAME)

    typealias T = SportSummaryDataModel

    static func createTable() throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try connection.run( table.create(ifNotExists: true) {t in

                t.column(userid)
                t.column(bt_mac)
                t.column(isupload)

                t.column(sportid)
                t.column(steps)
                t.column(calories)
                t.column(kilometres)

                t.column(reached)
                t.column(rate)
                t.column(date)
                t.column(goal)

                t.column(sport_duration)
                
                t.primaryKey(userid, bt_mac, date)

            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
}

extension SportSummaryDataHelper {

    static func insertOrUpdate(items: [T], complete: () -> Void) throws {
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
                                   sportid: item[sportid],
                                   steps: item[steps],
                                   calories: item[calories],
                                   kilometres: item[kilometres],
                                   reached: item[reached],
                                   rate: item[rate],
                                   date: item[date],
                                   goal: item[goal],
                                   sport_duration: item[sport_duration]))
        }
        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
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
                                   sportid: item[sportid],
                                   steps: item[steps],
                                   calories: item[calories],
                                   kilometres: item[kilometres],
                                   reached: item[reached],
                                   rate: item[rate],
                                   date: item[date],
                                   goal: item[goal],
                                   sport_duration: item[sport_duration]))
        }

        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }
}
