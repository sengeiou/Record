//
//  MSDetailViewController.h
//  Muse
//
//  Created by Ken.Jiang on 31/5/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "MSViewController.h"
//#import "HomeViewTableViewCell.h"
#import "HeartProgressView.h"

@interface MSDetailViewController : MSViewController

/**
 *  圆形进度条容器View
 */
@property (weak, nonatomic) IBOutlet UIView *detailContainer;
@property (strong, nonatomic) HeartProgressView *detailProgressView;
@property (weak, nonatomic) IBOutlet UIButton *detailCenterButton;
@property IBOutlet UILabel *bottomCenterLbl;

/**
 *  数据展示容器View
 */
@property (weak, nonatomic) IBOutlet UIView *dataContainer;


- (IBAction)backToHome:(UIButton *)sender;

/**
 *  进入公众号
 *
 *  @param sender Button
 */
- (IBAction)gotoPublic:(UIButton *)sender;

- (IBAction)share:(UIButton *)sender;

@end
