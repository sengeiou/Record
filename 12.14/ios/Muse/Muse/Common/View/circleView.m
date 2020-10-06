//
//  circleView.m
//  Muse
//
//  Created by apple on 16/5/8.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "circleView.h"

#define ChartWidth 4

@implementation circleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.layer.masksToBounds = YES;
    
    _outerImageLayer = [CALayer layer];
    _outerImageLayer.contentsScale = [UIScreen mainScreen].scale;

//     _outerImageLayer.contents = (id)[[UIImage imageNamed:@"circle_disk_yellow"] CGImage];
    
   
    [self.layer addSublayer:_outerImageLayer];
    
    bgCircleLayer = [CAShapeLayer layer];
    bgCircleLayer.fillColor = nil;
    bgCircleLayer.lineWidth = ChartWidth;
    [self.layer addSublayer:bgCircleLayer];
    
   
    _progressColor = [UIColor colorWithRed:0.99f green:0.95f blue:0.74f alpha:1];
    circleLayer = [CAShapeLayer layer];
    circleLayer.fillColor = nil;
    circleLayer.strokeColor = _progressColor.CGColor;
    circleLayer.lineWidth = ChartWidth;
//    [self.layer addSublayer:circleLayer];
    _outerImageLayer.mask = circleLayer;
}

#pragma mark - Setter

- (void)setProgressColor:(UIColor *)progressColor {
    if ([_progressColor isEqual:progressColor]) {
        return;
    }
    
    _progressColor = progressColor;
    circleLayer.strokeColor = _progressColor.CGColor;
}

- (void)setBackTrackColor:(UIColor *)backTrackColor {
    if ([_backTrackColor isEqual:backTrackColor]) {
        return;
    }
    
    _backTrackColor = backTrackColor;
    bgCircleLayer.strokeColor = _backTrackColor.CGColor;
}

#pragma mark - public

- (void)setProgress:(double)value animated:(BOOL)animate {
    progress = value;
    animated = animate;
    radian = value * 2* M_PI;
    
    [self updateCircleLayer];
}

#pragma mark - private

- (void)updateCircleLayer {
    UIBezierPath *path  = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:radius startAngle:-M_PI/2 endAngle:-M_PI/2 + radian clockwise:YES];
    circleLayer.path = path.CGPath;
    
    if (animated) {
        [self circleAnimation:circleLayer];
    }
}

#pragma mark ----animations

- (void)circleAnimation:(CALayer*)layer {
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basic.duration = 1;
    basic.fromValue = @0;
    basic.toValue = @1;
    [layer addAnimation:basic forKey:@"StrokeEndKey"];
}

#pragma mark - Layout

- (void)layoutSubviews {
    radius = self.bounds.size.width/2 - ChartWidth;
    center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    bgCircleLayer.path = path.CGPath;
    
    _outerImageLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    _outerImageLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    [self updateCircleLayer];
}

@end
