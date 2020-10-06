//
//  GetUserFriendListRequest.m
//  Muse
//
//  Created by paycloud110 on 16/7/12.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "GetUserFriendListRequest.h"

@implementation GetUserFriendListRequest

- (NSString *)requestUrl
{
    return @"/friend/list";
}

- (id)requestArgument {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    return [self addTokenToRequestArgument:parameters];
}

/** 获取亲友列表请求 */
+ (void)startWithCompletionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock failure:(CompletionFailBlock)completionFailBlock
{
    [[self alloc] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if (MSRequestIsSuccess(responseObject)) {
            if (completionSuccessBlock) {
                completionSuccessBlock(responseObject);
            }
        } else if (completionFailBlock) {
            completionFailBlock(responseObject);
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
