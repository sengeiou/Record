//
//  FloatingBallWindowViewController.m
//  Muse
//
//  Created by paycloud110 on 16/7/2.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "FloatingBallWindowViewController.h"
#import "ContentBackView.h"
#import "ContentButton.h"

@interface FloatingBallWindowViewController ()

/**  */
@property (nonatomic, strong) UITableView *friendTableView;
/**  */
@property (nonatomic, strong) UITableView *addFriendTableView;
/**  */
@property (nonatomic, strong) UITableView *secretTableView;
/**  */
@property (nonatomic, weak) UIView *backView;
/**  */
@property (nonatomic, weak) ContentBackView *topBackView;
/**  */
@property (nonatomic, weak) UILabel *topLabel;
/**  */
@property (nonatomic, weak) UIImageView *leftImageView;
/**  */
@property (nonatomic, weak) ContentButton *friendButton;
/**  */
@property (nonatomic, weak) ContentButton *addFriendButton;
/**  */
@property (nonatomic, weak) ContentButton *secrectButton;
/**  */
@property (nonatomic, weak) UIView *bottomAddView;
/**  */
@property (nonatomic, weak) ContentButton *addFlagButton;

@end

@implementation FloatingBallWindowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorWithBlackGreen;
    [self setupViewController];
}
- (void)setupViewController
{
    UIView *backView = [[UIView alloc] init];
    self.backView = backView;
    [self.view addSubview:backView];
    
    ContentBackView *topBackView = [[ContentBackView alloc] initWhetherBottomView:YES];
    self.topBackView = topBackView;
    [backView addSubview:topBackView];
    
    UILabel *topLabel = [[UILabel alloc] init];
    self.topLabel = topLabel;
    topLabel.textColor = UIColorFromRGB(0x505050);
    topLabel.font = [UIFont systemFontOfSize:16];
    topLabel.text = @"亲友健康状态";
    [topLabel sizeToFit];
    [backView addSubview:topLabel];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_test2_2"]];
    self.leftImageView = leftImageView;
    leftImageView.userInteractionEnabled = YES;
    leftImageView.backgroundColor = ColorWithLightBrown;
    [backView addSubview:leftImageView];
    
    ContentButton *friendButton = [[ContentButton alloc] initWithImageName:@"btn_test2_friend"];
    self.friendButton = friendButton;
    friendButton.backgroundColor = ColorWithLightBrown;
    [leftImageView addSubview:friendButton];
    
    ContentButton *addFriendButton = [[ContentButton alloc] initWithImageName:@"btn_test2_message"];
    self.addFriendButton = addFriendButton;
    addFriendButton.backgroundColor = ColorWithGrassGreen;
    [leftImageView addSubview:addFriendButton];
    
    ContentButton *secrectButton = [[ContentButton alloc] initWithImageName:@"btn_test2_sweet"];
    self.secrectButton = secrectButton;
    secrectButton.backgroundColor = ColorWithBlackGreen;
    [leftImageView addSubview:secrectButton];
    
    UIView *bottomAddView = [[UIView alloc] init];
    self.bottomAddView = bottomAddView;
    bottomAddView.backgroundColor = UIColorFromRGB(0xc5cccf);
    [backView addSubview:bottomAddView];
    
    ContentButton *addFlagButton = [ContentButton buttonWithType:UIButtonTypeCustom];
    [addFlagButton setImage:[UIImage imageNamed:@"btn_test2_plus"] forState:UIControlStateNormal];
    self.addFlagButton = addFlagButton;
    [bottomAddView addSubview:addFlagButton];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    /** top */
    [self.topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top);
        make.left.equalTo(self.backView.mas_left);
        make.height.equalTo(@(67));
        make.right.equalTo(self.backView.mas_right);
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBackView.mas_centerY);
        make.left.equalTo(self.topBackView.mas_left).offset(14);
        make.right.equalTo(self.topBackView.mas_right);
        make.height.equalTo(@(self.topLabel.height));
    }];
    /** left */
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBackView.mas_bottom);
        make.left.equalTo(self.backView.mas_left);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.width.equalTo(@(74));
    }];
    [self.friendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImageView.mas_top);
        make.left.equalTo(self.leftImageView.mas_left);
        make.right.equalTo(self.leftImageView.mas_right);
        make.height.equalTo(@(67));
    }];
    [self.addFriendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.friendButton.mas_bottom);
        make.left.equalTo(self.leftImageView.mas_left);
        make.right.equalTo(self.leftImageView.mas_right);
        make.height.equalTo(@(67));
    }];
    [self.secrectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addFriendButton.mas_bottom);
        make.left.equalTo(self.leftImageView.mas_left);
        make.right.equalTo(self.leftImageView.mas_right);
        make.height.equalTo(@(67));
    }];
    /** bottom */
    [self.bottomAddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.right.equalTo(self.backView.mas_right);
        make.height.equalTo(@(59));
    }];
    [self.addFlagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomAddView.mas_centerX);
        make.centerY.equalTo(self.bottomAddView.mas_centerY);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
}
#pragma mark --<layz>
- (UITableView *)friendTableView
{
    if (_friendTableView == nil) {
        _friendTableView = [[UITableView alloc] init];
    }
    return _friendTableView;
}
- (UITableView *)addFriendTableView
{
    if (_addFriendTableView == nil) {
        _addFriendTableView = [[UITableView alloc] init];
    }
    return _friendTableView;
}
- (UITableView *)secretTableView
{
    if (_secretTableView == nil) {
        _secretTableView = [[UITableView alloc] init];
    }
    return _secretTableView;
}
@end
