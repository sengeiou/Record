//
//  MSSleepMonthDataRequest.m
//  Muse
//
//  Created by Ken.Jiang on 16/7/24.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSSleepMonthDataRequest.h"

@implementation MSSleepMonthDataRequest

- (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month {
    if (self = [super init]) {
        _dateMonth = [NSString stringWithFormat:@"%04ld-%02ld", (long)year, (long)month];
    }
    
    return self;
}

- (NSString *)requestUrl {
    return @"/sleep/getSleepByMonth";
}

- (id)requestArgument {
    if (!_dateMonth) {
        return nil;
    }
    
    return [self addTokenToRequestArgument:[@{@"month":_dateMonth} mutableCopy]];
}

@end
