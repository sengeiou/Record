//
//  UpdateVersonViewController.m
//  Muse
//
//  Created by songbaoqiang on 16/8/19.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "UpdateVersonViewController.h"

@interface UpdateVersonViewController ()

@end

@implementation UpdateVersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    [self setupUI];
    
}
- (void)setupUI {
    UIView *maskView = [[UIView alloc]init];
    [self.view addSubview:maskView];
    maskView.backgroundColor = UIColorFromRGB(0x000000);
    maskView.alpha = 0.1;
    //[self.view setMaskView:maskView];
    maskView.frame = [UIScreen mainScreen].bounds;
    
    
    
    UIView *contentView = [[UIView alloc]init];
    [self.view addSubview:contentView];
    contentView.bounds = CGRectMake(0, 0, 1040 / 3, 770 / 3);
    contentView.center = self.view.center;
    contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    CGFloat contentViewW = contentView.bounds.size.width;
    
    UILabel *titleLable = [[UILabel alloc]init];
    [contentView addSubview:titleLable];
    titleLable.text = @"MuseHeart v1.2.0";
    titleLable.frame = CGRectMake(0, 0, contentViewW, 181 / 3);
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = UIColorFromRGB(0x282828);
    titleLable.font = [UIFont systemFontOfSize:20];
    
    UIView *seperatorLine = [[UIView alloc]init];
    [contentView addSubview:seperatorLine];
    seperatorLine.frame = CGRectMake( 0, 181 / 3 , contentViewW, 1);
    seperatorLine.backgroundColor = UIColorFromRGB(0xc8c8c8);
    
    UILabel *firstLable = [[UILabel alloc]init];
    [contentView addSubview:firstLable];
    firstLable.text = @"1. 修正了部分Bug，";
    firstLable.font = [UIFont systemFontOfSize:16];
    [firstLable sizeToFit];
    firstLable.frame = CGRectMake(80 / 3 , (181 + 50) / 3 + 1 , contentViewW, firstLable.frame.size.height);
    firstLable.textColor = UIColorFromRGB(0x282828);
    
    
    UILabel *secondLable = [[UILabel alloc]init];
    [contentView addSubview:secondLable];
    secondLable.text = @"2. 优化了测试心率功能，";
    secondLable.font = [UIFont systemFontOfSize:16];
    [secondLable sizeToFit];
    secondLable.frame = CGRectMake(80 / 3 , CGRectGetMaxY(firstLable.frame) + 26 / 3, contentViewW, secondLable.frame.size.height);
    secondLable.textColor = UIColorFromRGB(0x282828);
    
    
    UILabel *thirdLable = [[UILabel alloc]init];
    [contentView addSubview:thirdLable];
    thirdLable.text = @"3. 更改了测试睡眠的检测算法。";
    thirdLable.font = [UIFont systemFontOfSize:16];
    [thirdLable sizeToFit];
    thirdLable.frame = CGRectMake(80 / 3 , CGRectGetMaxY(secondLable.frame) + 26 / 3, contentViewW, thirdLable.frame.size.height);
    thirdLable.textColor = UIColorFromRGB(0x282828);
    
    UIView *secondSeperatorLine = [[UIView alloc]init];
    [contentView addSubview:secondSeperatorLine];
    secondSeperatorLine.frame = CGRectMake( 0, contentView.frame.size.height - 170 / 3 - 1 , contentViewW, 1);
    secondSeperatorLine.backgroundColor = UIColorFromRGB(0xc8c8c8);
    
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:firstBtn];
    firstBtn.frame = CGRectMake(0, contentView.frame.size.height - 170 / 3, 520 / 3, 170 / 3);
    [firstBtn setTitle:@"暂不升级" forState:UIControlStateNormal];
    [firstBtn setTitleColor:UIColorFromRGB(0x282828) forState:UIControlStateNormal];
    [firstBtn setTitleColor:UIColorFromRGB(0x969696) forState:UIControlStateSelected];
    firstBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:2];
    [firstBtn addTarget:self action:@selector(clickNotUpdate:) forControlEvents:UIControlEventTouchUpInside];
    [firstBtn addTarget:self action:@selector(setHeightBackgroundcolor:) forControlEvents:UIControlEventTouchDown];
    firstBtn.tag = 1;

    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:secondBtn];
    secondBtn.frame = CGRectMake(520 / 3, contentView.frame.size.height - 170 / 3, 520 / 3, 170 / 3);
    [secondBtn setTitle:@"马上升级" forState:UIControlStateNormal];
    [secondBtn setTitleColor:UIColorFromRGB(0x282828) forState:UIControlStateNormal];
    [secondBtn setTitleColor:UIColorFromRGB(0x969696) forState:UIControlStateSelected];
    secondBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:3];
    [secondBtn addTarget:self action:@selector(clickUpdate:) forControlEvents:UIControlEventTouchUpInside];
    [secondBtn addTarget:self action:@selector(setHeightBackgroundcolor:) forControlEvents:UIControlEventTouchDown];
    secondBtn.tag = 2;
    
    
    

    
    
    
    
}

- (void)setHeightBackgroundcolor:(UIButton *)btn {
    btn.backgroundColor = UIColorFromRGB(0xDCDCDC);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickNotUpdate:(UIButton *)btn {
    btn.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
}
- (void)clickUpdate:(UIButton *)btn {
     btn.backgroundColor = UIColorFromRGB(0xFFFFFF);
}
@end
