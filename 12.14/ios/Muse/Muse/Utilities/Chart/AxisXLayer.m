//
//  AxisXLayer.m
//  Chart
//
//  Created by Ken.Jiang on 19/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import "AxisXLayer.h"

@interface AxisXLayer () {
    CGFloat _axisTopInset;
}

@end

@implementation AxisXLayer

- (instancetype)init {
    if (self = [super init]) {
        [self setDrawAxis:NO];
        
        _axisTopInset = 10;
        _labelMargin = 8;
    }
    
    return self;
}

#pragma mark - Layout

- (void)layoutSublayers {
    CGFloat width = self.bounds.size.width;
    
    _axisLayer.frame = CGRectMake(0, _axisTopInset, width, 1);
    for (int i = 0; i < _keyPoints.count; i++) {
        CGFloat progress = [_keyPoints[i] floatValue];
        CALayer *point = _pointLayers[i];
        point.position = CGPointMake(width * progress, _axisTopInset);
        
        CATextLayer *label = _labelLayers[i];
        label.string = _keyLabels[i];
        label.position = CGPointMake(width * progress, _axisTopInset + _labelMargin);
    }
}


@end
