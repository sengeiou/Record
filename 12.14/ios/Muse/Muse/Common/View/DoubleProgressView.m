//
//  DoubleProgressView.m
//  Muse
//
//  Created by jiangqin on 16/4/17.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "DoubleProgressView.h"
#import "CGUtilities.h"
#import "UIColor+FastKit.h"
#import "photo.h"

@interface DoubleProgressView () {
    //CALayer *_outerImageLayer; //外环形图片
    UIImageView *_outerThumb;
    CAShapeLayer *_outerProgressLayer;
    CGFloat _outerRadius;
//    UIImageView *_outerBeginThumb;
    
    //MARK: 内环形渐变条实现
    UIImageView *_innerThumb;
    CAShapeLayer *_innerProgressLayer;
    CGFloat _innerRadius;
    
    CGPoint _center;
    CGFloat _outerLineWidth;
    //开始
    CGFloat _startDegree;
}

@end

@implementation DoubleProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
    _outerLineWidth = 2;
    _startDegree = -90;
    _progressInsert = 4;
    _progressMargin = 15;
    
//    _outerImageLayer = [CALayer layer];
//    
//    _outerImageLayer.contentsScale = [UIScreen mainScreen].scale;
   
  
    
//    _outerImageLayer.contents = (id)[[UIImage imageNamed:@"circle_disk_yellow"] CGImage];
    

//    [self.layer addSublayer:_outerImageLayer];
    
    _outerProgressLayer = [CAShapeLayer layer];
    _outerProgressLayer.lineCap = kCALineCapRound;
    _outerProgressLayer.fillColor = nil;
//    _outerImageLayer.mask = _outerProgressLayer;
    [self.layer addSublayer:_outerProgressLayer];

    
    _outerThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light_disk_yellow"]];
    [self addSubview:_outerThumb];
    [self setOuterColor:[UIColor colorWithRed:0.99f green:0.95f blue:0.74f alpha:1]];
    _outerThumb.contentMode = UIViewContentModeScaleAspectFit;
    
//    _outerBeginThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot_disk_yellow"]];
//    [self addSubview:_outerBeginThumb];
//    _outerBeginThumb.contentMode = UIViewContentModeScaleAspectFit;
    
    _innerProgressLayer = [CAShapeLayer layer];
    _innerProgressLayer.lineCap = kCALineCapRound;
    _innerProgressLayer.fillColor = nil;
    [self.layer addSublayer:_innerProgressLayer];
    
    _innerThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light_disk_green"]];
    [self addSubview:_innerThumb];
    [self setInnerColor:RGB(65, 167, 89)];
    
    _outerThumb.hidden = YES;
    _innerProgressLayer.hidden = YES;
    _innerThumb.hidden = YES;
    
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Privates

- (void)addAnimationToLayer:(CALayer *)layer withPath:(CGPathRef)path {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];

    animation.duration = 1;
    animation.fromValue = @0;
    animation.toValue = @1;
    [layer addAnimation:animation forKey:@"StrokeAnimation"];
}

- (void)updateOuterProgressAnimated:(BOOL)animated {
    
    CGFloat degree = _outerProgress * 360;
    
    CGFloat angle = DegreesToRadians(degree + _startDegree);
    
    _outerProgressLayer.lineWidth = _outerLineWidth;
    
    CGPoint outerArcCenter = CGPointMake(_center.x - _progressInsert,
                                         _center.y - _progressInsert);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:outerArcCenter
                                                        radius:_outerRadius
                                                    startAngle:DegreesToRadians(_startDegree)
                                                      endAngle:angle
                                                    clockwise:YES];
    //终点处理
    path.lineCapStyle = kCGLineCapRound;
    
    _outerProgressLayer.path = path.CGPath;
    
    _outerThumb.transform = CGAffineTransformMakeRotation(DegreesToRadians(degree));
    
//    _outerBeginThumb.transform = CGAffineTransformMakeRotation(DegreesToRadians(1));
    
//    if (animated) {
//        [self addAnimationToLayer:_outerProgressLayer withPath:path.CGPath];
//    }
}

- (void)updateInnerProgress {
    
    CGFloat degree = _innerProgress * 360;
    
    CGFloat angle = DegreesToRadians(degree + _startDegree);
    
    _innerProgressLayer.lineWidth = _outerLineWidth;
    
    CGPoint innerArcCenter = CGPointMake(_center.x - _progressInsert - _progressMargin,
                                         _center.y - _progressInsert - _progressMargin);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:innerArcCenter
                                                        radius:_innerRadius
                                                    startAngle:DegreesToRadians(_startDegree)
                                                      endAngle:angle
                                                     clockwise:YES];
    
    path.lineWidth = _outerLineWidth;
    
    _innerProgressLayer.path = path.CGPath;
    
    _innerThumb.transform = CGAffineTransformMakeRotation(DegreesToRadians(degree));
}

#pragma mark - Setter & Getter

- (void)setOuterColor:(UIColor *)outerColor {
    
    if ([_outerColor isEqual:outerColor]) {
        return;
    }
    
    _outerColor = outerColor;
    _outerProgressLayer.strokeColor = outerColor.CGColor;
}
//开始画圆入口
- (void)setOuterProgress:(float)outerProgress animated:(BOOL)animated {
  //  MSLog(@"%f",outerProgress);
    if (_outerProgress == outerProgress) {
        return;
    }
    
    if (outerProgress < 0) {
        outerProgress = 0;
    } else if (outerProgress > 1.02) {
        outerProgress = 1;
    }
    
    _outerProgress = outerProgress;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (outerProgress == 0) {
            _outerProgressLayer.hidden = YES;
            _outerThumb.hidden = YES;
        } else {
            _outerProgressLayer.hidden = NO;
            if (outerProgress == 1 || outerProgress == 0) {
                _outerThumb.hidden = YES;
            } else {
                _outerThumb.hidden = NO;
            }
        }
        [self updateOuterProgressAnimated:animated];
    });
}

- (void)setOuterProgress:(float)outerProgress {
    // 心率测试完毕动画
    [self setOuterProgress:outerProgress animated:YES];
}

- (void)setInnerColor:(UIColor *)innerColor {
    if ([_innerColor isEqual:innerColor]) {
        return;
    }
    
    _innerColor = innerColor;
    _innerProgressLayer.strokeColor = _innerColor.CGColor;
}

- (void)setInnerProgress:(float)innerProgress {
    
    if (_innerProgress == innerProgress) {
        return;
    }
    
    if (innerProgress < 0) {
        innerProgress = 0;
    } else if (innerProgress > 1) {
        innerProgress = 1;
    }
    
    _innerProgress = innerProgress;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (innerProgress == 0) {
            _innerProgressLayer.hidden = YES;
            _innerThumb.hidden = YES;
        } else {
            _innerProgressLayer.hidden = NO;
            if (innerProgress == 1 || innerProgress == 0) {
                _innerThumb.hidden = YES;
            } else {
                _innerThumb.hidden = NO;
            }
        }
        
        [self updateInnerProgress];
    });
}

#pragma mark - Layout

- (void)layoutSubviews {
    
//    CGFloat width = self.bounds.size.width;
//    CGFloat height = self.bounds.size.height;
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    
    _center = CGPointMake(width/2, height/2);
    CGFloat radius = MIN(width, height)/2;
    
    _outerRadius = radius - _progressInsert;
    
    CGRect frame = CGRectMake(0, 0, _outerRadius * 2, _outerRadius * 2);
    _outerProgressLayer.frame = frame;
    _outerProgressLayer.position = _center;
    
    _outerThumb.transform = CGAffineTransformIdentity;
//    if (kScreenWidth == 414) {
//        _outerThumb.frame = CGRectMake(0, 0, _innerRadius * 2+30, _innerRadius * 2+30); //30
//    } else {
        _outerThumb.frame = CGRectMake(0, 0, _outerRadius * 2+10, _outerRadius * 2+10); //30
//    }
    _outerThumb.center = _center;
    
//    _outerBeginThumb.transform = CGAffineTransformMakeRotation(DegreesToRadians(50));
    
//    _outerBeginThumb.transform = CGAffineTransformIdentity;
//    _outerBeginThumb.frame = CGRectMake(0, 0, _innerRadius * 2+44, _innerRadius * 2+44);;
//    _outerBeginThumb.center = _center;
    
    _innerRadius = _outerRadius - _progressMargin;
    frame = CGRectMake(0, 0, _innerRadius * 2, _innerRadius * 2);
    _innerProgressLayer.frame = frame;
    _innerProgressLayer.position = _center;
    
    _innerThumb.transform = CGAffineTransformIdentity;
    
    if (kScreenWidth == 414) {
        _innerThumb.frame = CGRectMake(0, 0, _innerRadius * 2+47, _innerRadius * 2+47); //50
    } else {
        _innerThumb.frame = CGRectMake(0, 0, _innerRadius * 2+35, _innerRadius * 2+35); //50
    }
    _innerThumb.center = _center;
//    ZHLog10(@"%f %f",self.frame.size.width,self.frame.size.height);
    [self updateOuterProgressAnimated:YES];
    [self updateInnerProgress];
}

@end
