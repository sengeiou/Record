//
//  PillarSleepTimeChartView.m
//  GoneNengYanZheng
//
//  Created by paycloud110 on 16/7/15.
//  Copyright © 2016年 paycloud110. All rights reserved.
//

#import "PillarSleepTimeChartView.h"

@interface PillarSleepTimeChartView () {
    NSMutableArray<UILabel *> *_labels;
    NSMutableSet *_reuseLabels;
    
    UIView *_lineView;
}

/**  */
@property (nonatomic, strong) NSArray *data;

@end

@implementation PillarSleepTimeChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xc5cccf);
        
        _labels = [NSMutableArray array];
        _reuseLabels = [NSMutableSet set];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0x989a9c);
        [self addSubview:_lineView];
    }
    return self;
}

- (void)cleanLabels {
    [_labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (UILabel *label in _labels) {
        [_reuseLabels addObject:label];
    }
    
    [_labels removeAllObjects];
}

- (UILabel *)dequeueLabel {
    UILabel *label = [_reuseLabels anyObject];
    if (label) {
        [_reuseLabels removeObject:label];
    } else {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:9];
        label.textAlignment = NSTextAlignmentCenter;
    }
    [_labels addObject:label];
    
    return label;
}

- (void)drawRect:(CGRect)rect {
    CGFloat rectWidth = rect.size.width;
    CGFloat rectHeight = rect.size.height;
    
    NSMutableArray *days = [[NSMutableArray alloc] init];
    NSMutableArray *sleeps = [[NSMutableArray alloc] init];
    NSMutableArray *deepSleeps = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.data.count; i++) {
        NSDictionary *dict = self.data[i];
        [days addObject:dict[@"day"]];
        [sleeps addObject:dict[@"sleep"]];
        [deepSleeps addObject:dict[@"is_deep"]];
    }
    
    // 时间
    [self cleanLabels];
    CGFloat timeHeight = 12;
    CGFloat timeSpace = 2;
    CGFloat timeWidth = (rectWidth - timeSpace * (self.data.count - 1)) / self.data.count;
    for (NSInteger i = 0; i < self.data.count; i++) {
        UILabel *label = [self dequeueLabel];
        
        if (i == self.data.count - 1) {
            label.textColor = UIColorFromRGB(0x52b567);
            label.text = @"今天";
        } else {
            label.textColor = UIColorFromRGB(0x505050);
            label.text = (NSString *)days[i];
        }
        
        CGFloat stringX = i * (timeWidth + timeSpace);
        CGFloat stringY = rectHeight - timeHeight;
        label.frame = CGRectMake(stringX, stringY, timeWidth, timeHeight);
        [self addSubview:label];
    }
    // 分割线
    CGFloat lineHeight = 1;
    CGFloat lineSpace = 4;
    _lineView.frame = CGRectMake(0, rectHeight - timeHeight - lineSpace, rectWidth, lineHeight);
    
    // 绘图
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGFloat contextBottomSpace = 5;
    CGFloat totalHeight = rectHeight - timeHeight - lineSpace - lineHeight - contextBottomSpace;
    for (NSInteger i = 0; i < self.data.count; i++) {
        // 所有睡眠
        NSString *numString = sleeps[i]; // all
        NSInteger num = [numString integerValue];
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        CGFloat contextX = i * (timeSpace + timeWidth) + timeWidth / 2;
        CGFloat contextAllY = totalHeight;
        
        //返回的每个记录的时间为10分钟，转化成小时
        CGFloat progressOne = num / (6 * 24.f);
        if (progressOne < 0 || progressOne >= 1) {
            progressOne = 1;
        }
        CGFloat contextAllAddY = contextAllY - progressOne * totalHeight / 24;
        [bezierPath moveToPoint:CGPointMake(contextX, contextAllY)];
        [bezierPath addLineToPoint:CGPointMake(contextX, contextAllAddY)];
        CGContextAddPath(contextRef, bezierPath.CGPath);
        [UIColorFromRGB(0xe4e7e8) setStroke];
        CGContextSetLineWidth(contextRef, timeWidth);
        CGContextSaveGState(contextRef);
        CGContextStrokePath(contextRef);
        
        // 深睡
        NSString *numInString = deepSleeps[i]; // in
        NSInteger numIn = [numInString integerValue];
        bezierPath = [UIBezierPath bezierPath];
        CGFloat contextInY = contextAllY;
        
        //返回的每个记录的时间为10分钟，转化成小时
        CGFloat progress = numIn / (6 * 24.f);
        if (progress < 0 || progress >= 1) {
            progress = 1;
        }
        CGFloat contextInAddY = contextInY - progress * totalHeight / progressOne;
        [bezierPath moveToPoint:CGPointMake(contextX, contextInY)];
        [bezierPath addLineToPoint:CGPointMake(contextX, contextInAddY)];
        CGContextAddPath(contextRef, bezierPath.CGPath);
        CGContextRestoreGState(contextRef);
        [UIColorFromRGB(0x828589) setStroke];
        CGContextSetLineWidth(contextRef, timeWidth);
        CGContextStrokePath(contextRef);
    }
}

- (void)setupChildView:(NSArray *)data {
    if ([_data isEqualToArray:data]) {
        return;
    }
//    NSArray *dataOne = @[
//                         @{@"day":@"08.26", @"sleep":@"9", @"is_deep":@"5"},
//                         @{@"day":@"08.26", @"sleep":@"6", @"is_deep":@"3"},
//                         @{@"day":@"08.26", @"sleep":@"7", @"is_deep":@"4"},
//                         @{@"day":@"08.26", @"sleep":@"8", @"is_deep":@"5"},
//                         @{@"day":@"08.26", @"sleep":@"9", @"is_deep":@"7"},
//                         @{@"day":@"08.26", @"sleep":@"9", @"is_deep":@"8"},
//                         @{@"day":@"08.27", @"sleep":@"11", @"is_deep":@"9"},
//                         ];
    NSMutableArray *dictArrayOne = [[NSMutableArray alloc] init];
    for (NSDictionary *str  in [data reverseObjectEnumerator]) {
        [dictArrayOne addObject:str];
    }
    NSMutableArray *dateArray = [[NSMutableArray alloc] initWithArray:dictArrayOne];
    for (NSInteger i = dateArray.count; i < 8; i++) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"MM.dd";
        NSDate *lastday = [NSDate dateWithTimeIntervalSinceNow: -24 * 60 * 60 * i];
        NSString *yesterday = [fmt stringFromDate:lastday];
        NSDictionary *dict = @{@"day":yesterday, @"sleep":@"", @"is_deep":@""};
        [dateArray addObject:dict];
    }
    NSMutableArray *dictArray = [[NSMutableArray alloc] init];
    for (NSDictionary *str  in [dateArray reverseObjectEnumerator]) {
        [dictArray addObject:str];
    }
    _data = dictArray;
    [self setNeedsDisplay];
}

@end
