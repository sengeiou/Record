//
//  PillarHeartChartView.m
//  GoneNengYanZheng
//
//  Created by paycloud110 on 16/7/15.
//  Copyright © 2016年 paycloud110. All rights reserved.
//

#import "PillarHeartChartView.h"

@interface PillarHeartChartView () {
    NSMutableArray<UILabel *> *_labels;
    NSMutableSet *_reuseLabels;
    
    UIView *_lineView;
}

@property (nonatomic, strong) NSArray *data;

@end

@implementation PillarHeartChartView

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

- (void)drawRect:(CGRect)rect
{
    CGFloat rectWidth = rect.size.width;
    CGFloat rectHeight = rect.size.height;
    
    NSMutableArray *days = [[NSMutableArray alloc] init];
    NSMutableArray *rates = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.data.count; i++) {
        NSDictionary *dict = self.data[i];
        [days addObject:dict[@"day"]];
        [rates addObject:dict[@"rate"]];
        
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
       // NSLog(@"%@",label);
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
        NSString *numString = rates[i];
        NSInteger num = [numString integerValue];
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        CGFloat contextX = i * (timeSpace + timeWidth) + timeWidth / 2;
        CGFloat contextY = totalHeight;
        CGFloat contextAddX = contextX;
        CGFloat contextAddY = contextY - num * totalHeight / 200; // 200为最大心跳
        [bezierPath moveToPoint:CGPointMake(contextX, contextY)];
        [bezierPath addLineToPoint:CGPointMake(contextAddX, contextAddY)];
        CGContextAddPath(contextRef, bezierPath.CGPath);
    }
    [UIColorFromRGB(0x828589) setStroke];
    CGContextSetLineWidth(contextRef, timeWidth);
    CGContextStrokePath(contextRef);
}

- (void)setupChildView:(NSArray *)data {
    if ([_data isEqualToArray:data]) {
        return;
    }
//    NSArray *dataOne = @[
////                         @{@"day":@"08.21", @"rate":@""},
////                         @{@"day":@"08.22", @"rate":@""},
////                         @{@"day":@"08.23", @"rate":@"68"},
////                         @{@"day":@"08.24", @"rate":@"78"},
////                         @{@"day":@"08.25", @"rate":@"88"},
//                         @{@"day":@"08.26", @"rate":@"98"},
//                         @{@"day":@"08.27", @"rate":@"198"},
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
        NSDictionary *dict = @{@"day":yesterday, @"rate":@""};
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
