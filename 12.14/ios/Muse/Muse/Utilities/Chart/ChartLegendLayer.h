//
//  ChartLegendLayer.h
//  Chart
//
//  Created by Ken.Jiang on 20/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ChartLegend.h"

@interface ChartLegendLayer : CALayer

@property (strong, nonatomic) NSArray<ChartLegend *> *legends;

/**
 *  标签字体大小，默认12
 */
@property (assign, nonatomic) CGFloat legendFontSize;

@end
