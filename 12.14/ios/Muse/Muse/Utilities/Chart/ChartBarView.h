//
//  ChartBarView.h
//  Chart
//
//  Created by Ken.Jiang on 19/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartBar.h"
#import "ChartLegend.h"

typedef struct _ChartRange {
    float start;
    float end;
    float interval;
    NSUInteger steps;
} ChartRange;

NS_INLINE ChartRange ChartRangeMake(float start, float end, float interval, NSUInteger steps) {
    ChartRange r;
    r.start = start;
    r.end = end;
    r.interval = interval;
    r.steps = steps;
    return r;
}

@class ChartBarView;
@protocol ChartBarViewDataSource <NSObject>

- (ChartRange)rangeOfChartLineYValue:(ChartBarView *)barView;
- (NSUInteger)countOfBarsInChartBarView:(ChartBarView *)barView;

- (NSString *)chartBarView:(ChartBarView *)barView xLabelForIndex:(NSUInteger)index;
- (NSString *)chartBarView:(ChartBarView *)barView yLabelForStep:(NSUInteger)step;

@optional

- (UIColor *)xLabelColorForChartBarView:(ChartBarView *)barView;
- (UIColor *)yLabelColorForChartBarView:(ChartBarView *)barView;

- (NSArray<ChartLegend *> *)legendsForChartBarView:(ChartBarView *)barView;

@end

@interface ChartBarView : UIView

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) CGFloat barWidth;
@property (weak, nonatomic) id<ChartBarViewDataSource> dataSource;

@property (strong, readonly, nonatomic) NSArray *charts;

- (void)addChart:(ChartBar *)chart;
- (void)reloadData;

@end
