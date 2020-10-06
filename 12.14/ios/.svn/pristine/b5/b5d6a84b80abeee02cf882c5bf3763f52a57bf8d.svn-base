//
//  SleepDataView.m
//  Muse
//
//  Created by Ken.Jiang on 2/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "SleepDataView.h"

@implementation SleepDataView

+ (instancetype)viewFromNib {
    return [[[NSBundle mainBundle] loadNibNamed:@"SleepDataView" owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    _chartContainer.bounceDistance = 0.5f;
    _chartContainer.decelerationRate = 0.5f;
    
    _timeView = [SleepDataTimeView viewFromNib];
    [_todayContentView addSubview:_timeView];
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(_todayContentView.mas_width).multipliedBy(0.5f);
    }];
    
    _grapFatherView = [SleepGrapFatherView viewFromNib];
    [_todayContentView addSubview:_grapFatherView];
    [_grapFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(_timeView.mas_trailing);
        make.bottom.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
//    _grapFatherView.graphView.grapArr = @[@{@"type":@(SleepGrapTypeDeep),@"period":@(5),@"time":@"5:20-5:30"},
//                           @{@"type":@(SleepGrapTypeDeep),@"period":@(8),@"time":@"5:20-5:30"},
//                           @{@"type":@(SleepGrapTypeDeep),@"period":@(4),@"time":@"5:20-5:30"}
//                           ];
}

@end
