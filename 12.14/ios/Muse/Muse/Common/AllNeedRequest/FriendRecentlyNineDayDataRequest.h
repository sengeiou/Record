//
//  FriendRecentlyNineDayDataRequest.h
//  Muse
//
//  Created by paycloud110 on 16/7/15.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface FriendRecentlyNineDayDataRequest : MSRequest

@property (nonatomic, strong) NSString *userID;

/** 亲友最近九天的数据请求 */
+ (void)startWithUserID:(NSString *)userID completionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock failure:(CompletionFailBlock)completionFailBlock;

@end
