//
//  MSUploadSleepDataRequest.m
//  Muse
//
//  Created by Ken.Jiang on 27/7/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "MSUploadSleepDataRequest.h"

@implementation MSUploadSleepDataRequest

- (instancetype)initWithDatas:(NSArray<NSDictionary<NSString *, NSString *> *> *)datas {
    if (self = [super init]) {
        _datas = datas;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return @"/sleep/create";
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
