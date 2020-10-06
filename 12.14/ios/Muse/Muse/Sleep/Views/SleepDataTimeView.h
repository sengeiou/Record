//
//  SleepDataTimeView.h
//  Muse
//
//  Created by Ken.Jiang on 2/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SleepDataTimeView : UIView

@property (weak, nonatomic) IBOutlet UILabel *dateTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalSleepTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deepSleepTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lightSleepTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *startAMPMImageView;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *endAMPMImageView;

@property (weak, nonatomic) IBOutlet UILabel *wakeTimeLabel;

+ (instancetype)viewFromNib;

@end
