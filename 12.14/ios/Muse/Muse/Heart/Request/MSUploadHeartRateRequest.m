//
//  MSUploadHeartRateRequest.m
//  Muse
//
//  Created by 朱祥巍 on 16/7/9.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSUploadHeartRateRequest.h"

@implementation MSUploadHeartRateRequest

- (instancetype)initWithDatas:(NSArray<NSDictionary<NSString *, NSString *> *> *)datas {
    
    if (self = [super init]) {
        _datas = datas;
    }
    
    return self;
}

- (NSString *)requestUrl {
    
    return @"/heartRate/create";
}

- (id)requestArgument {
    
    if (!_datas) {
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_datas options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return [self addTokenToRequestArgument:[@{@"data":json} mutableCopy]];
}

@end
