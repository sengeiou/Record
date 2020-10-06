//
//  HomeViewTableViewCell.h
//  Muse
//
//  Created by pg on 16/5/13.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DoubleProgressView.h"

#import "SpecialNumView.h"

@interface HomeViewTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *cellData;

@property (nonatomic, weak) IBOutlet UIImageView *bgIMV;
@property (nonatomic, weak) IBOutlet UIImageView *typeTopIMV;
//中间用放数字和绿心等View
@property (nonatomic, weak) IBOutlet SpecialNumView *dataLB;
@property (nonatomic, weak) IBOutlet UIImageView *unitIMV;
@property (nonatomic, weak) IBOutlet UIImageView *typeBottomIMV;
@property (nonatomic, weak) IBOutlet UILabel *bottomLB;

@property (nonatomic, strong) DoubleProgressView *progressView;

/**
 *  扩散动画效果View，默认hidden
 */
@property (weak, nonatomic) IBOutlet UIImageView *rippleView;
@property (weak, nonatomic) IBOutlet UIImageView *rippleCenterImageView;

/**
 *  控制进度圆的大小，默认196
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWidthConstraint;

/**
 *  底部图片距离圆形进度条的底部约束，默认 -46
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomImageConstraint;

/**
 *  底部Label距离圆形进度条的底部约束，默认 -70
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLabelConstraint;


+ (instancetype)cellFromNib;

/**
 *  隐藏／显示 细节views（如typeTopIMV，dataLB...等）
 *
 *  @param hide 隐藏／显示
 */
- (void)hideDetailViews:(BOOL)hide;

- (void)startHeartRipple;

- (void)stopHeartRipple;

@end
