//
//  SQLiteDataStore.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/5/31.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import Foundation
import SQLite
import SQLiteMigrationManager

enum DataAccessError: Swift.Error {
    case datastoreConnectionError
    case insertError
    case updateError
    case deleteError
    case searchError
    case nilInData
    case nomoreData
}

class SQLiteDataStore {
    
    static var sharedInstance: SQLiteDataStore?  = SQLiteDataStore()
    var connection: Connection?
    var migrationManager: SQLiteMigrationManager!
    
    private init() {
        
        let dirs: [NSString] =
            NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                FileManager.SearchPathDomainMask.allDomainsMask, true) as [NSString]

        var dbName = "FD070Plus"
        if !CurrentUserID.isEmpty {
            dbName = CurrentUserID
        }
        let userEmailNameKey = dbName
        
        let dir = dirs[0]
        let userDBName = userEmailNameKey + ".sqlite"
        let path = dir.appendingPathComponent(userDBName)
        
        print("The DB Path:",path)
        
        do {
            connection = try Connection(path)
            // set connection busy timeout
            connection?.busyTimeout = 20
        } catch _ {
            connection = nil 
        }
        //Init migration manager
        self.migrationManager = SQLiteMigrationManager(db: self.connection!, migrations: SQLiteDataStore.migrations(), bundle: nil)

    }
    
    static func destroyInstance() {
        sharedInstance = nil
    }
    static func reSetInstance() {
        sharedInstance = SQLiteDataStore()
    }
    
    /// Create tables
    ///
    /// - Throws: Error
    func createTables() throws {
        
        do {
            //按照数据库文档建的表
            try UserinfoDataHelper.createTable()
            try DeviceDisplaySettingDataHelper.createTable()

            try CurrentDataHelper.createTable()
            try DailyDetailDataHelper.createTable()

            try SportSummaryDataHelper.createTable()

            try SleepDetailDataHelper.createTable()
            try SleepSummaryDataHelper.createTable()

            try WorkoutDetialDataHelper.createTable()
            try WorkoutSummaryDataHelper.createTable()
            try WorkoutTargetDataHelper.createTable()

            try BloodSugarTestDataHelp.createTable()
            try HeartRateTestHelper.createTable()

            try DeviceConnectListDataHelper.createTable()
            try DeviceInfoDataHelper.createTable()

            //未按照文档，先前建的表(后续可能删除)
            try GlucoseCollectDataHelper.createTable()

            //为满足当前应用逻辑建的表
            try CurrentDayFlagDataHelper.createTable()

        } catch {
            throw DataAccessError.datastoreConnectionError
        }
        
    }
}
// MARK: - Migrateion
extension SQLiteDataStore {
    
    /// Migrate if needed
    ///
    /// - Throws: Throws error
    func migrateIfNeeded() throws {
        
        if !migrationManager.hasMigrationsTable() {
            try migrationManager.createMigrationsTable()
        }
        
        if migrationManager.needsMigration() {
            try migrationManager.migrateDatabase()
        }
    }
    
    /// Migrateions
    ///
    /// - Returns: The migraion instances
    static func migrations() -> [Migration] {
        return [
            Migration20181203094641()
        ]
    }
}

// MARK: - CustomStringConvertible
extension SQLiteDataStore: CustomStringConvertible {
    
    /// Migrations description
    var description: String {
        return "hasMigrationsTable: \(migrationManager.hasMigrationsTable())" +
            " currentVersion: \(migrationManager.currentVersion())" +
            " originVersion: \(migrationManager.originVersion())" +
            " appliedVersions: \(migrationManager.appliedVersions())" +
            " pendingMigrations: \(migrationManager.pendingMigrations())" +
        " needsMigration: \(migrationManager.needsMigration())"
    }
}

extension SQLiteDataStore {
    
    /// Monitor table update
    func monitorTableUpdateHook()  {
        let connection =  SQLiteDataStore.sharedInstance!.connection
        connection?.updateHook({ (operation, db, table, rowid) in
            DispatchQueue.main.async {
                let tableNamePrefix = "t_"
                if table == tableNamePrefix + TableNameEnum.userinfo.rawValue {
                    NotificationCenter.post(custom: .DBTableUpdate, object: TableNameEnum.userinfo)
                }else if table == tableNamePrefix + TableNameEnum.bloodsugar_result.rawValue {
                    NotificationCenter.post(custom: .DBTableUpdate, object: TableNameEnum.bloodsugar_result)
                }else if table == tableNamePrefix + TableNameEnum.daily_detail.rawValue {
                    NotificationCenter.post(custom: .DBTableUpdate, object: TableNameEnum.daily_detail)
                }else if table == tableNamePrefix + TableNameEnum.device_info.rawValue {
                    NotificationCenter.post(custom: .DBTableUpdate, object: TableNameEnum.device_info)
                }else if table == tableNamePrefix + TableNameEnum.workout_summary.rawValue {
                    NotificationCenter.post(custom: .DBTableUpdate, object: TableNameEnum.workout_summary)
                }else if table == tableNamePrefix + TableNameEnum.current.rawValue {
                    NotificationCenter.post(custom: .DBTableUpdate, object: TableNameEnum.current)
                }
            }
        })
    }
    
}



