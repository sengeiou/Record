//
//  MSRequestVerificationCode.m
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequestVerificationCode.h"

@implementation MSRequestVerificationCode

- (instancetype)initWithPhone:(NSString *)phone {
    if (self = [super init]) {
        _phone = phone;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return @"/user/sendVerifyPhoneCode";
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    if (!_phone) {
        return nil;
    }
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"phone"] = _phone;
    
    return args;
}

@end
