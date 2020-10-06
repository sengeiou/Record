//
//  ChartBarLayer.h
//  Chart
//
//  Created by Ken.Jiang on 20/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIColor.h>

@interface ChartBarLayer : CALayer

@property (assign, nonatomic) NSInteger tag;

/**
 *  柱宽度，默认2
 */
@property (assign, nonatomic) CGFloat barWidth;

@property (assign, nonatomic) NSUInteger numberOfBars;
@property (assign, nonatomic) CGColorRef barColor;

@property (assign, nonatomic) CGFloat minValue;
@property (assign, nonatomic) CGFloat maxValue;

/**
 *  setBarValue:atIndex:传入的值超过这个值，超出的部分可以显示不同颜色
 */
@property (assign, nonatomic) CGFloat extraValue;
@property (assign, nonatomic) CGColorRef extraBarColor;

- (void)setBarValue:(float)value atIndex:(NSInteger)index;

@end
