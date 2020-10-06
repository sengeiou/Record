//
//  DoubleProgressView.h
//  Muse
//
//  Created by jiangqin on 16/4/17.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleProgressView : UIView

/**
 *  外部进度条颜色，默认[UIColor colorWithRed:0.99f green:0.95f blue:0.74f alpha:1]
 */
@property (strong, nonatomic) CALayer *outerImageLayer;
@property (strong, nonatomic) UIColor *outerColor;
@property (assign, nonatomic) float outerProgress;

- (void)setOuterProgress:(float)outerProgress animated:(BOOL)animated;

/**
 *  内部进度条颜色，默认RGB(65, 167, 89)
 */
@property (strong, nonatomic) UIColor *innerColor;

@property (assign, nonatomic) float innerProgress;

/**
 *  进度缩紧，默认4
 */
@property (assign, nonatomic) CGFloat progressInsert;

/**
 *  outer 与 inner 的间隔，默认15
 */
@property (assign, nonatomic) CGFloat progressMargin;

@end
