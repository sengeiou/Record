//
//  SleepSummaryDataHelper.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/20.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

class SleepSummaryDataHelper: DataHelperProtocol {
    
    static let TABLE_NAME = "t_sleep_summary"
    
    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let isupload = Expression<String>("isupload")
    
    static let date = Expression<String>("date")
    static let start_time = Expression<String>("start_time")
    static let end_time = Expression<String>("end_time")
    static let deep_sleep = Expression<String>("deep_sleep")
    static let light_sleep = Expression<String>("light_sleep")
    
    static let awake = Expression<String>("awake")
    static let sleep_quality = Expression<String>("sleep_quality")
    static let sleep_durtaion = Expression<String>("sleep_durtaion")
    static let reached = Expression<String>("reached")
    
    static let table = Table(TABLE_NAME)
    
    typealias T = SleepSummaryDataModel
    
    
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
                t.column(start_time)
                t.column(end_time)
                t.column(deep_sleep)
                t.column(light_sleep)
                
                t.column(awake)
                t.column(sleep_quality)
                t.column(sleep_durtaion)
                t.column(reached)
                
                t.primaryKey(userid, bt_mac, date)
                
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
    
    
}

extension SleepSummaryDataHelper {
   
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
                                   date: item[date],
                                   start_time: item[start_time],
                                   end_time: item[end_time],
                                   deep_sleep: item[deep_sleep],
                                   light_sleep: item[light_sleep],
                                   awake: item[awake],
                                   sleep_quality: item[sleep_quality],
                                   sleep_durtaion: item[sleep_durtaion],
                                   reached: item[reached]))
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
                                   date: item[date],
                                   start_time: item[start_time],
                                   end_time: item[end_time],
                                   deep_sleep: item[deep_sleep],
                                   light_sleep: item[light_sleep],
                                   awake: item[awake],
                                   sleep_quality: item[sleep_quality],
                                   sleep_durtaion: item[sleep_durtaion],
                                   reached: item[reached]))
        }
        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }
}

