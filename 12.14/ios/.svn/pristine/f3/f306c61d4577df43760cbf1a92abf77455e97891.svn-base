//
//  SleepViewController.m
//  Muse
//
//  Created by Olive on 5/30/16.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "SleepViewController.h"

#import "SleepDataView.h"
#import "ChartBarView.h"
#import "ClockSettingView.h"
#import "SleepPopHelpView.h"

#import "UIColor+FastKit.h"

#import "SleepDataManager.h"

#define MaxShowMonth    6

@interface SleepViewController () <iCarouselDataSource, iCarouselDelegate, ChartBarViewDataSource, ChartBarDataSource, SleepDataManagerDelegate> {
    SleepDataView *_sleepDataView;
    
    SleepDataManager *_dataManager;
}

@property (assign, nonatomic) NSInteger currentYear;
@property (assign, nonatomic) NSInteger currentMonth;

@end

@implementation SleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupHeaderView:ControllerHeaderTypeSleep];
    self.detailProgressView.typeTopIMV.hidden = YES;
    
    //初始化界面
    self.detailProgressView.cellData = @{@"unit":@"unit_disk_time",
                                         @"progess":@0,
                                         @"bottomContent":@"睡眠质量：良"};
    [self.detailCenterButton setImage:[UIImage imageNamed:@"btn_secondarypage_sleep"]
                             forState:UIControlStateNormal];
//    [self.detailCenterButton setTitle:@"催眠"
//                             forState:UIControlStateNormal];
    [self.detailCenterButton addTarget:self action:@selector(settingClocks:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    _dataManager = [[SleepDataManager alloc] init];
    _dataManager.delegate = self;
    
    _sleepDataView = [SleepDataView viewFromNib];
    [self.dataContainer insertSubview:_sleepDataView atIndex:1];
    [_sleepDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.dataContainer);
    }];
    
    //set data
    NSDictionary *analysis = [_dataManager analysisOfLastDaySleep];
    _sleepDataView.timeView.totalSleepTimeLabel.text = analysis[@"totalSleep"];
    _sleepDataView.timeView.deepSleepTimeLabel.text = analysis[@"deepSleep"];
    _sleepDataView.timeView.lightSleepTimeLabel.text = analysis[@"lightSleep"];
    _sleepDataView.timeView.wakeTimeLabel.text = analysis[@"wakeTime"];
    _sleepDataView.timeView.startTimeLabel.text = analysis[@"startTime"];
    _sleepDataView.timeView.endTimeLabel.text = analysis[@"endTime"];
    
    _sleepDataView.grapFatherView.graphView.grapArr = analysis[@"sleepDetail"];
    
    NSDate *date = [NSDate date];
    _currentYear = date.year;
    _currentMonth = date.month;
    
    _sleepDataView.chartContainer.dataSource = self;
    _sleepDataView.chartContainer.delegate = self;
    
    [self.headerView.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.dataContainer.hidden = YES;
}

- (void)rightAction
{
    SleepPopHelpView *setPop = [SleepPopHelpView viewFromNibByVc:self];
    [setPop show];
}
#pragma mark - Actions

- (void)settingClocks:(id)sender {
    ClockSettingView *view = [ClockSettingView viewFromNib];
    [view show];
    
    __weak typeof(self) weakSelf = self;
    view.dismissBlock = ^{[weakSelf.headerView updateView];};
}

#pragma mark - SleepDataManagerDelegate

/**
 *  通知已获取到数据（界面可刷新）
 */
- (void)dataManagerDidFecthDatas {
    [_sleepDataView.chartContainer reloadData];
}

#pragma mark - iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return MaxShowMonth;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    ChartBarView *barView = (ChartBarView *)view;
    if (!barView) {
        CGRect frame = CGRectInset(carousel.bounds, 10, 0);
        barView = [[ChartBarView alloc] initWithFrame:frame];
        barView.dataSource = self;
        
        ChartBar *chart = [[ChartBar alloc] init];
        chart.dataSource = self;
        [barView addChart:chart];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 3;
        label.contentMode = UIViewContentModeBottom;
        label.textColor = [UIColor colorWithHex:0x4F4F58];
        label.textAlignment = NSTextAlignmentCenter;
        [barView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(50 - 20));
            make.bottom.equalTo(@-14);
            make.width.equalTo(@14);
            make.height.equalTo(@(14 * 5));
        }];
        label.tag = 'l';
    }
    
    NSInteger month = _currentMonth - index;
    NSInteger year = _currentYear;
    while (month < 1) {
        month += 12;
        year--;
    }
    
    for (ChartBar *chartBar in barView.charts) {
        if (chartBar.tag%10 == 1) { // 设置柱状图的tag，1为尾的是均睡眠总时长
            chartBar.tag = (year*100 + month)*10 + 1; // tag设置公式 tag ＝ 日期 * 10 + 1 （例如：20160601 的均睡眠时长就是 201606011）
        } else { //深睡眠时长
            chartBar.tag = (year*100 + month)*10 + 2; // tag设置公式 tag ＝ 日期 * 10 + 2 （例如：20160601 的均睡眠时长就是 201606012）
        }
    }
    
    [barView reloadData];
    UILabel *label = [barView viewWithTag:'l'];
    
    switch (month) {
        case 1:
            label.text = @"一月";
            break;
        case 2:
            label.text = @"二月";
            break;
        case 3:
            label.text = @"三月";
            break;
        case 4:
            label.text = @"四月";
            break;
        case 5:
            label.text = @"五月";
            break;
        case 6:
            label.text = @"六月";
            break;
        case 7:
            label.text = @"七月";
            break;
        case 8:
            label.text = @"八月";
            break;
        case 9:
            label.text = @"九月";
            break;
        case 10:
            label.text = @"十月";
            break;
        case 11:
            label.text = @"十一月";
            break;
        case 12:
            label.text = @"十二月";
            break;
        default:
            break;
    }
    
    return barView;
}

#pragma mark - iCarouselDelegate

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return _sleepDataView.bounds.size.width;
}

#pragma mark - ChartBarDataSource

//控制具体柱形图的柱图数量
- (NSUInteger)numberOfBarsInChartBar:(ChartBar *)chartBar {
    return 31;
}

//控制具体柱形图的柱图数值
- (CGFloat)chartBar:(ChartBar *)chartBar yValueForIndex:(NSInteger)index {
    NSInteger year = chartBar.tag/1000;
    NSInteger month = (chartBar.tag%1000)/10;
    NSArray *datas = [_dataManager sleepDataForYear:year month:month];
    
    if (index >= datas.count) {
        return 0;
    }
    
    NSDictionary *rateData = datas[index];
    CGFloat value = 0;
    if (chartBar.tag%10 == 1) { // 设置柱状图的tag，1为尾的是均睡眠总时长
        value = [rateData[@"TotalSleep"] floatValue];
    } else {
        value = [rateData[@"DeepSleep"] floatValue];
    }
    return value;
}

//控制具体柱形图的柱图颜色
- (UIColor *)colorOfBarInChartBar:(ChartBar *)chartBar {
    UIColor *color;
    if (chartBar.tag%10 == 1) { // 设置柱状图的tag，1为尾的是均睡眠总时长
        color = [UIColor colorWithHex:0x287751];
    } else {
        color = [UIColor colorWithHex:0x822E2E];
    }
    
    return color;
}

#pragma mark - ChartBarViewDataSource

//控制y坐标系
- (ChartRange)rangeOfChartLineYValue:(ChartBarView *)barView {
    return ChartRangeMake(0, 12, 3, 3);
}

//控制x坐标系
- (NSUInteger)countOfBarsInChartBarView:(ChartBarView *)barView {
    return 31;
}

//控制x坐标值显示
- (NSString *)chartBarView:(ChartBarView *)barView xLabelForIndex:(NSUInteger)index {
    if (index == 0) {
        return @"1";
    } else if ((index + 1)%10 == 0) {
        return [NSString stringWithFormat:@"%ld", (long)index + 1];
    }
    
    return nil;
}

//控制y坐标值显示
- (NSString *)chartBarView:(ChartBarView *)barView yLabelForStep:(NSUInteger)step {
    return [NSString stringWithFormat:@"%luh", (unsigned long)(step + 1) * 3];
}

- (UIColor *)xLabelColorForChartBarView:(ChartBarView *)barView {
    return [UIColor colorWithHex:0x4F4F58];
}

- (UIColor *)yLabelColorForChartBarView:(ChartBarView *)barView {
    return [UIColor colorWithHex:0x4F4F58];
}

- (NSArray<ChartLegend *> *)legendsForChartBarView:(ChartBarView *)barView {
    return @[[ChartLegend legendWithName:@"日均睡眠总时长"
                                   color:[UIColor colorWithHex:0x287751]
                               nameColor:[UIColor colorWithHex:0x4F4F58]],
             [ChartLegend legendWithName:@"日均全天深睡时长"
                                   color:[UIColor colorWithHex:0x822E2E]
                               nameColor:[UIColor colorWithHex:0x4F4F58]]];
}

@end
