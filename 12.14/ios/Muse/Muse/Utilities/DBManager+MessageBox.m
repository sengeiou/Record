//
//  DBManager+MessageBox.m
//  Muse
//
//  Created by paycloud110 on 16/8/15.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "DBManager+MessageBox.h"

@implementation DBManager (MessageBox)

#pragma mark --<数据库初始化>
/** 创建数据库表名 */
+ (NSString *)messageBoxTableName
{
    return @"messageBoxTable";
}
/** 初始化数据库 */
- (void)setupMessageBoxTable
{
    [self setupTable:[DBManager messageBoxTableName]
       withTableInfo:[DBManager messageBoxTableTableInfo]];
}
/** 返回数据库字段信息 */
+ (NSDictionary<NSString *, NSString *> *)messageBoxTableTableInfo
{
    return @{@"message":@"Text",
             @"from_phone":@"Text",
             @"from_id":@"Text",
             @"to_id":@"Text",
             @"type":@"Text",
             @"time":@"Text",
             };
}
#pragma mark --<数据库功能>
- (void)addOneMessageBoxContent:(NSDictionary<NSString *, NSString *> *)boxDict
{
    [self addRecord:boxDict toTable:[DBManager messageBoxTableName]];
}
//- (NSMutableArray *)readMessageBoxTableAllData:(void (^)(NSMutableArray *object))completedBlock
- (NSMutableArray *)readMessageBoxTableAllData
{
    __block NSMutableArray *array = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM messageBoxTable"];
        while (resultSet.next) {
            NSDictionary *dict = [resultSet resultDictionary];
            [array addObject:dict];
        }
//        completedBlock(array);
    }];
    return array;
}
- (void)cancelMessageBoxTableAllData
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM messageBoxTable"];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}
@end
