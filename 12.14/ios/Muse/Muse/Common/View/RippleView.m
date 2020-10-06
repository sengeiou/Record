//
//  RippleView.m
//  Muse
//
//  Created by jiangqin on 16/4/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "RippleView.h"

@interface RippleView () {
    CALayer *_rippleLayer1;
//    CALayer *_rippleLayer2;
}

@end

@implementation RippleView

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

#pragma mark - Privates

- (CALayer *)rippleLayer {
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    
    layer.contents = (id)[_rippleImage CGImage];
    
    return layer;
}

- (void)commonInit {
    _rippleImage = [UIImage imageNamed:@"light_follower_heart"];
    
    _rippleLayer1 = [self rippleLayer];
//    _rippleLayer2 = [self rippleLayer];
}

- (CAAnimationGroup *)rippleAnimation {
    
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.duration = 2;
    pulse.fromValue = @0.2f;
    pulse.toValue = @1.5f;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0.1f;
    alphaAnimation.duration = 2;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[pulse, alphaAnimation];
    animation.duration = 2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.repeatCount = HUGE_VALL;
    
    return animation;
}

//- (void)startNextRippleAnimation {
//    _rippleLayer2.hidden = NO;
//    [_rippleLayer2 removeAllAnimations];
//    [_rippleLayer2 addAnimation:[self rippleAnimation] forKey:@"rippleAnimations"];
//}

#pragma mark - Setter

- (void)setRippleImage:(UIImage *)rippleImage {
    if ([_rippleImage isEqual:rippleImage]) {
        return;
    }
    
    _rippleImage = rippleImage;
    
    [self stop];
    [_rippleLayer1 removeFromSuperlayer];
    _rippleLayer1 = nil;
//    [_rippleLayer2 removeFromSuperlayer];
//    _rippleLayer2 = nil;
    
    _rippleLayer1 = [self rippleLayer];
//    _rippleLayer2 = [self rippleLayer];
}

#pragma mark - Public

- (void)startRipple {
    _rippleLayer1.hidden = NO;
    [_rippleLayer1 removeAllAnimations];
    [_rippleLayer1 addAnimation:[self rippleAnimation] forKey:@"rippleAnimations"];
    
//    [self performSelector:@selector(startNextRippleAnimation) withObject:nil afterDelay:1];
}

- (void)stop {
    [_rippleLayer1 removeAllAnimations];
//    [_rippleLayer2 removeAllAnimations];
    
    _rippleLayer1.hidden = YES;
//    _rippleLayer2.hidden = YES;
}

@end
