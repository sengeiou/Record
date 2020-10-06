//
//  AxisLayer.m
//  Chart
//
//  Created by Ken.Jiang on 20/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import "AxisLayer.h"
#import <UIKit/UIScreen.h>

@implementation AxisLayer

- (instancetype)init {
    if (self = [super init]) {
        _drawAxis = YES;
        _drawLabels = YES;
        
        _axisColor = [UIColor whiteColor].CGColor;
        _labelsColor = _axisColor;
        
        _axisLayer = [CALayer layer];
        _axisLayer.backgroundColor = _axisColor;
        [self addSublayer:_axisLayer];
        
        _pointLayers = [NSMutableArray array];
        _reusePointLayers = [NSMutableSet set];
        
        _labelLayers = [NSMutableArray array];
        _reuseLabelLayers = [NSMutableSet set];
        
        _labelFontSize = 10;
    }
    
    return self;
}

#pragma mark - Public

- (CALayer *)dequeuePointLayer {
    if (!_drawAxis) {
        return nil;
    }
    
    CALayer *pointLayer = [_reusePointLayers anyObject];
    if (pointLayer) {
        [_reusePointLayers removeObject:pointLayer];
    } else {
        pointLayer = [CALayer layer];
        pointLayer.frame = CGRectMake(0, 0, 3, 3);
        pointLayer.cornerRadius = 1.5f;
        pointLayer.shadowOpacity = 1.5f;
        pointLayer.shadowOffset = CGSizeZero;
        
        pointLayer.backgroundColor = _axisColor;
        pointLayer.shadowColor = _axisColor;
    }
    
    [_pointLayers addObject:pointLayer];
    
    return pointLayer;
}

- (CATextLayer *)dequeueLabelLayer {
    if (!_drawLabels) {
        return nil;
    }
    
    CATextLayer *labelLayer = [_reuseLabelLayers anyObject];
    if (labelLayer) {
        [_reuseLabelLayers removeObject:labelLayer];
    } else {
        labelLayer = [CATextLayer layer];
        labelLayer.frame = CGRectMake(0, 0, 50, _labelFontSize);
        labelLayer.fontSize = _labelFontSize;
        labelLayer.alignmentMode = @"center";
        labelLayer.contentsScale = [UIScreen mainScreen].scale;
        labelLayer.foregroundColor = _labelsColor;
    }
    [_labelLayers addObject:labelLayer];
    
    return labelLayer;
}

- (void)setKeyPoints:(NSArray<NSNumber *> *)keyPoints withLabels:(NSArray<NSString *> *)keyLabels {
    for (CALayer *point in _pointLayers) {
        [point removeFromSuperlayer];
        [_reusePointLayers addObject:point];
    }
    [_pointLayers removeAllObjects];
    
    for (CATextLayer *label in _labelLayers) {
        [label removeFromSuperlayer];
        [_reuseLabelLayers addObject:label];
    }
    
    _keyPoints = keyPoints;
    for (int i = 0; i < keyPoints.count; i++) {
        CALayer *point = [self dequeuePointLayer];
        if (point) {
            [self addSublayer:point];
        }
    }
    
    _keyLabels = keyLabels;
    for (int i = 0; i < keyLabels.count; i++) {
        CATextLayer *label = [self dequeueLabelLayer];
        if (label) {
            [self addSublayer:label];
        }
    }
    
    [self setNeedsLayout];
}

#pragma mark - Setter

- (void)setDrawAxis:(BOOL)drawAxis {
    if (_drawAxis == drawAxis) {
        return;
    }
    
    _drawAxis = drawAxis;
    if (drawAxis) {
        if (!_axisLayer) {
            _axisLayer = [CALayer layer];
            _axisLayer.backgroundColor = _axisColor;
            [self addSublayer:_axisLayer];
        }
        
        if (!_pointLayers) {
            _pointLayers = [NSMutableArray array];
        }
        
        if (!_reusePointLayers) {
            _reusePointLayers = [NSMutableSet set];
        }
    } else {
        [_axisLayer removeFromSuperlayer];
        _axisLayer = nil;
        
        [_pointLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [_reusePointLayers removeAllObjects];
        _pointLayers = nil;
        _reusePointLayers = nil;
    }
}

- (void)setDrawLabels:(BOOL)drawLabels {
    if (_drawLabels == drawLabels) {
        return;
    }
    
    _drawLabels = drawLabels;
    if (drawLabels) {
        if (!_labelLayers) {
            _labelLayers = [NSMutableArray array];
        }
        
        if (!_reuseLabelLayers) {
            _reuseLabelLayers = [NSMutableSet set];
        }
    } else {
        [_labelLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        _labelLayers = nil;
        _reuseLabelLayers = nil;
    }
}

- (void)setAxisColor:(CGColorRef)axisColor {
    if (CGColorEqualToColor(_axisColor, axisColor)) {
        return;
    }
    
    _axisColor = axisColor;
    _axisLayer.backgroundColor = _axisColor;
}

- (void)setLabelsColor:(CGColorRef)labelsColor {
    if (CGColorEqualToColor(_labelsColor, labelsColor)) {
        return;
    }
    
    _labelsColor = labelsColor;
    for (CATextLayer *label in _labelLayers) {
        label.foregroundColor = labelsColor;
    }
}

@end
