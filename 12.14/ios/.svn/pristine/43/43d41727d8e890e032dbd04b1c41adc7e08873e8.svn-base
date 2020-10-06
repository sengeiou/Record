//
//  AxisYLayer.m
//  Chart
//
//  Created by Ken.Jiang on 20/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import "AxisYLayer.h"

@implementation AxisYLayer {
    CGFloat _labelWidth;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setDrawAxis:NO];
        
        _labelWidth = 40;
        
        _keyLines = [NSMutableArray array];
        _reuseKeyLines = [NSMutableSet set];
        
        _keyLineWidth = 8;
    }
    
    return self;
}

- (CATextLayer *)dequeueLabelLayer {
    CATextLayer *textLayer = [super dequeueLabelLayer];
    textLayer.alignmentMode = @"right";
    textLayer.wrapped = YES;
    textLayer.frame = CGRectMake(0, 0, _labelWidth, self.labelFontSize * 3); //最大显示3行
    
    return textLayer;
}

#pragma mark - Override

- (void)setLabelsColor:(CGColorRef)labelsColor {
    [super setLabelsColor:labelsColor];
    
    for (CATextLayer *keyLine in _keyLines) {
        keyLine.backgroundColor = labelsColor;
    }
}

- (void)setKeyPoints:(NSArray<NSNumber *> *)keyPoints withLabels:(NSArray<NSString *> *)keyLabels {
    
    for (CALayer *keyLine in _keyLines) {
        [keyLine removeFromSuperlayer];
        [_reuseKeyLines addObject:keyLine];
    }
    [_keyLines removeAllObjects];
    
    for (int i = 0; i < keyLabels.count; i++) {
        CALayer *keyLine = [self dequeueKeyLines];
        if (keyLine) {
            [self addSublayer:keyLine];
        }
    }
    
    [super setKeyPoints:keyPoints withLabels:keyLabels];
}

#pragma mark - Private

- (CALayer *)dequeueKeyLines {
    CALayer *keyLine = [_reuseKeyLines anyObject];
    if (keyLine) {
        [_reuseKeyLines removeObject:keyLine];
    } else {
        keyLine = [CALayer layer];
        keyLine.frame = CGRectMake(0, 0, _keyLineWidth, 1);
        keyLine.backgroundColor = _labelsColor;
    }
    
    [_keyLines addObject:keyLine];
    
    return keyLine;
}

#pragma mark - Layout

- (void)layoutSublayers {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    UIFont *font = [UIFont systemFontOfSize:self.labelFontSize];
    NSDictionary *atts = @{NSFontAttributeName:font};
    
    for (int i = 0; i < _keyPoints.count; i++) {
        CGFloat progress = [_keyPoints[i] floatValue];
        CGFloat keyHeight = height * (1 - progress);
        
        NSString *string = _keyLabels[i];
        CATextLayer *label = _labelLayers[i];

        CGFloat labelHeight = [string boundingRectWithSize:CGSizeMake(_labelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:atts context:nil].size.height;
        CGRect frame = label.frame;
        frame.size.height = labelHeight;
        label.frame = frame;

        label.string = string;
        label.position = CGPointMake(width/2 - _labelMargin * 2 - _keyLineWidth - 4,
                                     keyHeight);
        
        CALayer *keyLine = _keyLines[i];
        keyLine.position = CGPointMake(width - _keyLineWidth, keyHeight);
    }
}

@end
