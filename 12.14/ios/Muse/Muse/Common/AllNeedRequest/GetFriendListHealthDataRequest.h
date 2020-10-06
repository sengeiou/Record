//
//  GetFriendListHealthDataRequest.h
//  Muse
//
//  Created by paycloud110 on 16/7/15.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface GetFriendListHealthDataRequest : MSRequest

/** 获取亲友列表健康数据请求 */
+ (void)startWithCompletionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock failure:(CompletionFailBlock)completionFailBlock;

@end
