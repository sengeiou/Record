//
//  DeviceDisplaySettingDataHelper.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/18.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

class DeviceDisplaySettingDataHelper: DataHelperProtocol {
    
    static let TABLE_NAME = "t_device_display_setting"
    
    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let uploadflag = Expression<String>("uploadflag")
    
    static let time_format = Expression<String>("time_format")
    static let date_format = Expression<String>("date_format")
    static let watch_face = Expression<String>("watch_face")
    static let language = Expression<String>("language")
    static let unit = Expression<String>("unit")
    
    static let sleep_notify_switch = Expression<String>("sleep_notify_switch")
    static let sleep_starttime = Expression<String>("sleep_starttime")
    static let sleep_endtime = Expression<String>("sleep_endtime")
    
    static let table = Table(TABLE_NAME)
    
    typealias T = DeviceDisplaySetting
    
    static func createTable() throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try connection.run( table.create(ifNotExists: true) {t in
                
                t.column(userid)
                t.column(bt_mac)
                t.column(uploadflag)
                
                t.column(time_format)
                t.column(date_format)
                t.column(watch_face)
                t.column(unit)
                t.column(language)
                
                t.column(sleep_notify_switch)
                t.column(sleep_starttime)
                t.column(sleep_endtime)
                
                t.primaryKey(userid, bt_mac)
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
    
}

extension DeviceDisplaySettingDataHelper {

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
    
    static func findFirstRow(macAddress: String) throws ->T? {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        
        if let item = try connection.pluck(table) {
            
            return DeviceDisplaySetting.init(userid: item[userid],
                                             bt_mac: item[bt_mac],
                                             uploadflag: item[uploadflag],
                                             time_format: item[time_format],
                                             date_format: item[date_format],
                                             watch_face: item[watch_face],
                                             unit: item[unit],
                                             language: item[language],
                                             sleep_notify_switch: item[sleep_notify_switch],
                                             sleep_starttime: item[sleep_starttime],
                                             sleep_endtime: item[sleep_endtime])
        }
        return nil
    }
}

