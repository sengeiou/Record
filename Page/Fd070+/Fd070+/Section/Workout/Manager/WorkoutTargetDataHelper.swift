//
//  WorkoutTargetDataHelper.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/25.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

class WorkoutTargetDataHelper: DataHelperProtocol {
    
    static let TABLE_NAME = "t_workout_target"
    
    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let isupload = Expression<String>("isupload")
    
    static let step = Expression<String>("step")
    static let calorie = Expression<String>("calorie")
    static let distance = Expression<String>("distance")
    static let splatpts = Expression<String>("splatpts")
    static let number = Expression<String>("number")
    
    static let table = Table(TABLE_NAME)
    
    typealias T = WorkoutTargetModel
    
    static func createTable() throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try connection.run( table.create(ifNotExists: true) {t in
                t.column(userid)
                t.column(bt_mac)
                t.column(isupload)
                
                t.column(step)
                t.column(calorie)
                t.column(distance)
                t.column(splatpts)
                t.column(number)
                
                t.primaryKey(userid, bt_mac)
                
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
}
extension WorkoutTargetDataHelper {
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
        
        if let item = try connection.pluck(table.filter(bt_mac == macAddress)) {
            
            return T.init(userid: item[userid],
                          bt_mac: item[bt_mac],
                          isupload: item[isupload],
                          step: item[step],
                          calorie: item[calorie],
                          distance: item[distance],
                          splatpts: item[splatpts],
                          number: item[number])
        }
        return nil
    }
}

