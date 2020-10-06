//
//  ChartLegendLayer.m
//  Chart
//
//  Created by Ken.Jiang on 20/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import "ChartLegendLayer.h"
#import <UIKit/UIScreen.h>

@interface LegendLayer : CALayer {
    CALayer *_pointLayer;
}

@property (nonatomic) CGColorRef color;

@end

@implementation LegendLayer

- (instancetype)init {
    if (self = [super init]) {
        _pointLayer = [CALayer layer];
//        _pointLayer.cornerRadius = 1.5f;
//        _pointLayer.shadowOpacity = 1;
//        _pointLayer.shadowOffset = CGSizeZero;
        [self addSublayer:_pointLayer];
    }
    
    return self;
}

- (void)setColor:(CGColorRef)color {
    if (CGColorEqualToColor(_color, color)) {
        return;
    }
    
    _color = color;
    
//    self.backgroundColor = color;
    
    _pointLayer.backgroundColor = color;
    _pointLayer.shadowColor = color;
}

- (void)layoutSublayers {
    CGFloat width = self.frame.size.width;
    _pointLayer.frame = CGRectMake(width - 2, -2, 4, 4);
}

@end

@interface ChartLegendLayer () {
    NSMutableArray<LegendLayer *> *_layers;
    NSMutableArray<CATextLayer *> *_nameLayers;
    
    CGFloat _layerWidth;
    CGFloat _nameWidth;
    CGFloat _contentMargin;
}

@end

@implementation ChartLegendLayer

- (instancetype)init {
    if (self = [super init]) {
        _layerWidth = 10;
        _nameWidth = 60;
        _contentMargin = 6;
        _legendFontSize = 12;
        
        _layers = [NSMutableArray array];
        _nameLayers = [NSMutableArray array];
    }
    
    return self;
}

- (void)setLegends:(NSArray<ChartLegend *> *)legends {
    if ([_legends isEqualToArray:legends]) {
        return;
    }
    
    _legends = legends;
    [self rebuildLegends];
}

#pragma mark - Private

- (void)loadLayers {
    //remove unused layers or add lack layers
    if (_legends.count < _layers.count) {
        NSUInteger count = _layers.count - _legends.count;
        for (int i = 0; i < count; i++) {
            LegendLayer *layer = [_layers lastObject];
            [layer removeFromSuperlayer];
            [_layers removeObject:layer];
            
            CATextLayer *textLayer = [_nameLayers lastObject];
            [textLayer removeFromSuperlayer];
            [_nameLayers removeObject:textLayer];
        }
    } else if (_legends.count > _layers.count) {
        NSUInteger count = _legends.count - _layers.count;
        for (int i = 0; i < count; i++) {
            LegendLayer *layer = [LegendLayer layer];
            [self addSublayer:layer];
            [_layers addObject:layer];
            
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.fontSize = _legendFontSize;
            textLayer.alignmentMode = @"left";
            [self addSublayer:textLayer];
            [_nameLayers addObject:textLayer];
        }
    }
}

- (void)rebuildLegends {
    [self loadLayers];
    
    //setting layers
    for (int i = 0; i < _legends.count; i++) {
        ChartLegend *legend = _legends[i];
        
        LegendLayer *layer = _layers[i];
        layer.color = legend.color.CGColor;
        
        CATextLayer *textLayer = _nameLayers[i];
        textLayer.string = legend.name;
        textLayer.foregroundColor = legend.nameColor.CGColor;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    
    [self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSublayers {
    CGFloat nameWidth = _nameWidth;
    CGFloat lastLegendRight = 0;
    
    for (int i = 0; i < _legends.count; i++) {
        LegendLayer *layer = _layers[i];
        layer.frame = CGRectMake(lastLegendRight, _legendFontSize/2 + 1, _layerWidth, 1);
        
        //计算标签的宽度
        ChartLegend *legend = _legends[i];
        NSString *name = legend.name;
        nameWidth = [name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12)
                                               options:0
                                            attributes:nil
                                               context:nil].size.width;
        nameWidth = MAX(_nameWidth, nameWidth);
        
        CATextLayer *textLayer = _nameLayers[i];
        textLayer.frame = CGRectMake(lastLegendRight + _layerWidth + _contentMargin, 0, nameWidth, _legendFontSize + 2);
        
        lastLegendRight += (_layerWidth + _contentMargin + nameWidth);
    }
}

@end
