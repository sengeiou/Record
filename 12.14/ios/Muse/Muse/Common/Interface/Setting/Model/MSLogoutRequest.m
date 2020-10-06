//
//  MSLogoutRequest.m
//  Muse
//
//  Created by Ken.Jiang on 16/7/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSLogoutRequest.h"

@implementation MSLogoutRequest

- (NSString *)requestUrl {
    return @"/user/logout";
}

- (id)requestArgument {
    return [self addTokenToRequestArgument:[NSMutableDictionary dictionary]];
}

@end
