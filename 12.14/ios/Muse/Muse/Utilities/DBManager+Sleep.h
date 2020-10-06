//
//  DBManager+Sleep.h
//  Muse
//
//  Created by Ken.Jiang on 25/7/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "DBManager.h"

typedef NS_ENUM(NSUInteger, SleepState) {
    SleepStateInvaild = 0,
    SleepStateLightSleep = 1,
    SleepStateDeepSleep = 2,
    SleepStateWake = 3
};

@interface SleepData : NSObject

/**
 *  记录日期，NSNumber 包装的 NSTimeInterval（取整）
 */
@property (strong, nonatomic) NSNumber *date;
@property (assign, nonatomic) SleepState sleepState;

@end

@interface DBManager (Sleep)

+ (NSString *)sleepTableName;

- (void)setupSleepTable;

/**
 *  新增一个睡眠数据
 *
 *  @param sleepState 睡眠状态
 *  @param time       NSNumber 包装的 NSTimeInterval（取整）
 */
- (void)addSleepRecord:(SleepState)sleepState atTime:(NSNumber *)time;
- (void)addSleepRecords:(NSArray<SleepData *> *)datas;

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
- (NSDictionary *)analysisOfLastDaySleep;

/**
 *  查询某月份是否有记录
 *
 *  @param year  年份
 *  @param month 月份
 *
 *  @return 是否存在数据
 */
- (BOOL)hasSleepRecordsAtYear:(NSInteger)year month:(NSInteger)month;

/**
 *  获取某月内每天的睡眠时间，返回字典数组格式：@[@{TotalSleep:7.3, DeepSleep:1.5}, ...]
 *
 *  @param year  年份
 *  @param month 月份
 *
 *  @return 日睡眠时间字典数组
 */
- (NSArray<NSDictionary *> *)sleepTimesAtYear:(NSInteger)year
                                        month:(NSInteger)month;

/**
 *  插入某个月份的数据值为0
 *
 *  @param year  年份
 *  @param month 月份
 */
- (void)addInvaildSleepDatasToYear:(NSInteger)year month:(NSInteger)month;

@end
