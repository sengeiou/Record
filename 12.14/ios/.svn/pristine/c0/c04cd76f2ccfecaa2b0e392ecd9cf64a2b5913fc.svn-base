//
//  ChartBarLayer.m
//  Chart
//
//  Created by Ken.Jiang on 20/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import "ChartBarLayer.h"

@interface BarLayer : CALayer {
    CALayer *_topPointLayer;
    CALayer *_normalBarLayer;
    CALayer *_extraBarLayer;
    
    CGFloat _extraMargin;
}

@property (assign) CGFloat value;

@property (nonatomic) CGColorRef barColor;
@property (nonatomic) CGColorRef extraBarColor;

@property (assign) CGFloat extraHeight;

@end

@implementation BarLayer

- (instancetype)init {
    if (self = [super init]) {
        _extraBarLayer = [CALayer layer];
        [self addSublayer:_extraBarLayer];
        
        _normalBarLayer = [CALayer layer];
        [self addSublayer:_normalBarLayer];
        
        _topPointLayer = [CALayer layer];
//        _topPointLayer.shadowOpacity = 1;
//        _topPointLayer.shadowOffset = CGSizeZero;
//        _topPointLayer.shadowRadius = 5;
        [self addSublayer:_topPointLayer];
        
        _extraMargin = 2;
    }
    
    return self;
}

- (void)setBarColor:(CGColorRef)barColor {
    if (CGColorEqualToColor(_barColor, barColor)) {
        return;
    }
    
    _barColor = barColor;
    _normalBarLayer.backgroundColor = barColor;
}

- (void)setExtraBarColor:(CGColorRef)extraBarColor {
    if (CGColorEqualToColor(_extraBarColor, extraBarColor)) {
        return;
    }
    
    _extraBarColor = extraBarColor;
    _extraBarLayer.backgroundColor = extraBarColor;
}

- (void)layoutSublayers {
    CGFloat width = self.frame.size.width;
    _normalBarLayer.frame = self.bounds;
    
    if (_extraHeight > 0) {
        _topPointLayer.backgroundColor = _extraBarColor;
        _topPointLayer.shadowColor = _extraBarColor;
        
        _extraBarLayer.frame = CGRectMake(0, 0, width, _extraHeight);
        _normalBarLayer.frame = CGRectMake(0, _extraHeight + _extraMargin,
                                           width, self.frame.size.height - _extraHeight - _extraMargin);
    } else {
        _topPointLayer.backgroundColor = _barColor;
        _topPointLayer.shadowColor = _barColor;
        
        _extraBarLayer.frame = CGRectZero;
    }
    
    if (_value == 0) {
        _topPointLayer.hidden = NO;
    } else {
        _topPointLayer.hidden = NO;
        
        CGFloat half = width * 3.f;
        _topPointLayer.cornerRadius = half/2;
        _topPointLayer.masksToBounds =YES;
        _topPointLayer.frame = CGRectMake(-half/2+width/2, -half+1.f, half, half);
    }
}

@end

@interface ChartBarLayer () {
    NSMutableArray *_bars;
}

@end

@implementation ChartBarLayer

- (instancetype)init {
    if (self = [super init]) {
        _bars = [NSMutableArray array];
        _numberOfBars = 0;
        _barWidth = 2.f;
    }
    
    return self;
}

#pragma mark - Setter

- (void)setNumberOfBars:(NSUInteger)numberOfBars {
    if (_numberOfBars == numberOfBars) {
        return;
    }
    
    _numberOfBars = numberOfBars;
    [self rebuildBars];
}

- (void)setBarColor:(CGColorRef)barColor {
    for (BarLayer *bar in _bars) {
        bar.barColor = barColor;
    }
}

- (void)setExtraBarColor:(CGColorRef)extraBarColor {
    for (BarLayer *bar in _bars) {
        bar.extraBarColor = extraBarColor;
    }
}

#pragma mark - Public

- (void)setBarValue:(float)value atIndex:(NSInteger)index {
    if (index >= _bars.count) {
        return;
    }
    
    BarLayer *bar = _bars[index];
    bar.value = value;
    [bar setNeedsLayout];
}

#pragma mark - Privates

- (void)loadBars {
    //remove unused layers or add lack layers
    if (_numberOfBars < _bars.count) {
        NSUInteger count = _bars.count - _numberOfBars;
        for (int i = 0; i < count; i++) {
            BarLayer *bar = [_bars lastObject];
            [bar removeFromSuperlayer];
            [_bars removeObject:bar];
        }
    } else if (_numberOfBars > _bars.count) {
        NSUInteger count = _numberOfBars - _bars.count;
        for (int i = 0; i < count; i++) {
            BarLayer *bar = [BarLayer layer];
            bar.barColor = self.barColor;
            bar.extraBarColor = self.extraBarColor;
            [self addSublayer:bar];
            [_bars addObject:bar];
        }
    }
}

- (void)rebuildBars {
    [self loadBars];
}

#pragma mark - Layout

- (void)layoutSublayers {
    CGFloat width = self.bounds.size.width;
    CGFloat barGap = width/(_numberOfBars - 1);
    
    CGFloat height = self.bounds.size.height;
    CGFloat heightPerValue = height/(_maxValue - _minValue);
    
    for (int i = 0; i < _numberOfBars; i++) {
        BarLayer *bar = _bars[i];
        CGFloat barHeight = floorf(heightPerValue * bar.value);
        bar.frame = CGRectMake(barGap * i, height - barHeight, _barWidth, barHeight);
        bar.extraHeight = (bar.value - _extraValue) / bar.value * bar.bounds.size.height;
    }
}


@end
