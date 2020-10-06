//
//  SleepGraphView.h
//  Muse
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SleepGrapType) {
    SleepGrapTypeShallow = 1,
    SleepGrapTypeDeep,
    SleepGrapTypeWake,
};

@interface SleepGraphView : UIView

/**
 *  绘图所需数据数组，格式如：@[@{@"type":@(SleepGrapTypeDeep),@"period":@(5),@"time":@"5:20-5:30"}, ...]
 */
@property (nonatomic,strong) NSArray *grapArr;

@end
