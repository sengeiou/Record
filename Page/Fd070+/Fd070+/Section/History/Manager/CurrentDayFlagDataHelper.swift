//
//  CurrentDayFlagDataHelper.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/18.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

class CurrentDayFlagDataHelper: DataHelperProtocol {

    static let TABLE_NAME = "t_hitory_data_flag"

    static let userId = Expression<String>("userId")
    static let btMac = Expression<String>("btMac")
    static let dataFlag = Expression<String>("dataFlag")
    static let timeStamp = Expression<String>("timeStamp")

    static let table = Table(TABLE_NAME)

    typealias T = HistroyDataFlagModel

    static func createTable() throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try connection.run( table.create(ifNotExists: true) {t in

                t.column(timeStamp)
                t.column(userId)
                t.column(btMac)
                t.column(dataFlag)

                t.primaryKey(timeStamp, userId)
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
}

extension CurrentDayFlagDataHelper {

    static func insertOrUpdate(items: [T], complete: () -> Void) throws  {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        try connection.transaction(.deferred, block: {
            for (index, item) in items.enumerated() {

                if try connection.run(table.filter(item.timeStamp == timeStamp).filter(item.userId == userId).update(item)) > 0 {
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

    static func checkColumnExists(item: T) throws -> Bool {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let alice = table.filter(item.userId == userId).filter(item.timeStamp == timeStamp).exists

        let isExists = try connection.scalar(alice)
        return  isExists
    }
}

