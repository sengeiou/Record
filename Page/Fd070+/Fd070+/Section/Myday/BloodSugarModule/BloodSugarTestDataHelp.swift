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
    
    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let isupload = Expression<String>("isupload")
    
    //为主键并且，每天最多只能有一天
    static let start_time = Expression<String>("start_time")
    //血糖的具体指，1（Low），2（Normal），3（Heigh）
    static let boolsugar = Expression<String>("boolsugar")


    static let table = Table(TABLE_NAME)
    
    typealias T = BloodSugarResultModel
    
    static func createTable() throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try connection.run( table.create(ifNotExists: true) {t in
                
                t.column(userid)
                t.column(bt_mac)
                t.column(isupload)
                
                t.column(start_time)
                t.column(boolsugar)

                t.primaryKey(userid, bt_mac, start_time)
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
}

extension BloodSugarTestDataHelp {

    static func insertOrUpdate(items: [T], complete: () -> Void) throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        try connection.transaction(.deferred, block: {
            for (index, item) in items.enumerated() {

                if try connection.run(table.filter(item.userid == userid).filter(item.bt_mac == bt_mac).filter(item.start_time == start_time).update(item)) > 0 {
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
    static func find(queryStr: String) throws -> [BloodSugarResultModel] {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        var retArray = [T]()
        let items = try connection.prepare(table)

        for item in items {
            retArray.append(BloodSugarResultModel.init(userid: item[userid],
                                                       bt_mac: item[bt_mac],
                                                       isupload: item[isupload],
                                                       start_time: item[start_time],
                                                       boolsugar: item[boolsugar]))
        }

        return retArray
    }

    /// 单独当天测试了的血糖数据
    ///
    /// - Parameter queryStr: 要查询的日期(2018/01/03)
    /// - Returns: 查询到数据
    /// - Throws: 错误抛出
    static func findCurrentData(date: String, macAddress: String) throws -> [T] {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let startStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(date) 00:00:00", timeForm: "yyyy/MM/dd HH:mm:ss")
        let endDateStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(date) 23:59:59", timeForm: "yyyy/MM/dd HH:mm:ss")

        let query = table.filter((start_time > startStr) && (start_time < endDateStr)).filter(bt_mac == macAddress)

        let items = try connection.prepare(query)

        var retArray = [T]()
        for item in  items {
            retArray.append(BloodSugarResultModel.init(userid: item[userid],
                                                       bt_mac: item[bt_mac],
                                                       isupload: item[isupload],
                                                       start_time: item[start_time],
                                                       boolsugar: item[boolsugar]))
        }

        return retArray
    }

    static func getLatestBloodGluResultGromDB(dayStr: String) throws -> BloodSugarResultModel? {

        let startStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(dayStr) 00:00:00", timeForm: "yyyy/MM/dd HH:mm:ss")
        let endDateStr = FDDateHandleTool.dateStringToTimeStamp(stringTime: "\(dayStr) 23:59:59", timeForm: "yyyy/MM/dd HH:mm:ss")
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let HRQuery = table.filter((start_time > startStr) && (start_time < endDateStr)).order(start_time.desc)
        let HRitemFrist = Array(try connection.prepare(HRQuery)).first
        var HRModel = BloodSugarResultModel()
        if let item = HRitemFrist {
            HRModel = BloodSugarResultModel.init(userid: item[userid],
                                                 bt_mac: item[bt_mac],
                                                 isupload: item[isupload],
                                                 start_time: item[start_time],
                                                 boolsugar: item[boolsugar])
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


    static func findNotUpdateData() throws -> [T]? {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let items = try connection.prepare(table.filter(isupload == "0"))
        var retArray = [T]()
        for item in items {
            retArray.append(BloodSugarResultModel.init(userid: item[userid],
                                                       bt_mac: item[bt_mac],
                                                       isupload: item[isupload],
                                                       start_time: item[start_time],
                                                       boolsugar: item[boolsugar]))
        }
        if retArray.isEmpty {
            return nil
        }else {
            return retArray
        }
    }
}
