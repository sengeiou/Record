//
//  MSRequestLogin.m
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequestLogin.h"
#import "MuseUser.h"

@implementation MSRequestLogin

- (instancetype)initWithPhone:(NSString *)phone {
    if (self = [super init]) {
        _phone = phone;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return @"/user/mobLogin";
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
    
    
//    NSString *zoneStr = [[[[NSUserDefaults standardUserDefaults] valueForKey:USERAREACODE] componentsSeparatedByString:@"+"] lastObject];
    
    NSString *zoneStr;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:USERAREACODE]) {
        zoneStr = [[[[NSUserDefaults standardUserDefaults] valueForKey:USERAREACODE] componentsSeparatedByString:@"+"] lastObject];
        
    } else {
        zoneStr = @"86";
    }

    args[@"area_code"] = zoneStr;
    
    args[@"device_token"] = _device_token ? _device_token : @"21342134234";
    
//    args[@"device_token"] = @"21342134234";

    
    args[@"current_os"] = @"ios";
    
    
    return args;
}

@end
