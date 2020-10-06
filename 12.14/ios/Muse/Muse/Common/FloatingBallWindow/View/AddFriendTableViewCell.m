//
//  AddFriendTableViewCell.m
//  Muse
//
//  Created by paycloud110 on 16/7/6.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "AddFriendTableViewCell.h"
#import "ContentBackView.h"

@interface AddFriendTableViewCell () {
    BOOL _setuped;
}

/**  */
@property (nonatomic, weak) ContentBackView *backImageView;
/**  */
@property (nonatomic, weak) UILabel *topLabel;
/**  */
@property (nonatomic, weak) UIButton *agreeButton;
/**  */
@property (nonatomic, weak) UIButton *refuseButton;

@end

@implementation AddFriendTableViewCell

- (void)setupChildView {
    if (_setuped) {
        return;
    }
    _setuped = YES;
    
    ContentBackView *backImageView = [[ContentBackView alloc] initWhetherBottomView:YES];
    self.backImageView = backImageView;
    [self.contentView addSubview:backImageView];
    self.backImageView.backgroundColor = UIColorFromRGB(0xd7dcdd);
    UILabel *topLabel = [[UILabel alloc] init];
    self.topLabel = topLabel;
    topLabel.font = [UIFont systemFontOfSize:13];
    topLabel.textColor = UIColorFromRGB(0x505050);
    topLabel.numberOfLines = 0;
    topLabel.textAlignment = NSTextAlignmentCenter;
    [backImageView addSubview:topLabel];
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.agreeButton = agreeButton;
    agreeButton.tag = 10;
    [agreeButton setTitle:NSLocalizedString(@"agree", nil) forState:UIControlStateNormal];
    agreeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [agreeButton setTitleColor:UIColorFromRGB(0x505050) forState:UIControlStateNormal];
    [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_test2_white4"] forState:UIControlStateNormal];
    [agreeButton addTarget:self action:@selector(addFriendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [agreeButton setExclusiveTouch:YES];
    [backImageView addSubview:agreeButton];
    
    UIButton *refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refuseButton = refuseButton;
    refuseButton.tag = 11;
    [refuseButton setTitle:NSLocalizedString(@"disagree", nil) forState:UIControlStateNormal];
    refuseButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [refuseButton setTitleColor:UIColorFromRGB(0x505050) forState:UIControlStateNormal];
    [refuseButton setBackgroundImage:[UIImage imageNamed:@"btn_test2_white4"] forState:UIControlStateNormal];
    [refuseButton addTarget:self action:@selector(addFriendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [refuseButton setExclusiveTouch:YES];
    [backImageView addSubview:refuseButton];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImageView.mas_top).offset(16);
        make.left.equalTo(self.backImageView.mas_left).offset(8);
        make.right.equalTo(self.backImageView.mas_right).offset(8);
        make.height.equalTo(@50);
    }];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(82));
        make.height.equalTo(@(40));
        make.left.equalTo(self.backImageView.mas_left).offset(30);
        make.top.equalTo(self.topLabel.mas_bottom).offset(9);
    }];
    [self.refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(82));
        make.height.equalTo(@(40));
        make.left.equalTo(self.agreeButton.mas_right).offset(16);
        make.top.equalTo(self.topLabel.mas_bottom).offset(9);
    }];
}//SOS 心率超标 亲友
/** 加载数据 */
- (void)addChildeViewConstantsNameLabel:(NSString *)name {
    
    [self setupChildView];
    
    self.topLabel.text = [NSString stringWithFormat:@"\"%@\"%@", name, NSLocalizedString(@"wanttobeyourfriend", nil)];
    
  
}

- (void)addFriendButtonClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(addFriendTableViewCell:withButton:)]) {
        [self.delegate addFriendTableViewCell:self withButton:button];
    }
}

@end
