//
//  DBManager.h
//  Muse
//
//  Created by Ken.Jiang on 6/7/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB.h>

@interface DBManager : NSObject {
    
    FMDatabaseQueue *_dbQueue;
}

+ (instancetype)sharedManager;

/**
 *  创建或者设置一个table，tableInfo表结构信息例如:@{@"ColumnName":@"ColumnValueType DefualtValue", @"Name":@"Text Defualt Ken"}
 *
 *  @param tableName 表名
 *  @param tableInfo 表结构信息
 */
- (void)setupTable:(NSString *)tableName
     withTableInfo:(NSDictionary<NSString *, NSString *> *)tableInfo;

/**
 *  为表新增一条数据
 *
 *  @param record    数据（格式为 ColumnName:ColumnValue）
 *  @param tableName 表名
 */
- (void)addRecord:(NSDictionary<NSString *, NSString *> *)record
          toTable:(NSString *)tableName;

@end
