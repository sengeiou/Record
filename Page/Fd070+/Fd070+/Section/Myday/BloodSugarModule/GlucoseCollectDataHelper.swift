//
//  GlucoseCollectDataHelper.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/2.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

class GlucoseCollectDataHelper: DataHelperProtocol {

    static let TABLE_NAME = "t_glucose_collect"

    static let timeStamp = Expression<String>("timeStamp")
    static let userId = Expression<String>("userId")
    static let btMac = Expression<String>("btMac")

    static let greenLightSignal = Expression<String>("greenLightSignal")
    static let redLightSignal = Expression<String>("redLightSignal")
    static let IRLightSignal = Expression<String>("IRLightSignal")

    static let accRatiionXAxis = Expression<String>("accRatiionXAxis")
    static let accRatiionYAxis = Expression<String>("accRatiionYAxis")
    static let accRatiionZAxis = Expression<String>("accRatiionZAxis")

    static let greenLightCurrent = Expression<String>("greenLightCurrent")
    static let redLightCurrent = Expression<String>("redLightCurrent")
    static let IRLightCurrent = Expression<String>("IRLightCurrent")

    static let packageNumber = Expression<String>("packageNumber")
    static let packageTheTailToIdentify = Expression<String>("packageTheTailToIdentify")


    static let table = Table(TABLE_NAME)

    typealias T = GlucoseCollectModel

    static func createTable() throws {
        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try connection.run( table.create(ifNotExists: true) {t in

                t.column(timeStamp)
                t.column(userId)
                t.column(btMac)

                t.column(greenLightSignal)
                t.column(redLightSignal)
                t.column(IRLightSignal)

                t.column(accRatiionXAxis)
                t.column(accRatiionYAxis)
                t.column(accRatiionZAxis)

                t.column(greenLightCurrent)
                t.column(redLightCurrent)
                t.column(IRLightCurrent)

                t.column(packageNumber)
                t.column(packageTheTailToIdentify)

                t.primaryKey(timeStamp, userId, btMac)

            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
}

extension GlucoseCollectDataHelper {

    static func insertOrUpdate(items: [T], complete: () -> Void) throws {

        guard let connection =  SQLiteDataStore.sharedInstance!.connection else {
            throw DataAccessError.datastoreConnectionError
        }

        try connection.transaction(.deferred, block: {
            for (index, item) in items.enumerated() {
                if try connection.run(table.filter(item.timeStamp == timeStamp).filter(item.userId == userId).filter(item.btMac == btMac).update(item)) > 0 {
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
            let model = GlucoseCollectModel.init(timeStamp: item[timeStamp],
                                                 userId: item[userId],
                                                 btMac: item[btMac],
                                                 greenLightSignal: item[greenLightSignal],
                                                 redLightSignal: item[redLightSignal],
                                                 IRLightSignal: item[IRLightSignal],
                                                 accRatiionXAxis: item[accRatiionXAxis],
                                                 accRatiionYAxis: item[accRatiionYAxis],
                                                 accRatiionZAxis: item[accRatiionZAxis],
                                                 greenLightCurrent: item[greenLightCurrent],
                                                 redLightCurrent: item[redLightCurrent],
                                                 IRLightCurrent: item[IRLightCurrent],
                                                 packageNumber: item[packageNumber],
                                                 packageTheTailToIdentify: item[packageTheTailToIdentify])
            retArray.append(model)
        }

        return retArray

    }

}

