//
//  HeartSingleDataView.h
//  Muse
//
//  Created by Ken.Jiang on 5/7/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartSingleDataView : UIView

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;

+ (instancetype)viewFromNib;

/**
 *  设置显示的数据：Date格式 MM-dd HH:mm
 *
 *  @param date      Date格式 MM-dd HH:mm
 *  @param heartRate 心率数据
 */
- (void)setDate:(NSString *)date heartRate:(NSString *)heartRate;

@end
