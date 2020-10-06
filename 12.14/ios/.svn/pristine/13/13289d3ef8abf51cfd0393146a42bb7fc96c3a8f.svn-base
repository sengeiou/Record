//
//  ChartBar.m
//  Chart
//
//  Created by Ken.Jiang on 19/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import "ChartBar.h"

@implementation ChartBar

- (NSUInteger)numberOfBars {
    return [self.dataSource numberOfBarsInChartBar:self];
}

- (UIColor *)colorOfBar {
    if ([self.dataSource respondsToSelector:@selector(colorOfBarInChartBar:)]) {
        return [self.dataSource colorOfBarInChartBar:self];
    }
    
    return [UIColor greenColor];
}

- (CGFloat)extraYValue {
    if ([self.dataSource respondsToSelector:@selector(extraYValueForChartBar:)]) {
        return [self.dataSource extraYValueForChartBar:self];
    }
    
    return CGFLOAT_MAX;
}

- (UIColor *)extraColorOfBar {
    if ([self.dataSource respondsToSelector:@selector(extraColorOfBarInChartBar:)]) {
        return [self.dataSource extraColorOfBarInChartBar:self];
    } else if ([self.dataSource respondsToSelector:@selector(colorOfBarInChartBar:)]) {
        return [self.dataSource colorOfBarInChartBar:self];
    }
    
    return nil;
}

@end
