//
//  SettingSubTableViewCell.m
//  Muse
//
//  Created by paycloud110 on 16/7/17.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SettingSubTableViewCell.h"

@interface SettingSubTableViewCell () {
    BOOL _setuped;
}

/**  */
@property (nonatomic, weak) NOHeightLightButton *button;

@end

@implementation SettingSubTableViewCell

- (void)setupChildViewOnlyLeft:(NSString *)text {
    if (_setuped) {
        _leftLabel.text = text;
        return;
    }
    
    _setuped = YES;
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.backgroundColor = UIColorFromRGB(0xefefef);
    backImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:backImageView];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    self.leftLabel = leftLabel;
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.textColor = UIColorFromRGBA(0x000000, 0.8);
    leftLabel.text = text;
    leftLabel.numberOfLines = 0;
    leftLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [leftLabel sizeToFit];
    [backImageView addSubview:leftLabel];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = UIColorFromRGB(0x969696);
    [backImageView addSubview:bottomLineView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
    }];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).offset(26);
        make.right.equalTo(self.contentView.mas_right).offset(-6);
        make.centerY.equalTo(backImageView.mas_centerY);
      //  make.width.equalTo(@(leftLabel.width));
       // make.height.equalTo(@(leftLabel.height));
    }];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).offset(26);
        make.right.equalTo(backImageView.mas_right).offset(-26);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(backImageView.mas_bottom).offset(0);
    }];
}

- (void)setupChildView:(NSString *)text buttonState:(BOOL)aBool {
    if (_setuped) {
        _leftLabel.text = text;
        _button.selected = aBool;
        return;
    }
    
    _setuped = YES;
    MSLog(@"%d",aBool);
    MSLog(@"%d",[[kUserDefaults objectForKey:@"heartRate"]boolValue]);
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.backgroundColor = UIColorFromRGB(0xefefef);
    backImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:backImageView];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    self.leftLabel = leftLabel;
    leftLabel.font = [UIFont systemFontOfSize:16];
    leftLabel.textColor = UIColorFromRGBA(0x000000, 0.8);
    leftLabel.text = text;
    [leftLabel sizeToFit];
    [backImageView addSubview:leftLabel];
    
    NOHeightLightButton *button = [NOHeightLightButton buttonWithType:UIButtonTypeCustom];
    self.button = button;
    button.selected = aBool;
    [button setImage:[UIImage imageNamed:@"btn_clocktest_switch_off"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_clocktest_switch_on"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).offset(26);
        make.centerY.equalTo(backImageView.mas_centerY);
        make.width.equalTo(@(leftLabel.width));
        make.height.equalTo(@(leftLabel.height));
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-23);
        make.width.equalTo(@(70));
        make.height.equalTo(@(32));
        
    }];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).offset(26);
        make.right.equalTo(backImageView.mas_right).offset(-26);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(backImageView.mas_bottom).offset(0);
    }];
}

- (void)leftButtonClicked:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(settingSubTableViewCell:withButton:)]) {
        [self.delegate settingSubTableViewCell:self withButton:button];
    }
}

@end
