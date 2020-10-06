//
//  GetFriendListHealthDataRequest.m
//  Muse
//
//  Created by paycloud110 on 16/7/15.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "GetFriendListHealthDataRequest.h"

@implementation GetFriendListHealthDataRequest

- (NSString *)requestUrl {
    return @"/friend/getFriendsData";
}

- (id)requestArgument {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    return [self addTokenToRequestArgument:parameters];
}
/** 获取亲友列表健康数据请求 */
+ (void)startWithCompletionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock failure:(CompletionFailBlock)completionFailBlock {
    [[self alloc] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
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
