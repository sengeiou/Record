//
//  DBManager+Sleep.m
//  Muse
//
//  Created by Ken.Jiang on 25/7/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "DBManager+Sleep.h"
#import "NSDate+FastKit.h"

@implementation SleepData

@end

@implementation DBManager (Sleep)

+ (NSString *)sleepTableName {
    return @"SleepTable";
}

+ (NSDictionary<NSString *, NSString *> *)sleepTableInfo {
    return @{@"RecordDate":@"INTEGER Unique",// OR timestamp？
             @"SleepState":@"INTEGER"};
}

#pragma mark - Public

- (void)setupSleepTable {
    [self setupTable:[DBManager sleepTableName]
       withTableInfo:[DBManager sleepTableInfo]];
}

#pragma mark - Update

- (void)addSleepRecord:(SleepState)sleepState atTime:(NSNumber *)time  {
    NSDictionary *record = @{@"RecordDate":time, @"SleepState":@(sleepState)};
    
    [self addRecord:record toTable:[DBManager sleepTableName]];
}

- (void)addSleepRecords:(NSArray<SleepData *> *)datas {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db setShouldCacheStatements:YES];
        NSString *sql = @"REPLACE INTO SleepTable (RecordDate, SleepState) VALUES (?, ?)";
        
        [db beginTransaction];
        for (SleepData *data in datas) {
            [db executeUpdate:sql, data.date, data.sleepState];
        }
        [db commit];
    }];
}

- (void)addInvaildSleepDatasToYear:(NSInteger)year month:(NSInteger)month {
    NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
    NSDate *date = [NSDate dateWithString:[NSString stringWithFormat:@"%04ld-%02ld-01", (long)year, (long)month] format:@"yyyy-MM-dd"];
    NSInteger endTime = [[date endOfMonth] timeIntervalSince1970];
    
    if (nowTime < endTime) { //如果要插入的数据时间大于现在，当月数据不做插0处理
        return;
    }
    
    NSInteger startTime = [[date beginningOfMonth] timeIntervalSince1970];
    NSInteger deltaTime = 10 * 60;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db setShouldCacheStatements:YES];
        
        NSString *sql = @"REPLACE INTO SleepTable (RecordDate, SleepState) VALUES (?, ?)";
        
        [db beginTransaction];
        
        for (NSInteger time = startTime; time <= endTime; time += deltaTime) {
            if (time >= nowTime) {
                break;
            }
            
            [db executeUpdate:sql, @(time), @"3"];
        }
        
        [db commit];
    }];
}

#pragma mark - Query

/**
 *  获取昨天睡眠分析(时间从前一天中午（>）12点，到今天早上(<=)12点)，返回字典格式示例如下：
 {
    totalSleep: 5.33 //总睡眠时间
    deepSleep: 0.58 //深睡总时长
    lightSleep: 4.45 //浅睡总时长
    wakeTime: 0.23 //清醒时长
    startTime: 00:35 //入睡时间
    endTime: 06:53 //结束时间
    sleepDetail:[
                @{@"type":@(SleepGrapTypeDeep),@"period":@5,@"time":@"5:20-5:30"},
                @{@"type":@(SleepGrapTypeDeep),@"period":@(8),@"time":@"5:20-5:30"},
                ...
                ]
 }
 *
 *  @return 睡眠分析信息字典
 */
- (NSDictionary *)analysisOfLastDaySleep {
    __block NSMutableDictionary *analysis = [NSMutableDictionary dictionary];
    
    long today = (long)[[[NSDate date] beginningOfDay] timeIntervalSince1970];
    NSString *startTime = [NSString stringWithFormat:@"%ld", today - 12 * 3600];
    NSString *endTime = [NSString stringWithFormat:@"%ld", today + 12 * 3600];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        //总睡眠时间
        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(SleepState) AS SleepCount FROM SleepTable WHERE \
                         (RecordDate > '%@' AND RecordDate <= '%@') AND \
                         (SleepState = 1 OR SleepState = 2)", startTime, endTime];
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            NSInteger count = [rs intForColumn:@"SleepCount"];
            analysis[@"totalSleep"] = [NSString stringWithFormat:@"%.2f", count/6.f]; //每个记录的时间为10分钟，转化成小时
        }
        [rs close];
        
        //深睡时间
        sql = [NSString stringWithFormat:@"SELECT COUNT(SleepState) AS SleepCount FROM SleepTable WHERE \
               (RecordDate > '%@' AND RecordDate <= '%@') AND \
               (SleepState = 2)", startTime, endTime];
        rs = [db executeQuery:sql];
        if ([rs next]) {
            NSInteger count = [rs intForColumn:@"SleepCount"];
            analysis[@"deepSleep"] = [NSString stringWithFormat:@"%.2f", count/6.f]; //每个记录的时间为10分钟，转化成小时
        }
        [rs close];
        
        //浅睡时间
        sql = [NSString stringWithFormat:@"SELECT COUNT(SleepState) AS SleepCount FROM SleepTable WHERE \
               (RecordDate > '%@' AND RecordDate <= '%@') AND \
               (SleepState = 1)", startTime, endTime];
        rs = [db executeQuery:sql];
        if ([rs next]) {
            NSInteger count = [rs intForColumn:@"SleepCount"];
            analysis[@"lightSleep"] = [NSString stringWithFormat:@"%.2f", count/6.f]; //每个记录的时间为10分钟，转化成小时
        }
        [rs close];
        
        //清醒时间
        sql = [NSString stringWithFormat:@"SELECT COUNT(SleepState) AS SleepCount FROM SleepTable WHERE \
               (RecordDate > '%@' AND RecordDate <= '%@') AND \
               (SleepState = 3)", startTime, endTime];
        rs = [db executeQuery:sql];
        if ([rs next]) {
            NSInteger count = [rs intForColumn:@"SleepCount"];
            analysis[@"wakeTime"] = [NSString stringWithFormat:@"%.2f", count/6.f]; //每个记录的时间为10分钟，转化成小时
        }
        [rs close];
        
        //入睡时间
        sql = [NSString stringWithFormat:@"SELECT RecordDate FROM SleepTable WHERE \
               (RecordDate > '%@' AND RecordDate <= '%@') AND \
               (SleepState = 1 OR SleepState = 2) ORDER BY RecordDate ASC", startTime, endTime];
        rs = [db executeQuery:sql]; //正序查找睡觉的状态
        if ([rs next]) { //找出第一条
            NSInteger timestamp = (NSInteger)[rs longLongIntForColumn:@"RecordDate"];
            analysis[@"startTime"] = [[NSDate dateWithTimeIntervalSince1970:timestamp] stringWithFormat:@"HH:mm"];
        } else {
            analysis[@"startTime"] = @"0";
        }
        [rs close];
        
        //结束时间
        sql = [NSString stringWithFormat:@"SELECT RecordDate FROM SleepTable WHERE \
               (RecordDate > '%@' AND RecordDate <= '%@') AND \
               (SleepState = 1 OR SleepState = 2) ORDER BY RecordDate DESC", startTime, endTime];
        rs = [db executeQuery:sql]; //逆序查找睡觉的状态
        if ([rs next]) { //找出第一条
            NSInteger timestamp = (NSInteger)[rs longLongIntForColumn:@"RecordDate"];
            analysis[@"endTime"] = [[NSDate dateWithTimeIntervalSince1970:timestamp] stringWithFormat:@"HH:mm"];
        } else {
            analysis[@"endTime"] = @"0";
        }
        [rs close];
        
        //sleepDetail
        NSMutableArray *detailArr = [NSMutableArray array];
        SleepState _preSleepState = SleepStateInvaild;
        NSInteger _sleepStateCount = 0;
        
        sql = [NSString stringWithFormat:@"SELECT SleepState FROM SleepTable WHERE \
               (RecordDate > '%@' AND RecordDate <= '%@') AND \
               (SleepState = 1 OR SleepState = 2) ORDER BY RecordDate ASC", startTime, endTime];
        rs = [db executeQuery:sql];
        
        while ([rs next]) {
            SleepState state = [rs intForColumn:@"SleepState"];
            
            if (_preSleepState == state) {
                _sleepStateCount++;
                NSMutableDictionary *detail = [detailArr lastObject];
                detail[@"period"] = @(_sleepStateCount);
            } else {
                _sleepStateCount = 1;
                
                if (state == SleepStateInvaild) {
                    state = SleepStateWake;
                }
                
                //detail字典key参照SleepGraphView定义
                NSMutableDictionary *detail = [NSMutableDictionary dictionary];
                detail[@"type"] = @(state);
                detail[@"period"] = @(_sleepStateCount);
                
//                NSInteger timestamp = [rs longLongIntForColumn:@"RecordDate"];
//                detail[@"time"] = @"5:20-5:30";
                
                [detailArr addObject:detail];
            }
            
            _preSleepState = state;
        }
        [rs close];
        
        analysis[@"sleepDetail"] = detailArr;
    }];
    
    return analysis;
}

- (BOOL)hasSleepRecordsAtYear:(NSInteger)year month:(NSInteger)month {
    if (month < 1 || month > 12) {
        return NO;
    }
    
    __block BOOL hasRecords = NO;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSDate *date = [NSDate dateWithString:[NSString stringWithFormat:@"%04ld-%02ld-01", (long)year, (long)month]
                                       format:@"yyyy-MM-dd"];
        NSInteger beginningTime = [[date beginningOfMonth] timeIntervalSince1970] - 12 * 3600;
        NSInteger endTime = [[date endOfMonth] timeIntervalSince1970] - 12 * 3600;
        
        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(SleepState) AS Count FROM SleepTable WHERE RecordDate > '%ld' AND RecordDate <= '%ld'", (long)beginningTime, (long)endTime];
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            hasRecords = [rs intForColumn:@"Count"] > 0;
        }
        [rs close];
    }];
    
    return hasRecords;
}

- (NSArray<NSDictionary *> *)sleepTimesAtYear:(NSInteger)year
                                        month:(NSInteger)month {
    if (month < 1 || month > 12) {
        return nil;
    }
    
    __block NSMutableArray *result = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSDate *date = [NSDate dateWithString:[NSString stringWithFormat:@"%04ld-%02ld-01", (long)year, (long)month]
                                       format:@"yyyy-MM-dd"];
        NSInteger beginningTime = [[date beginningOfMonth] timeIntervalSince1970] - 12 * 3600;
        NSInteger endTime = [[date endOfMonth] timeIntervalSince1970] - 12 * 3600;
        NSInteger daySecs = 24 * 3600;
        
        for (NSInteger time = beginningTime; time <= endTime; time += daySecs) {
            NSMutableDictionary *daySleepInfo = [NSMutableDictionary dictionary];
            
            //总睡眠时间
            NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(SleepState) AS SleepCount FROM SleepTable WHERE \
                             (RecordDate > '%ld' AND RecordDate <= '%ld') AND \
                             (SleepState = 1 OR SleepState = 2)", (long)time, (long)(time + daySecs)];
            FMResultSet *rs = [db executeQuery:sql];
            if ([rs next]) {
                NSInteger count = [rs intForColumn:@"SleepCount"];
                daySleepInfo[@"TotalSleep"] = [NSString stringWithFormat:@"%.2f", count/6.f]; //每个记录的时间为10分钟，转化成小时
            }
            [rs close];
            
            //深睡时间
            sql = [NSString stringWithFormat:@"SELECT COUNT(SleepState) AS SleepCount FROM SleepTable WHERE \
                   (RecordDate > '%ld' AND RecordDate <= '%ld') AND \
                   (SleepState = 2)", (long)time, (long)(time + daySecs)];
            rs = [db executeQuery:sql];
            if ([rs next]) {
                NSInteger count = [rs intForColumn:@"SleepCount"];
                daySleepInfo[@"DeepSleep"] = [NSString stringWithFormat:@"%.2f", count/6.f]; //每个记录的时间为10分钟，转化成小时
            }
            [rs close];
            
            [result addObject:daySleepInfo];
        }
    }];
    
    return result;
}

@end
