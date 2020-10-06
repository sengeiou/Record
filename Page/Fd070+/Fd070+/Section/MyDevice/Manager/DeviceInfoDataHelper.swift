//
//  DeviceInfoDBHelper.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/24.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

class DeviceInfoDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "t_device_info"

    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let isupload = Expression<String>("isupload")

    static let device_name = Expression<String>("device_name")
    static let device_id = Expression<String>("device_id")
    static let customary_unit = Expression<String>("customary_unit")
    static let customary_hand = Expression<String>("customary_hand")
    static let hr_test_switch = Expression<String>("hr_test_switch")

    static let automatic_sync = Expression<String>("automatic_sync")
    static let band_version = Expression<String>("band_version")
    static let app_version = Expression<String>("app_version")
    static let dial_style = Expression<String>("dial_style")
    
    static let table = Table(TABLE_NAME)
    
    typealias T = DeviceInfoModel

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
                t.column(device_id)
                t.column(customary_unit)
                t.column(customary_hand)
                t.column(hr_test_switch)

                t.column(automatic_sync)
                t.column(band_version)
                t.column(app_version)
                t.column(dial_style)

                t.primaryKey(userid, bt_mac)
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
    

}
extension DeviceInfoDataHelper{
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

    static func update(item: T) throws -> Bool {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let alice = table.filter(item.userid == userid).filter(item.bt_mac == bt_mac)
        if try connection.run(alice.update(item)) > 0 {
            return true
        } else {
            return false
        }

    }

    static func delete (item: T) throws -> Void {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let deviceMacAddress = item.bt_mac
        do {
            let tmp = try connection.run(table.filter(bt_mac == deviceMacAddress).delete())
            guard tmp == 1 else {
                throw DataAccessError.deleteError
            }
        } catch _ {
            throw DataAccessError.deleteError
        }
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
                                   device_name: item[device_name],
                                   device_id: item[device_id],
                                   customary_unit: item[customary_unit],
                                   customary_hand: item[customary_hand],
                                   hr_test_switch: item[hr_test_switch],
                                   automatic_sync: item[automatic_sync],
                                   band_version: item[band_version],
                                   app_version: item[app_version],
                                   dial_style: item[dial_style]))
        }

        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }

    static func checkTableExists() throws -> Bool {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let isExists = try connection.scalar(table.exists)

        return isExists
    }


    static func findFirstRow(macAddress: String) throws ->T? {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        if let item = try connection.pluck(table.filter(bt_mac == macAddress)) {
            return T.init(userid: item[userid],
                          bt_mac: item[bt_mac],
                          isupload: item[isupload],
                          device_name: item[device_name],
                          device_id: item[device_id],
                          customary_unit: item[customary_unit],
                          customary_hand: item[customary_hand],
                          hr_test_switch: item[hr_test_switch],
                          automatic_sync: item[automatic_sync],
                          band_version: item[band_version],
                          app_version: item[app_version],
                          dial_style: item[dial_style])

        }
        return nil
    }
    static func findNotUpdateData() throws -> [T]? {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        let query =  table.filter((isupload) == "0")


        let items = try connection.prepare(query)
        var retArray = [T]()
        for item in items {
            let item = T.init(userid: item[userid],
                          bt_mac: item[bt_mac],
                          isupload: item[isupload],
                          device_name: item[device_name],
                          device_id: item[device_id],
                          customary_unit: item[customary_unit],
                          customary_hand: item[customary_hand],
                          hr_test_switch: item[hr_test_switch],
                          automatic_sync: item[automatic_sync],
                          band_version: item[band_version],
                          app_version: item[app_version],
                          dial_style: item[dial_style])
            retArray.append(item)
        }
        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }
}
