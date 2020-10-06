//
//  SleepDataManager.h
//  Muse
//
//  Created by Ken.Jiang on 16/7/24.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager+Sleep.h"

@protocol SleepDataManagerDelegate <NSObject>

@optional
/**
 *  通知已获取到数据（界面可刷新）
 */
- (void)dataManagerDidFecthDatas;

@end

@interface SleepDataManager : NSObject

@property (weak, nonatomic) id<SleepDataManagerDelegate> delegate;

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
 *  获取某月内每天的睡眠时间，返回字典数组格式：@[@{TotalSleep:7.3, DeepSleep:1.5}, ...]
 *
 *  @param year  年份
 *  @param month 月份
 *
 *  @return 日睡眠时间字典数组
 */
- (NSArray<NSDictionary *> *)sleepDataForYear:(NSInteger)year month:(NSInteger)month;

@end
