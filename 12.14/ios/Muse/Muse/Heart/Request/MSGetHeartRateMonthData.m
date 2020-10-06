//
//  MSGetHeartRateMonthData.m
//  Muse
//
//  Created by 朱祥巍 on 16/7/9.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSGetHeartRateMonthData.h"

@implementation MSGetHeartRateMonthData

- (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month {
    if (self = [super init]) {
        _dateMonth = [NSString stringWithFormat:@"%04ld-%02ld", (long)year, (long)month];
    }
    
    return self;
}

- (NSString *)requestUrl {
    return @"/heartRate/getRateByMonth";
}

- (id)requestArgument {
    if (!_dateMonth) {
        return nil;
    }
    
    return [self addTokenToRequestArgument:[@{@"month":_dateMonth} mutableCopy]];
}

@end
