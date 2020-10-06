//
//  MSHeartAlertRequest.m
//  Muse
//
//  Created by HaiQuan on 2016/12/9.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSHeartAlertRequest.h"

@implementation MSHeartAlertRequest

- (instancetype)initWithMessage:(NSString *)msg {
    if (self = [super init]) {
        _message = msg;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return @"/tool/exced";
}

- (id)requestArgument {
    if (!_message) {
        return nil;
    }
    
    return [self addTokenToRequestArgument:[@{@"msg":_message} mutableCopy]];
}


@end
