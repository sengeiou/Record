//
//  AddSecrectTableViewCell.m
//  Muse
//
//  Created by paycloud110 on 16/7/7.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "AddSecrectTableViewCell.h"

@interface AddSecrectTableViewCell () {
    BOOL _setuped;
}

/**  */
@property (nonatomic, weak) UIView *backView;
/**  */
@property (nonatomic, weak) UIImageView *contentBackImageView;
/**  */
@property (nonatomic, weak) UIButton *stateButton;

@end

@implementation AddSecrectTableViewCell

- (void)setupChildView {
    if (_setuped) {
        return;
    }
    
    _setuped = YES;
    
    UIView *backView = [[UIView alloc] init];
    self.backView = backView;
    backView.backgroundColor = UIColorFromRGB(0xc5cccf);
    [self.contentView addSubview:backView];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    self.contentLabel = contentLabel;
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textColor = UIColorFromRGB(0x505050);
    [backView addSubview:contentLabel];
    
    UIButton *stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stateButton = stateButton;
    [stateButton setImage:[UIImage imageNamed:@"btn_test2_choose_off"] forState:UIControlStateNormal];
    [stateButton setImage:[UIImage imageNamed:@"btn_test2_choose_on"] forState:UIControlStateSelected];
    [stateButton addTarget:self action:@selector(stateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:stateButton];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.backView.mas_left).offset(26);
    }];
    [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.right.equalTo(self.backView.mas_right).offset(-15);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
}

/** 布局控件 */
- (void)setupData:(NSString *)secrectString stateButton:(BOOL)aBool {
    [self setupChildView];
    
    self.contentLabel.text = secrectString;
    self.stateButton.selected = aBool;
}

- (void)setAddSecrect:(AddSecrect *)addSecrect {
    _addSecrect = addSecrect;
    
    [self setupData:addSecrect.content stateButton:addSecrect.stateButton];
}

- (void)stateButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(addSecrectTableViewCell:withButton:)]) {
        [self.delegate addSecrectTableViewCell:self withButton:button];
    }
}
@end
