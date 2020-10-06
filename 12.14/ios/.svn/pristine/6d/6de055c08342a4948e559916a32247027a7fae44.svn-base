//
//  HeartRateDataManager.h
//  Muse
//
//  Created by Ken.Jiang on 7/7/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBManager+HeartRate.h"

@protocol HeartRateDataManagerDelegate <NSObject>

@optional
/**
 *  通知已获取到数据（界面可刷新）
 */
- (void)dataManagerDidFecthDatas;

@end

@interface HeartRateDataManager : NSObject

@property (weak, nonatomic) id<HeartRateDataManagerDelegate> delegate;

+ (NSString *)alertHeartRate;

+ (void)saveAlertHeartRate:(NSString *)heartRate;

- (void)addANewHeartRate:(NSUInteger)heartRate isAuto:(BOOL)isAuto;

- (NSDictionary<NSString *, NSString *> *)heartRateRecordLastWithOffset:(NSUInteger)offset;

- (NSArray<HeartRateData *> *)rateDataForYear:(NSInteger)year month:(NSInteger)month;

@end
