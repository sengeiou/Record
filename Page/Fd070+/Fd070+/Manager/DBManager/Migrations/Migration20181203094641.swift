//
//  Migration20181203094641.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/12/3.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import SQLite
import SQLiteMigrationManager

struct Migration20181203094641: Migration {

    //The version value named is like: 2018-12-03 09:46:41
    var version: Int64 = 20181203094641

    /// perform the migration here
    ///
    /// - Parameter db: The db connection
    /// - Throws: Throw Error
    func migrateDatabase(_ db: Connection) throws {

        //Add column
//        let HQStr = Expression<String?>("HQStr")
//        try db.run(LightHourseHelper.table.addColumn(HQStr))

        //Rename table
//        try db.run(LightHourseHelper.table.rename(Table("users_old")))

        //Create table
//       try LightHourseHelper.createTable()
        
    }
}
