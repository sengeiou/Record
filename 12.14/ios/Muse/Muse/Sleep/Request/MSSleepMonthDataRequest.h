//
//  MSSleepMonthDataRequest.h
//  Muse
//
//  Created by Ken.Jiang on 16/7/24.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface MSSleepMonthDataRequest : MSRequest

/**
 *  月份，格式 yyyy-MM
 */
@property (strong, nonatomic) NSString *dateMonth;

- (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month;

@end
