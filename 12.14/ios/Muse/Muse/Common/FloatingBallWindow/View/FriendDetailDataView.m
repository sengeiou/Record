//
//  FriendDetailDataView.m
//  Muse
//
//  Created by paycloud110 on 16/7/9.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "FriendDetailDataView.h"
//#import "ZFBarChart.h"

//@interface FriendDetailDataView () <ZFGenericChartDataSource, ZFBarChartDelegate>
@interface FriendDetailDataView ()

@end

@implementation FriendDetailDataView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self setup];
//    }
//    return self;
//}
//
//- (void)setup
//{
//    ZFBarChart * barChart = [[ZFBarChart alloc] init];
//    barChart.dataSource = self;
//    barChart.delegate = self;
//    [self addSubview:barChart];
//    [barChart strokePath];
//    barChart.backgroundColor = [UIColor purpleColor];
//    
//    [barChart mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.left.equalTo(self.mas_left);
//        make.bottom.equalTo(self.mas_bottom);
//        make.right.equalTo(self.mas_right);
//    }];
//}
//
//#pragma mark - ZFGenericChartDataSource
//- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart
//{
//    return @[@"22", @"111", @"211", @"124", @"213", @"160", @"14", @"49"];
//}
//
//- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart
//{
//    return @[@"3.12", @"3.13", @"3.14", @"3.15", @"3.16", @"3.17", @"3.18", @"今天"];
//}
//- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart
//{
//    return @[ZFBlack, ZFBlue, ZFRed, ZFPurple, ZFBrown, ZFYellow, ZFSkyBlue, ZFBlue];
//}
///** 规定的最大值 */
//- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart
//{
//    return 140;
//}
///** 规定的最小值 */
//- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart
//{
//    return 1;
//}
///** 竖轴线分几组 */
//- (NSInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart
//{
//    return 5;
//}
//
//#pragma mark - ZFBarChartDelegate
///** 柱宽度 */
//- (CGFloat)barWidthInBarChart:(ZFBarChart *)barChart
//{
//    return 22;
//}
///** 柱水平间隙 */
//- (CGFloat)paddingForGroupsInBarChart:(ZFBarChart *)barChart
//{
//    return 11;
//}
///** 顶部显示数字色 */
//- (id)valueTextColorArrayInBarChart:(ZFGenericChart *)barChart
//{
//    return ZFRed;
//}
///** 点击了哪个 */
//- (void)barChart:(ZFBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex
//{
//    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)barIndex);
//}

@end
