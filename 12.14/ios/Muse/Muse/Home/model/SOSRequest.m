//
//  SOSRequest.m
//  Muse
//
//  Created by Ken.Jiang on 16/7/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SOSRequest.h"

@implementation SOSRequest

- (instancetype)initWithPhones:(NSString *)phones {
    if (self) {
        _phones = phones;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return @"/sos/index";
}

- (id)requestArgument {
    if (!_phones) {
        return nil;
    }
    
    if (!_message) {
        _message = NSLocalizedString(@"I Need Help", nil);
    }
    
    NSMutableDictionary *args = [@{@"phone_nums":_phones} mutableCopy];
    if (_area) {
       // args[@"area"] = [_message stringByAppendingString:_area];
        
        NSString *tempStr = [NSString stringWithFormat:@"，%@",_area];
        args[@"area"] = [_message stringByAppendingString:tempStr];
    
    } else {
        args[@"area"] = _message;
    }
    
    return [self addTokenToRequestArgument:args];
}

@end
