//
//  MSCareRequest.m
//  Muse
//
//  Created by Ken.Jiang on 16/8/1.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSCareRequest.h"
#import "MuseUser.h"

@implementation MSCareRequest {
    NSString *_userid;
}

- (instancetype)initWithCarePersonID:(NSString *)userid {
    if (self = [super init]) {
        _userid = userid;
    }
    
    return self;
}

- (NSString *)requestUrl {
    
    return @"/care/create";
}

- (id)requestArgument {
    
    if (!_userid) {
        return nil;
    }
    
    return [self addTokenToRequestArgument:[@{@"to_id": _userid} mutableCopy]];
}

@end
