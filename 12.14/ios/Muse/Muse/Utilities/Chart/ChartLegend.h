//
//  ChartLegend.h
//  Chart
//
//  Created by Ken.Jiang on 19/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>

/**
 *  Chart Legend Data Model
 */
@interface ChartLegend : NSObject

/**
 *  指示图名称
 */
@property (strong, nonatomic) NSString *name;

/**
 *  指示图名称颜色
 */
@property (strong, nonatomic) UIColor *nameColor;

/**
 *  指示图颜色
 */
@property (strong, nonatomic) UIColor *color;

+ (instancetype)legendWithName:(NSString *)name color:(UIColor *)color nameColor:(UIColor *)nameColor;

@end
