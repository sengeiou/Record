//
//  FriendTableViewCell.m
//  Muse
//
//  Created by paycloud110 on 16/7/5.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "ContentBackView.h"

@interface FriendTableViewCell () {
    BOOL _setuped;
}

/**背景  */
@property (nonatomic, weak) ContentBackView *backView;
/**名字 */
@property (nonatomic, weak) UILabel *nameLabel;
/**心率图标  */
@property (nonatomic, weak) UIImageView *heartImageView;
/**心率  */
@property (nonatomic, weak) UILabel *heartNumLabel;
/**心率单位 */
@property (nonatomic, weak) UILabel *heartNumUnitLabel;
/**  */
@property (nonatomic, weak) UIImageView *sleepImageView;
/**  */
@property (nonatomic, weak) UILabel *sleepTimeLabel;
/**  */
@property (nonatomic, weak) UILabel *sleepTimeUnitLabel;

@end

@implementation FriendTableViewCell

- (void)setupChildView
{
    if (_setuped) {
        return;
    }
    _setuped = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = ColorWithLightTan;
    
    ContentBackView *backView = [[ContentBackView alloc] initWhetherBottomView:YES];
    self.backView = backView;
    [self.contentView addSubview:backView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.textColor = UIColorFromRGB(0x505050);
    nameLabel.font = [UIFont systemFontOfSize:16];
    [backView addSubview:nameLabel];
    
    UIImageView *heartImageView = [[UIImageView alloc] init];
    self.heartImageView = heartImageView;
    heartImageView.image = [UIImage imageNamed:@"icon_test2_heart_big"];
    [backView addSubview:heartImageView];
    
    UILabel *heartNumLabel = [[UILabel alloc] init];
    self.heartNumLabel = heartNumLabel;
    heartNumLabel.textColor = UIColorFromRGB(0x505050);
    heartNumLabel.font = [UIFont systemFontOfSize:20];
    [backView addSubview:heartNumLabel];
    
    UILabel *heartNumUnitLabel = [[UILabel alloc] init];
    self.heartNumUnitLabel = heartNumUnitLabel;
    heartNumUnitLabel.text = NSLocalizedString(@"Time/Min", nil);
    heartNumUnitLabel.textColor = UIColorFromRGBA(0x505050, 0.5);
    heartNumUnitLabel.font = [UIFont systemFontOfSize:10];
    [heartNumUnitLabel sizeToFit];
    [backView addSubview:heartNumUnitLabel];
    
    UIImageView *sleepImageView = [[UIImageView alloc] init];
    self.sleepImageView = sleepImageView;
    sleepImageView.image = [UIImage imageNamed:@"icon_test2_sleep_big"];
    [backView addSubview:sleepImageView];
/*
    UILabel *sleepTimeLabel = [[UILabel alloc] init];
    self.sleepTimeLabel = sleepTimeLabel;
    sleepTimeLabel.textColor = UIColorFromRGB(0x505050);
    sleepTimeLabel.font = [UIFont systemFontOfSize:20];
    [backView addSubview:sleepTimeLabel];
    
    UILabel *sleepTimeUnitLabel = [[UILabel alloc] init];
    self.sleepTimeUnitLabel = sleepTimeUnitLabel;
    sleepTimeUnitLabel.text = @"小时";
    sleepTimeUnitLabel.textColor = UIColorFromRGBA(0x505050, 0.5);
    sleepTimeUnitLabel.font = [UIFont systemFontOfSize:10];
    [sleepTimeUnitLabel sizeToFit];
    [backView addSubview:sleepTimeUnitLabel];
 */
}
/** 加载数据 */
- (void)setName:(NSString *)name heartRate:(NSString *)heartRate sleepTime:(NSString *)sleepTime
{
    [self setupChildView];
//    if (name.length > 7) {
//        name = [[name substringWithRange:NSMakeRange(0, 6)] stringByAppendingString:@".."];
//    }
    if (heartRate.length == 0 || heartRate == nil) {
        heartRate = @"0";
    }
    if (sleepTime.length == 0 || sleepTime == nil) {
        sleepTime = @"0";
    }
    
    self.nameLabel.text = name;
    self.heartNumLabel.text = heartRate;
    //返回的每个记录的时间为10分钟，转化成小时
//    self.sleepTimeLabel.text = [NSString stringWithFormat:@"%.1f", [sleepTime floatValue]/6];
    
    [self updateConstraintsChildView];
}
- (void)updateConstraintsChildView
{
    [self.nameLabel sizeToFit];
    [self.heartNumLabel sizeToFit];
    [self.sleepTimeLabel sizeToFit];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(0);
    }];
    //名字
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.backView.mas_left).offset(16);
        
    }];
//    [self.heartImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.backView.mas_centerY);
//        make.left.equalTo(self.nameLabel.mas_right).offset(8);
//        make.width.equalTo(@(20));
//        make.height.equalTo(@(20));
//    }];
    //心率图片
    [self.heartImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
       
    }];
     //心率单位
    [self.heartNumUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.backView.mas_centerY);
        make.right.equalTo(self.backView.mas_right).offset(-20);
    }];
    
    //心率数值
    [self.heartNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.right.equalTo(self.heartNumUnitLabel.mas_left).offset(-10);
    }];
    /*
    [self.sleepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.heartNumUnitLabel.mas_right).offset(20);
        make.width.equalTo(@(20));
        make.height.equalTo(@(20));
    }];
    [self.sleepTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.sleepImageView.mas_right).offset(6);
    }];
    [self.sleepTimeUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sleepTimeLabel.mas_right).offset(2);
        make.bottom.equalTo(self.sleepTimeLabel.mas_bottom).offset(-3);
    }];
     */
}
@end
