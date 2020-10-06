//
//  BloodGlucoseDBHelp.swift
//  FD070+
//
//  Created by WANG DONG on 2019/1/3.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit
import SQLite

class BloodSugarTestDataHelp: DataHelperProtocol {
    
    static let TABLE_NAME = "t_bloodsugar_result"
    
    static let userId = Expression<String>("userId")
    static let btMac = Expression<String>("btMac")
    static let uploadFlag = Expression<String>("uploadFlag")
    
    //为主键并且，每天最多只能有一天
    static let timeStamp = Expression<String>("timeStamp")
    //血糖的具体指，1（Low），2（Normal），3（Heigh）
    static let value = Expression<String>("value")
    
    
    static let table = Table(TABLE_NAME)
    
    typealias T = BloodSugarResultModel
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance!.BBDB else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try DB.run( table.create(ifNotExists: true) {t in
                
                t.column(userId)
                t.column(btMac)
                t.column(uploadFlag)
                
                t.column(timeStamp, primaryKey: true)
                t.column(value)
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
    
    static func insert(item: T) throws -> Int {
        guard let DB = SQLiteDataStore.sharedInstance!.BBDB else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            let rowId = try DB.run(table.insert(item))
            guard rowId >= 0 else {
                throw DataAccessError.insertError
            }
            return Int(rowId)
        } catch _ {
            throw DataAccessError.insertError
        }
    }

    static func find(queryStr: String) throws -> [BloodSugarResultModel] {

        guard let DB = SQLiteDataStore.sharedInstance!.BBDB else {
            throw DataAccessError.datastoreConnectionError
        }
        var retArray = [T]()
        let items = try DB.prepare(table)

        for item in items {
            retArray.append(BloodSugarResultModel.init(userId: item[userId],
                                                       btMac: item[btMac],
                                                       uploadFlag: item[uploadFlag],
                                                       timeStamp: item[timeStamp],
                                                       value: item[value]))
        }

        return retArray
    }

    /// 单独当天测试了的血糖数据
    ///
    /// - Parameter queryStr: 要查询的日期(2018/01/03)
    /// - Returns: 查询到数据
    /// - Throws: 错误抛出
    static func findCurrentData(date: String, macAddress: String) throws -> [T] {

        guard let DB = SQLiteDataStore.sharedInstance!.BBDB else {
            throw DataAccessError.datastoreConnectionError
        }

        let startStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(date) 00:00:00", timeForm: "yyyy/MM/dd HH:mm:ss")
        let endDateStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(date) 23:59:59", timeForm: "yyyy/MM/dd HH:mm:ss")

        let query = table.filter((timeStamp > startStr) && (timeStamp < endDateStr)).filter(btMac == macAddress)

        let items = try DB.prepare(query)

        var retArray = [T]()
        for item in  items {
            retArray.append(BloodSugarResultModel.init(userId: item[userId],
                                                       btMac: item[btMac],
                                                       uploadFlag: item[uploadFlag],
                                                       timeStamp: item[timeStamp],
                                                       value: item[value]))
        }

        return retArray
    }

    static func getLatestBloodGluResultGromDB(dayStr: String) throws -> BloodSugarResultModel? {

        let startStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(dayStr) 00:00:00", timeForm: "yyyy/MM/dd HH:mm:ss")
        let endDateStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(dayStr) 23:59:59", timeForm: "yyyy/MM/dd HH:mm:ss")
        guard let DB = SQLiteDataStore.sharedInstance!.BBDB else {
            throw DataAccessError.datastoreConnectionError
        }

        let HRQuery = table.filter((timeStamp > startStr) && (timeStamp < endDateStr)).order(timeStamp.desc)
        let HRitemFrist = Array(try DB.prepare(HRQuery)).first
        var HRModel = BloodSugarResultModel()
        if let item = HRitemFrist {
            HRModel = BloodSugarResultModel.init(userId: item[userId],
                                                 btMac: item[btMac],
                                                 uploadFlag: item[uploadFlag],
                                                 timeStamp: item[timeStamp],
                                                 value: item[value])
            return HRModel
        }

        return  nil

    }

    
    static func getBloodGluresult() -> BloodSugarResultModel {
        
        var GluValue = BloodSugarResultModel()
        if let bloodGluModel:BloodSugarResultModel = try! BloodSugarTestDataHelp.getLatestBloodGluResultGromDB(dayStr: FDDateHandleTool.getCurrentDate(dateType: "yyyy/MM/dd")) {
            GluValue = bloodGluModel
        }
        
        return GluValue
    }
}
