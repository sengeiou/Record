//
//  SettingTableViewCell.m
//  Muse
//
//  Created by paycloud110 on 16/7/17.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SettingTableViewCell.h"

#define kIndicatorViewTag -1

@interface SettingTableViewCell () {
    BOOL _setuped;
}

/**  */
@property (nonatomic, weak) NOHeightLightButton *button;

@end

@implementation SettingTableViewCell

- (void)setupChildView
{
//    if (_setuped) {
//        return;
//    }
//    _setuped = YES;
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"block_homepage_setting"];
    [self.contentView addSubview:backImageView];
    self.backImageView = backImageView;
    
    NOHeightLightButton *button = [NOHeightLightButton buttonWithType:UIButtonTypeCustom];
    self.button = button;
    [button setImage:[UIImage imageNamed:@"icon_homepage2_open"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_homepage2_close"] forState:UIControlStateSelected];
    [backImageView addSubview:button];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = UIColorFromRGB(0x969696);
    [backImageView addSubview:bottomLineView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.width.equalTo(@(16));
        make.height.equalTo(@(9));
        
    }];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).offset(0);
        make.right.equalTo(backImageView.mas_right).offset(0);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(backImageView.mas_bottom).offset(0);
    }];
}

/** 是否展开 1 展开 0关闭 */
- (void)setExpanded:(BOOL)expanded
{
    [super setExpanded:expanded];
    self.button.selected = expanded;
}

@end
