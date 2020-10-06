//
//  HeartDataView.h
//  Muse
//
//  Created by Ken.Jiang on 1/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel.h>

@protocol HeartDataViewDataSource <NSObject>

@optional
/**
 *  设置显示数据：返回需要显示的数据，如果为nil，则不会滚。字典格式：@{@"Date":@"07-05 11:32", @"HeartRate":@"73"}
 *
 *  @param scrollUp 滚动方向
 *
 *  @return 返回需要显示的数据，如果为nil，则不会滚。字典格式：@{@"Date":@"07-05 11:32", @"HeartRate":@"73"}
 */
- (NSDictionary<NSString *, NSString *> *)heartDataViewScrollUp:(BOOL)scrollUp;

@end

@interface HeartDataView : UIView

@property (weak, nonatomic) IBOutlet iCarousel *chartContainer;

@property (weak, nonatomic) id<HeartDataViewDataSource> dataSource;

+ (instancetype)viewFromNib;

/**
 *  设置显示的数据：Date格式 MM-dd HH:mm
 *
 *  @param date      Date格式 MM-dd HH:mm
 *  @param heartRate 心率数据
 */
- (void)setDate:(NSString *)date heartRate:(NSString *)heartRate;

@end
