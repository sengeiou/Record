//
//  ClockManager.h
//  Muse
//
//  Created by Ken.Jiang on 23/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, ClockRepeatDay) {
    ClockRepeatOnce = 0,
    ClockRepeatMonday = 1 << 0,
    ClockRepeatTuesday = 1 << 1,
    ClockRepeatWednesday = 1 << 2,
    ClockRepeatThursday = 1 << 3,
    ClockRepeatFriday = 1 << 4,
    ClockRepeatSaturday = 1 << 5,
    ClockRepeatSunday = 1 << 6,
    ClockRepeatEveryday = ClockRepeatMonday | ClockRepeatTuesday | ClockRepeatWednesday | ClockRepeatThursday |
                          ClockRepeatFriday | ClockRepeatSaturday | ClockRepeatSunday,
};

@interface ClockData : NSObject <NSCoding>

/**
 *  闹铃时间，格式HH:mm
 */
@property (strong, nonatomic) NSString *time;

/**
 *  设置新值使用本属性（set方法），更改repeatDay使用repeatDayAppend: 或者 repeatDaySubtract:
 */
@property (nonatomic) ClockRepeatDay repeatDay;

@property (nonatomic) BOOL enabled;

//@property (nonatomic) NSCalendarUnit repeatInterval;      // 0 means don't repeat

+ (NSString *)descriptionForRepeatDay:(ClockRepeatDay)repeatDay;

+ (ClockData *)clockData;

/**
 *  更改repeatDay
 *
 *  @param repeatDay 添加新的ClockRepeatDay
 */
- (void)repeatDayAppend:(ClockRepeatDay)repeatDay;

/**
 *  更改repeatDay
 *
 *  @param repeatDay 移除ClockRepeatDay
 */
- (void)repeatDaySubtract:(ClockRepeatDay)repeatDay;

- (NSString *)repeatDayDescription;

@end

@interface ClockManager : NSObject

@property (nonatomic, strong) NSMutableArray<ClockData *> *clocks;

+ (ClockManager *)sharedManager;

- (void)saveSettings;

@end
