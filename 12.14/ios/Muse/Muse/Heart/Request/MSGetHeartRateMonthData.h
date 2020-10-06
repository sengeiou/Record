//
//  MSGetHeartRateMonthData.h
//  Muse
//
//  Created by 朱祥巍 on 16/7/9.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface MSGetHeartRateMonthData : MSRequest

/**
 *  月份，格式 yyyy-MM
 */
@property (strong, nonatomic) NSString *dateMonth;

- (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month;

@end
