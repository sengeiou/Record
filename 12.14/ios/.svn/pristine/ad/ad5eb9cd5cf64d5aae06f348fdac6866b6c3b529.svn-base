//
//  SOSRequest.h
//  Muse
//
//  Created by Ken.Jiang on 16/7/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface SOSRequest : MSRequest

@property (strong, nonatomic) NSString *phones;

/**
 *  发送短信的位置信息
 */
@property (strong, nonatomic) NSString *area;

/**
 *  发送短信的其他文字信息
 */
@property (strong, nonatomic) NSString *message;

/**
 *  SOSRequest 初始化，phones用英文逗号分隔的手机号，不能为空
 *
 *  @param phones phones用英文逗号分隔的手机号
 *
 *  @return SOSRequest
 */
- (instancetype)initWithPhones:(NSString *)phones;

@end
