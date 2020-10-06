//
//  UserinfoDataHelper.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/6/5.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

class UserinfoDataHelper: DataHelperProtocol {

    static let TABLE_NAME = "t_userinfo"

    static let userid = Expression<String>("userid")
    static let bt_mac = Expression<String>("bt_mac")
    static let uploadflag = Expression<String>("uploadflag")

    static let username = Expression<String>("username")
    static let nickname = Expression<String>("nickname")
    static let firstname = Expression<String>("firstname")
    static let lastname = Expression<String>("lastname")
    static let icon = Expression<String>("icon")

    static let birthday = Expression<String>("birthday")
    static let gender = Expression<String>("gender")
    static let height = Expression<String>("height")
    static let weight = Expression<String>("weight")

    static let rate_switch = Expression<String>("rate_switch")
    static let goal = Expression<String>("goal")
    static let calculating = Expression<String>("calculating")

    static let mobile = Expression<String>("mobile")
    static let email = Expression<String>("email")
    static let language = Expression<String>("language")
    static let status = Expression<String>("status")

    static let table = Table(TABLE_NAME)

    typealias T = UserInfoModel

    static func createTable() throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try connection.run( table.create(ifNotExists: true) {t in

                t.column(userid, primaryKey: true)
                t.column(bt_mac)
                t.column(uploadflag)

                t.column(username)
                t.column(nickname)
                t.column(firstname)
                t.column(lastname)
                t.column(icon)

                t.column(birthday)
                t.column(gender)
                t.column(height)
                t.column(weight)

                t.column(goal)
                t.column(calculating)
                t.column(rate_switch)

                t.column(mobile)
                t.column(email)
                t.column(language)
                t.column(status)
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }

  
}
extension UserinfoDataHelper {

    static func insertOrUpdate(items: [T], complete: () -> Void) throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        try connection.transaction(.deferred, block: {
            for (index, item) in items.enumerated() {

                if try connection.run(table.filter(item.userid == userid).update(item)) > 0 {
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

        let alice = table.filter(item.userid == userid)
        if try connection.run(alice.update(item)) > 0 {
            return true
        } else {
            return false
        }

    }
    static func findFirstRow(userID: String) throws ->T {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        if let item = try connection.pluck(table.filter(userid == userID)) {
            return UserInfoModel.init(userid: item[userid],
                                      bt_mac: item[bt_mac],
                                      uploadflag: item[uploadflag],
                                      username: item[username],
                                      nickname: item[nickname],
                                      firstname: item[firstname],
                                      lastname: item[lastname],
                                      icon: item[icon],
                                      birthday: item[birthday],
                                      gender: item[gender],
                                      height: item[height],
                                      weight: item[weight],
                                      rate_switch: item[rate_switch],
                                      goal: item[goal],
                                      calculating: item[calculating],
                                      mobile: item[mobile],
                                      email: item[email],
                                      language: item[language],
                                      status: item[status])

        }
        return UserInfoModel()
    }
    static func checkColumnExists(item: T) throws -> Bool {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        let alice = table.filter(item.userid == userid).exists

        let isExists = try connection.scalar(alice)
        return  isExists
    }
}
