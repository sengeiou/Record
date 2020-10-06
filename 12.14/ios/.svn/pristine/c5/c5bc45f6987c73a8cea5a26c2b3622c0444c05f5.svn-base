//
//  SendMorseRequest.h
//  Muse
//
//  Created by HaiQuan on 2016/11/28.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface SendMorseRequest : MSRequest

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *phones;
@property (strong, nonatomic) NSString *type;

/** 发送摩斯到MUSE用户 */
+ (void)startWithUserID:(NSString *)phones sendMessage:(NSString *)message type:(NSString *)type completionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock failure:(CompletionFailBlock)completionFailBlock;


@end
