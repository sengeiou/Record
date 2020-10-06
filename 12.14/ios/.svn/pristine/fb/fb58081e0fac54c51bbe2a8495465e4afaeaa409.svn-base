//
//  DBManager.m
//  Muse
//
//  Created by Ken.Jiang on 6/7/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "DBManager.h"

#import "NSFileManager+FastKit.h"

#import "DBManager+HeartRate.h"
#import "DBManager+Sleep.h"
#import "DBManager+Contacts.h"
#import "DBManager+Friends.h"
#import "DBManager+MessageBox.h"

@interface DBManager ()

@end

@implementation DBManager

#pragma mark - Class Methods

+ (instancetype)sharedManager {
    static DBManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DBManager alloc] init];
    });
    
    return _manager;
}

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        NSString *dbPath = [NSFileManager getDocumentsFile:@"muse.db"];
        
        
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
        
        
        // 需要用到表的初始化
        [self setupHeartRateTable];
        [self setupSleepTable];
        [self setupContactsTable];
        [self setupFriendsTable];
        [self setupMessageBoxTable];
        
        
        
    }
    
    return self;
}

#pragma mark - Public

- (void)setupTable:(NSString *)tableName
     withTableInfo:(NSDictionary<NSString *, NSString *> *)tableInfo {
    if (!tableName || !tableInfo.count) {
        return;
    }
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSMutableString *tableSetupString = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (", tableName];
//        "CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";
        /*
         
         */
        NSArray *keys = tableInfo.allKeys;
        if ([db tableExists:tableName]) {
            //已有表，检查插入新列（字段）
            for (NSString *key in keys) {
                if (![db columnExists:key inTableWithName:tableName]) {
                    [db executeUpdateWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName,
                     key, tableInfo[key]];

                }
            }
            
        } else {
            //创建新表
            for (NSString *key in keys) {
                [tableSetupString appendFormat:@"%@ %@,", key, tableInfo[key]];
            }
            NSRange lastCommaRange = NSMakeRange(tableSetupString.length - 1, 1);
            [tableSetupString replaceCharactersInRange:lastCommaRange
                                            withString:@")"];
            
            [db executeStatements:tableSetupString];
        }
        
        if ([tableName isEqualToString:@"ContactsTable"]) {
                
//                [db open];
                [db executeUpdate:@"CREATE INDEX ContactsTableIndex on ContactsTable(phone, initial, name, isMuseUser)"];
//                [db close];
            
        }
        
        
    }];
}

- (void)addRecord:(NSDictionary<NSString *,NSString *> *)record
          toTable:(NSString *)tableName {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSMutableString *sql = [NSMutableString stringWithFormat:@"REPLACE INTO %@ (", tableName];
        
        NSArray *keys = record.allKeys;
        for (NSString *key in keys) {
            [sql appendFormat:@"%@,", key];
        }
        NSRange lastCommaRange = NSMakeRange(sql.length - 1, 1);
        [sql replaceCharactersInRange:lastCommaRange
                           withString:@") VALUES ("];
        
        for (NSString *key in keys) {
            [sql appendFormat:@"'%@',", record[key]];
        }
        lastCommaRange = NSMakeRange(sql.length - 1, 1);
        [sql replaceCharactersInRange:lastCommaRange
                           withString:@")"];
        
//        NSLog(@"%@", sql);
        [db executeUpdate:sql];
    }];
}



@end
