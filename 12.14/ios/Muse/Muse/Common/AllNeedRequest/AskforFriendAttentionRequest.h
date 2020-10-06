//
//  AskforFriendAttentionRequest.h
//  Muse
//
//  Created by paycloud110 on 16/7/15.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface AskforFriendAttentionRequest : MSRequest

/**
 *  申请的电话号码字符串用英文逗号分开 18688555123,18688977123,18688865123
 */
@property (strong, nonatomic) NSString *phones;

/**
 *  对方的名称备注 取通讯录名称 个数和号码对应 多个英文逗号分隔
 */
@property (strong, nonatomic) NSString *remarks;

/**
 *  申请亲友关注请求
 *
 *  @param phones                 申请的电话号码字符串用英文逗号分开 18688555123,18688977123,18688865123
 *  @param remarks                对方的名称备注 取通讯录名称 个数和号码对应 多个英文逗号分隔
 *  @param completionSuccessBlock 请求成功回调
 *  @param completionFailBlock    请求失败回调
 */
+ (void)startRequestWithPhones:(NSString *)phones
                       remarks:(NSString *)remarks
        completionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock
                       failure:(CompletionFailBlock)completionFailBlock;

@end
