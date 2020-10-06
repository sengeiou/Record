//
//  ClockManager.m
//  Muse
//
//  Created by Ken.Jiang on 23/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "ClockManager.h"
#import "NSFileManager+FastKit.h"
#import "NSDate+FastKit.h"

@implementation ClockData

+ (NSString *)weekdayForRepeatDay:(ClockRepeatDay)repeatDay {
    
    NSString *weekday;
    switch (repeatDay) {
        case ClockRepeatMonday:
            weekday = @"周一";
            break;
        case ClockRepeatTuesday:
            weekday = @"周二";
            break;
        case ClockRepeatWednesday:
            weekday = @"周三";
            break;
        case ClockRepeatThursday:
            weekday = @"周四";
            break;
        case ClockRepeatFriday:
            weekday = @"周五";
            break;
        case ClockRepeatSaturday:
            weekday = @"周六";
            break;
        case ClockRepeatSunday:
            weekday = @"周日";
            break;
            
        default:
            weekday = @"";
            break;
    }
    
    return weekday;
}

+ (NSString *)descriptionForRepeatDay:(ClockRepeatDay)repeatDay {
    NSString *desc = nil;
    if (repeatDay == ClockRepeatEveryday) {
        desc = @"每天";
    } else if (repeatDay != ClockRepeatOnce) {
        NSMutableString *str = [NSMutableString string];
        
        for (int i = 0; i < 7; i++) {
            ClockRepeatDay day = 1 << i;
            if (repeatDay & day) {
                [str appendFormat:@"%@ ", [self weekdayForRepeatDay:day]];
                
                MSLog(@"%@",str);
            }
        }
        
        desc = str;
    }
    
    return desc;
}

+ (ClockData *)clockData {
    ClockData *data = [[ClockData alloc] init];
    data.time = [[NSDate date] stringWithFormat:@"HH:mm"];
    data.repeatDay = ClockRepeatOnce;
    data.enabled = YES;
    
    return data;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:@(self.repeatDay) forKey:@"repeatDay"];
    [aCoder encodeObject:@(self.enabled) forKey:@"enable"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.repeatDay = [[aDecoder decodeObjectForKey:@"repeatDay"] unsignedIntegerValue];
        self.enabled = [[aDecoder decodeObjectForKey:@"enable"] boolValue];
    }
    
    return self;
}

#pragma mark - Publics

- (void)repeatDayAppend:(ClockRepeatDay)repeatDay {
    if (repeatDay == ClockRepeatOnce || repeatDay == ClockRepeatEveryday) {
        _repeatDay = repeatDay;
    } else {
        _repeatDay |= repeatDay;
    }
}

- (void)repeatDaySubtract:(ClockRepeatDay)repeatDay {
    _repeatDay &= (~repeatDay);
}

- (NSString *)repeatDayDescription {
    return [ClockData descriptionForRepeatDay:_repeatDay];
}

@end

@implementation ClockManager

+ (ClockManager *)sharedManager {
    static ClockManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ClockManager alloc] init];
    });
    
    return _manager;
}

- (void)dealloc {
    [self saveSettings];
}

#pragma mark - Getter

- (NSMutableArray<ClockData *> *)clocks {
    if (!_clocks) {
        NSArray *clocks = [NSFileManager loadArrayFromPath:FSDirectoryTypeDocuments withFilename:@"ClockSettings"];
        if (clocks) {
            _clocks = [NSMutableArray arrayWithArray:clocks];
        } else {
            _clocks = [NSMutableArray array];
        }
    }
    
    return _clocks;
}

#pragma mark - Publics

- (void)saveSettings {
    
    [NSFileManager saveArrayToPath:FSDirectoryTypeDocuments withFilename:@"ClockSettings" array:_clocks];
}


@end
