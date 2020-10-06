//
//  circleView.h
//  Muse
//
//  Created by apple on 16/5/8.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface circleView : UIView {
    CAShapeLayer *circleLayer;
    CAShapeLayer *bgCircleLayer;
    CGFloat radius;
    CGPoint center;
    double progress;
    BOOL animated;
    CGFloat radian;
    
    CALayer *_outerImageLayer;
}

@property (strong, nonatomic) UIColor *progressColor;
@property (strong, nonatomic) UIColor *backTrackColor;

- (void)setProgress:(double)value animated:(BOOL)animate;

@end
