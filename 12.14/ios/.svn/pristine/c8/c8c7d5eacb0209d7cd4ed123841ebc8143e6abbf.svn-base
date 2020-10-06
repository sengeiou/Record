//
//  HeartSingleDataView.m
//  Muse
//
//  Created by Ken.Jiang on 5/7/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "HeartSingleDataView.h"

@implementation HeartSingleDataView

+ (instancetype)viewFromNib {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HeartSingleDataView" owner:self options:nil] lastObject];
}

- (void)setDate:(NSString *)date heartRate:(NSString *)heartRate {
    
    NSArray *dates = [date componentsSeparatedByString:@" "];
    
    if (dates.count == 2) {
        _dateLabel.text = dates[0];
        _timeLabel.text = dates[1];
    } else {
        _dateLabel.text = nil;
        _timeLabel.text = nil;
    }
    
    _heartRateLabel.text = heartRate;
}

@end
