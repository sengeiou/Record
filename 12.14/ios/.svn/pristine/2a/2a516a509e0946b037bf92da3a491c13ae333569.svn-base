//
//  MSGetMyHeartRateRequest.m
//  Muse
//
//  Created by HaiQuan on 2016/12/7.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSGetMyHeartRateRequest.h"

@implementation MSGetMyHeartRateRequest

- (instancetype)init {
    if (self = [super init]) {

    }
    
    return self;
}

- (NSString *)requestUrl {
    
    return @"/heartRate/getLast3Day";
}

- (id)requestArgument {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    return [self addTokenToRequestArgument:parameters];
}

@end
