//
//  MSRequestFindContacts.m
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequestFindContacts.h"

@implementation MSRequestFindContacts

- (instancetype)initWithPhones:(NSString *)phones {
    if (self = [super init]) {
        _phones = phones;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return @"/user/FindUserByPhones";
}

- (id)requestArgument {
    if (!_phones) {
        return nil;
    }
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"phones"] = _phones;
    
    return [self addTokenToRequestArgument:args];
}

@end
