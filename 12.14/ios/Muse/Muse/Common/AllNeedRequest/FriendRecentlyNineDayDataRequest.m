//
//  FriendRecentlyNineDayDataRequest.m
//  Muse
//
//  Created by paycloud110 on 16/7/15.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "FriendRecentlyNineDayDataRequest.h"

@implementation FriendRecentlyNineDayDataRequest


- (NSString *)requestUrl {
    
    return @"/friend/friendDaysData";
}

- (id)requestArgument {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]
                                       initWithDictionary:@{@"user_id":_userID}];
    return [self addTokenToRequestArgument:parameters];
}

/** 亲友最近九天的数据请求 */
+ (void)startWithUserID:(NSString *)userID completionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock failure:(CompletionFailBlock)completionFailBlock {
    
    if (!userID) {
        if (completionFailBlock) {
            completionFailBlock(nil);
        }
    }
    
    FriendRecentlyNineDayDataRequest *req = [[FriendRecentlyNineDayDataRequest alloc] init];
    req.userID = userID;
    
    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if (MSRequestIsSuccess(responseData)) {
            if (completionSuccessBlock) {
                completionSuccessBlock(responseData);
            }
        } else if (completionFailBlock) {
            completionFailBlock(responseData);
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        if (completionFailBlock) {
            if (request.responseData) {
                NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
                completionFailBlock(responseData);
            }else {
                completionFailBlock(@{@"message":@"数据为空"});
            }
        }
    }];
}

@end
