//
//  BallDisplayView.m
//  Muse
//
//  Created by paycloud110 on 16/7/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "BallDisplayView.h"

@interface BallDisplayView ()

@end

@implementation BallDisplayView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title content:(NSString *)content {
    if (self = [super initWithFrame:frame]) {
        [self setupViewWithTitle:title content:content];
    }
    return self;
}

- (void)setupViewWithTitle:(NSString *)title content:(NSString *)content {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.font = [UIFont systemFontOfSize:16];
    topLabel.textColor = UIColorFromRGB(0x333333);
    topLabel.text = title;
    topLabel.numberOfLines = 0;
    topLabel.width = 300 - 20;
    [topLabel sizeToFit];
    [backView addSubview:topLabel];
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = UIColorFromRGB(0x333333);
    [backView addSubview:topLineView];
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.showsHorizontalScrollIndicator= NO;
    [backView addSubview:contentScrollView];
    
    UIView *contentView = [[UIView alloc] init];
    [contentScrollView addSubview:contentView];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = content;
    contentLabel.textColor = UIColorFromRGB(0x333333);
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 0;
    contentLabel.width = 300 - 20 - 20;
    [contentLabel sizeToFit];
    [contentView addSubview:contentLabel];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(10);
        make.centerX.equalTo(backView.mas_centerX);
        make.width.equalTo(@(topLabel.width));
        make.height.equalTo(@(topLabel.height));
    }];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom).offset(10);
        make.left.equalTo(backView.mas_left).offset(0);
        make.right.equalTo(backView.mas_right).offset(0);
        make.height.equalTo(@(1));
    }];
    [contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineView.mas_bottom).offset(0);
        make.left.equalTo(backView.mas_left).offset(0);
        make.right.equalTo(backView.mas_right).offset(0);
        make.bottom.equalTo(backView.mas_bottom).offset(0);
    }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentScrollView);
        make.bottom.equalTo(contentLabel.mas_bottom).offset(20);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(15);
        make.left.equalTo(contentView.mas_left).offset(20);
        make.width.equalTo(@(contentLabel.width));
        make.height.equalTo(@(contentLabel.height));
    }];
    
    self.backgroundColor =  [UIColor yellowColor];
}

- (void)show {
    
    BallWindow *ballWindow = [[BallWindow shareBallWindow] showBottomDisplayView];
    [ballWindow addSubview:self];
}

@end
