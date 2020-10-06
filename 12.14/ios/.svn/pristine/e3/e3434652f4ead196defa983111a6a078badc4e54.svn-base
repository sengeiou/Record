//
//  ChartBar.h
//  Chart
//
//  Created by Ken.Jiang on 19/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>

@class ChartBar;

@protocol ChartBarDataSource <NSObject>

- (NSUInteger)numberOfBarsInChartBar:(ChartBar *)chartBar;
- (CGFloat)chartBar:(ChartBar *)chartBar yValueForIndex:(NSInteger)index;

@optional

- (UIColor *)colorOfBarInChartBar:(ChartBar *)chartBar;

/**
 *  chartBar:yValueForIndex:传入的值超过这个值，超出的部分可以显示不同颜色
 */
- (CGFloat)extraYValueForChartBar:(ChartBar *)chartBar;

/**
 *  chartBar:yValueForIndex:传入的值超过这个值，超出的部分可显示的颜色
 */
- (UIColor *)extraColorOfBarInChartBar:(ChartBar *)chartBar;

@end

/**
 *  Chart Bar Data Model
 */
@interface ChartBar : NSObject

@property (assign, nonatomic) NSInteger tag;
@property (weak, nonatomic) id<ChartBarDataSource> dataSource;

@property (assign, readonly, nonatomic) NSUInteger numberOfBars;
@property (assign, readonly, nonatomic) UIColor *colorOfBar;
@property (assign, readonly, nonatomic) CGFloat extraYValue;
@property (assign, readonly, nonatomic) UIColor *extraColorOfBar;

@end
