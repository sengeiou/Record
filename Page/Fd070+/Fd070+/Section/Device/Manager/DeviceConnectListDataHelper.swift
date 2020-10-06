//
//  DeviceConnectListDataHelper.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/25.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

class DeviceConnectListDataHelper: DataHelperProtocol {

    static let TABLE_NAME = "t_device_connect_list"

    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let isupload = Expression<String>("isupload")

    static let device_name = Expression<String>("device_name")
    static let device_type = Expression<String>("device_type")
    static let davice_id = Expression<String>("davice_id")
    static let serial_number = Expression<String>("serial_number")
    static let flag = Expression<String>("flag")

    static let table = Table(TABLE_NAME)

    typealias T = DeviceConnectListMode

    static func createTable() throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try connection.run( table.create(ifNotExists: true) {t in

                t.column(userid)
                t.column(bt_mac)
                t.column(isupload)

                t.column(device_name)
                t.column(device_type)
                t.column(davice_id)
                t.column(serial_number)
                t.column(flag)

                t.primaryKey(userid, bt_mac)
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }

}

extension DeviceConnectListDataHelper {

    static func insertOrUpdate(items: [T], complete: () -> Void) throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }


        try connection.transaction(.deferred, block: {
            for (index, item) in items.enumerated() {
                
                if try connection.run(table.filter(item.userid == userid).filter(item.bt_mac == bt_mac).update(item)) > 0 {
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

    static func insert(item: T) throws -> Int {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            let rowId = try connection.run(table.insert(item))
            guard rowId >= 0 else {
                throw DataAccessError.insertError
            }
            return Int(rowId)
        } catch _ {
            throw DataAccessError.insertError
        }
    }

    static func update(item: T) throws -> Bool {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let alice = table.filter(item.userid == userid).filter(item.bt_mac == bt_mac )
        if try connection.run(alice.update(item)) > 0 {
            return true
        } else {
            return false
        }

    }

    static func findFirstRow(macAddress: String) throws ->T? {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        if let item = try connection.pluck(table.filter(macAddress == bt_mac)) {
            return T.init(userid: item[userid],
                          bt_mac: item[bt_mac],
                          isupload: item[isupload],
                          device_name: item[device_name],
                          device_type: item[device_type],
                          davice_id: item[davice_id],
                          serial_number: item[serial_number],
                          flag: item[flag])
        }
        return nil
    }
}


