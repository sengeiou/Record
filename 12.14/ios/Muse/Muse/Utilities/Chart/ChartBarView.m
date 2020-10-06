//
//  ChartBarView.m
//  Chart
//
//  Created by Ken.Jiang on 19/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import "ChartBarView.h"
#import "AxisXLayer.h"
#import "AxisYLayer.h"
#import "ChartLegendLayer.h"
#import "ChartBarLayer.h"

@interface ChartBarView () {
    ChartRange _yRange;
    NSUInteger _numberOfBars;
    
    CGFloat _topTitleHeight;
    CGFloat _bottomLegendHeight;
    CGFloat _axisXAndLabelHeight;
    CGFloat _leftYLabelWidth;
    CGFloat _rightMarginWidth;
    
    CGFloat _contentWidth;
    CGFloat _contentHeight;
    
    AxisXLayer *_xAxisLayer;
    AxisYLayer *_yAxisLayer;
    ChartLegendLayer *_legendLayer;
    NSMutableArray<ChartBar *> *_charts;
    NSMutableArray<ChartBarLayer *> *_chartLayers;
}

@property (strong, nonatomic) UILabel *titleLabel;

@end

@interface ChartBarView () {
    UIImageView *_xAxisImageView;
}

@end

@implementation ChartBarView

@synthesize charts = _charts;

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
    _topTitleHeight = 30;
    _bottomLegendHeight = 24;
    _axisXAndLabelHeight = 30;
    _leftYLabelWidth = 50;
    _rightMarginWidth = 20;
    
    CGSize size = self.frame.size;
    _contentWidth = size.width - _leftYLabelWidth - _rightMarginWidth;
    _contentHeight = size.height - _topTitleHeight - _bottomLegendHeight - _axisXAndLabelHeight;
    
    _charts = [NSMutableArray array];
    _chartLayers = [NSMutableArray array];
    
    
    _xAxisImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_secondarypage_form"]];
    [self addSubview:_xAxisImageView];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self reloadData];
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    if ([_title isEqualToString:title]) {
        return;
    }
    
    _title = title;
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _topTitleHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLabel];
    }
    
    _titleLabel.text = title;
}

#pragma mark - Public

- (void)addChart:(ChartBar *)chart {
    [_charts addObject:chart];
    
    ChartBarLayer *layer = [ChartBarLayer layer];
    layer.tag = chart.tag;
    [self.layer addSublayer:layer];
    [_chartLayers addObject:layer];
    
    [self drawCharts];
}

- (void)reloadData {
    _yRange = [self.dataSource rangeOfChartLineYValue:self];
    _numberOfBars = [self.dataSource countOfBarsInChartBarView:self];
    
    [self drawContent];
}

#pragma mark - Draw

- (void)drawContent {
    [self drawXAxisAndLabels];
    [self drawYAxisLabels];
    [self drawLegends];
    [self drawCharts];
}

- (void)drawXAxisAndLabels {
    if (!_xAxisLayer) {
        _xAxisLayer = [AxisXLayer layer];
        [self.layer addSublayer:_xAxisLayer];
    }
    
    if ([self.dataSource respondsToSelector:@selector(xLabelColorForChartBarView:)]) {
        UIColor *color = [_dataSource xLabelColorForChartBarView:self];
        if (color) {
            _xAxisLayer.axisColor = color.CGColor;
            _xAxisLayer.labelsColor = color.CGColor;
        }
    }
    
    NSMutableArray *keyPoints = [NSMutableArray array];
    NSMutableArray *labels = [NSMutableArray array];
    for (int i = 0; i < _numberOfBars; i++) {
        NSString *label = [self.dataSource chartBarView:self xLabelForIndex:i];
        if (label) {
            //start from 0
            [keyPoints addObject:@((float)i/(_numberOfBars - 1))];
            [labels addObject:label];
        }
    }
    
    [_xAxisLayer setKeyPoints:keyPoints withLabels:labels];
}

- (void)drawYAxisLabels {
    if (!_yAxisLayer) {
        _yAxisLayer = [AxisYLayer layer];
        [self.layer addSublayer:_yAxisLayer];
    }
    
    if ([self.dataSource respondsToSelector:@selector(yLabelColorForChartBarView:)]) {
        UIColor *color = [_dataSource yLabelColorForChartBarView:self];
        if (color) {
            _yAxisLayer.axisColor = color.CGColor;
            _yAxisLayer.labelsColor = color.CGColor;
        }
    }
    
    float totalValue = _yRange.end - _yRange.start;
    float interval = ABS(_yRange.interval/totalValue);
    NSMutableArray *keyPoints = [NSMutableArray array];
    NSMutableArray *labels = [NSMutableArray array];
    for (int i = 0; i < _yRange.steps; i++) {
        NSString *label = [self.dataSource chartBarView:self yLabelForStep:i];
        if (label) {
            [keyPoints addObject:@(interval * (i + 1))];
            [labels addObject:label];
        }
    }
    
    [_yAxisLayer setKeyPoints:keyPoints withLabels:labels];
}

- (void)drawLegends {
    if (![self.dataSource respondsToSelector:@selector(legendsForChartBarView:)]) {
        [_legendLayer removeFromSuperlayer];
        _legendLayer = nil;
        return;
    }
    
    if (!_legendLayer) {
        _legendLayer = [ChartLegendLayer layer];
        [self.layer addSublayer:_legendLayer];
    }
    
    _legendLayer.legends = [self.dataSource legendsForChartBarView:self];
}

- (void)drawCharts {
    for (int i = 0; i < _charts.count; i++) {
        ChartBar *chart = _charts[i];
        ChartBarLayer *chartLayer = _chartLayers[i];
        
        chartLayer.minValue = _yRange.start;
        chartLayer.maxValue = _yRange.end;
        chartLayer.numberOfBars = chart.numberOfBars;
        chartLayer.barColor = chart.colorOfBar.CGColor;
        chartLayer.extraBarColor = chart.extraColorOfBar.CGColor;
        chartLayer.extraValue = chart.extraYValue;
        
        for (int i = 0; i < chartLayer.numberOfBars; i++) {
            [chartLayer setBarValue:[chart.dataSource chartBar:chart yValueForIndex:i]
                            atIndex:i];
        }
    }
    
    [self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews {
    CGSize size = self.frame.size;
    _contentWidth = size.width - _leftYLabelWidth - _rightMarginWidth;
    _contentHeight = size.height - _topTitleHeight - _bottomLegendHeight - _axisXAndLabelHeight;
    
    CGFloat y = _topTitleHeight + _contentHeight;
    _xAxisLayer.frame = CGRectMake(_leftYLabelWidth, y, _contentWidth, _axisXAndLabelHeight);
    
    _xAxisImageView.center = CGPointMake(_leftYLabelWidth + _contentWidth/2, y + 8);
    
    _yAxisLayer.frame = CGRectMake(0, _topTitleHeight, _leftYLabelWidth, _contentHeight);
    
    y += _axisXAndLabelHeight;
    _legendLayer.frame = CGRectMake(_leftYLabelWidth, y, _contentWidth, _bottomLegendHeight);
    
    for (CALayer *chart in _chartLayers) {
        chart.frame = CGRectMake(_leftYLabelWidth, _topTitleHeight, _contentWidth, _contentHeight);
    }
}

@end
