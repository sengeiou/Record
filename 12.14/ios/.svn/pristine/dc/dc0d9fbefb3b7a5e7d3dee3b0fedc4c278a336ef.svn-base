//
//  SendSecrectToFriendRequest.h
//  Muse
//
//  Created by paycloud110 on 16/7/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface SendSecrectToFriendRequest : MSRequest

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *phones;

/** 发送密语到亲友 */
+ (void)startWithUserID:(NSString *)phones sendMessage:(NSString *)message completionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock failure:(CompletionFailBlock)completionFailBlock;

@end
