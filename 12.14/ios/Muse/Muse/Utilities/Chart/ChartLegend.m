//
//  ChartLegend.m
//  Chart
//
//  Created by Ken.Jiang on 19/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import "ChartLegend.h"

@implementation ChartLegend

+ (instancetype)legendWithName:(NSString *)name color:(UIColor *)color nameColor:(UIColor *)nameColor {
    ChartLegend *legend = [[self alloc] init];
    legend.name = name;
    legend.nameColor = nameColor;
    legend.color = color;
    
    return legend;
}

@end
