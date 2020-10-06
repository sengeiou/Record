//
//  MSRequestRefreshToken.m
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequestRefreshToken.h"

@implementation MSRequestRefreshToken

- (instancetype)initWithPhone:(NSString *)phone {
    if (self = [super init]) {
        _phone = phone;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (NSString *)requestUrl {
    
    return @"/user/refreshToken";
}

- (id)requestArgument {
    
    if (!_phone) {
        return nil;
    }
    
    return @{@"phone":_phone, @"current_os":@"ios"};
}

@end
