//
//  SleepDataManager.m
//  Muse
//
//  Created by Ken.Jiang on 16/7/24.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SleepDataManager.h"
#import "MSSleepMonthDataRequest.h"

@interface SleepDataManager ()

@property (weak, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) NSMutableDictionary <NSString *, NSArray *> *monthRecords;

@end

@implementation SleepDataManager

- (instancetype)init {
    if (self = [super init]) {
        _dbManager = [DBManager sharedManager];
        _monthRecords = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - Public

- (NSDictionary *)analysisOfLastDaySleep {
    return [_dbManager analysisOfLastDaySleep];
}

/**
 *  获取某月内每天的睡眠时间，返回字典数组格式：@[@{TotalSleep:7.3, DeepSleep:1.5}, ...]
 *
 *  @param year  年份
 *  @param month 月份
 *
 *  @return 日睡眠时间字典数组
 */
- (NSArray<NSDictionary *> *)sleepDataForYear:(NSInteger)year month:(NSInteger)month {
    if (month < 1 || month > 12) {
        return nil;
    }
    NSString *time = [NSString stringWithFormat:@"%04ld-%02ld", (long)year, (long)month];
    NSArray *result = _monthRecords[time];
    
    if (result) {
        if ([result isEqual:[NSNull null]]) {
            return nil;
        }
    } else {
        if ([_dbManager hasSleepRecordsAtYear:year month:month]) {
            result = [_dbManager sleepTimesAtYear:year month:month];
            _monthRecords[time] = result;
        } else {
            _monthRecords[time] = (id)[NSNull null];
            __weak typeof(self) weakSelf = self;
            
            MSSleepMonthDataRequest *req = [[MSSleepMonthDataRequest alloc] init];
            req.dateMonth = time;

            [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
                if (!MSRequestIsSuccess(responseData)) {
                    return;
                }
                
                NSDictionary *data = MSResponseData(responseData);
                if ([data isKindOfClass:[NSDictionary class]]) {
                    NSArray *keys = [data.allKeys sortedArrayUsingSelector:@selector(compare:)];
                    NSMutableArray<NSDictionary *> *records = [NSMutableArray array];
                    
                    for (NSString *key in keys) {
                        NSDictionary *dataDic = data[key];
                        //返回的每个记录的时间为10分钟，转化成小时
                        NSDictionary *dic = @{@"TotalSleep":@([dataDic[@"sum"] floatValue]/6),
                                              @"DeepSleep":@([dataDic[@"is_deep"] floatValue]/6)};
                        [records addObject:dic];
                    }
                    
                    weakSelf.monthRecords[time] = records;
                    
                    if ([weakSelf.delegate respondsToSelector:@selector(dataManagerDidFecthDatas)]) {
                        [weakSelf.delegate dataManagerDidFecthDatas];
                    }
                } else {//没有插入空数据
                    [[DBManager sharedManager] addInvaildSleepDatasToYear:year month:month];
                    weakSelf.monthRecords[time] = [weakSelf.dbManager sleepTimesAtYear:year month:month];
                }
            
            } failure:nil];
        }
    }
    
    return result;
}

@end
