//
//  HeartRateTestHelper.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/24.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

class HeartRateTestHelper: DataHelperProtocol {

    static let TABLE_NAME = "t_heartRate_test"

    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let isupload = Expression<String>("isupload")

    static let time = Expression<String>("time")
    static let rate = Expression<String>("rate")
    static let level = Expression<String>("level")
    static let detail = Expression<String>("detail")

    static let table = Table(TABLE_NAME)

    typealias T = HRDetailModel

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
                t.column(rate)
                t.column(level)
                t.column(detail)

                t.primaryKey(userid, bt_mac, time)

            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }

}
extension HeartRateTestHelper {

    static func insertOrUpdate(items: [T], complete: () -> Void) throws {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        try connection.transaction(.deferred, block: {
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

    static func find(queryStr: String) throws -> [T] {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let items = try connection.prepare(table)
        var retArray = [T]()
        for item in  items {
            retArray.append(T.init(userid: item[userid],
                                   bt_mac: item[bt_mac],
                                   isupload: item[isupload],
                                   time: item[time],
                                   rate: item[rate],
                                   level: item[level],
                                   detail: item[detail]))
        }

        return retArray

    }

    static func findAll() throws -> [T]? {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        var retArray = [T]()
        let items = try connection.prepare(table)
        for item in items {
            retArray.append(T.init(userid: item[userid],
                                   bt_mac: item[bt_mac],
                                   isupload: item[isupload],
                                   time: item[time],
                                   rate: item[rate],
                                   level: item[level],
                                   detail: item[detail]))
        }

        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
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
                                   time: item[time],
                                   rate: item[rate],
                                   level: item[level],
                                   detail: item[detail]))
        }
        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }
}
