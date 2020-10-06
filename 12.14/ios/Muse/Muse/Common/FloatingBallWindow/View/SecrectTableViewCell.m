//
//  SecrectTableViewCell.m
//  Muse
//
//  Created by paycloud110 on 16/7/15.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SecrectTableViewCell.h"

@implementation SecrectTableViewCell {
    BOOL _setuped;
}

- (void)setupChildView {
    if (_setuped) {
        return;
    }
    
    _setuped = YES;
    
    UIImageView *backView = [[UIImageView alloc] init];
    backView.backgroundColor = UIColorFromRGB(0xd7dcdd);
    backView.image = [UIImage imageNamed:@"block_test2_3"];
    [self.contentView addSubview:backView];
    
    UIButton *secrectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button = secrectButton;
    secrectButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [secrectButton setTitleColor:UIColorFromRGB(0x505050) forState:UIControlStateNormal];
    [secrectButton setBackgroundImage:[UIImage imageNamed:@"btn_test2_white2"] forState:UIControlStateNormal];
    [backView addSubview:secrectButton];
    
    CGFloat margion = 20;
    CGFloat height = 29;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
    }];
    [secrectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_left).offset(margion);
        make.right.equalTo(backView.mas_right).offset(-margion);
        make.height.equalTo(@(height));
    }];
}

- (void)setSecrect:(NSString *)string {
    [self setupChildView];
    [self.button setTitle:string forState:UIControlStateNormal];
}

@end
