//
//  FriendList.m
//  Muse
//
//  Created by paycloud110 on 16/7/15.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "FriendList.h"
#import "MJExtension.h"

@implementation FriendList

- (instancetype)init {
    if (self = [super init]) {
        // 设置字典转模型特定属性的转换
        [FriendList setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id"};
        }];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        //        self.initial = [aDecoder decodeObjectForKey:@"initial"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        
        
    }
    return self;
}

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    FriendList *object = [[FriendList allocWithZone:zone] init];
    return object;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    //   [aCoder encodeObject:_initial forKey:@"initial"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:_phone forKey:@"phone"];
}

@end
