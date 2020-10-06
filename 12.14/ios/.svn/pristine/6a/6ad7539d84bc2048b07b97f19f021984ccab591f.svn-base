//
//  StepViewController.m
//  Muse
//
//  Created by Ken.Jiang on 31/5/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "StepViewController.h"

@interface StepViewController ()

@end

@implementation StepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupHeaderView:ControllerHeaderTypeWalk];
    self.detailProgressView.cellData = @{@"unit":NSLocalizedString(@"步", nil),
                                         @"progess":@0.5f,
                                         @"bottomContent":@"5.7公里｜345.1千卡"};
    [self.detailCenterButton setImage:[UIImage imageNamed:@"btn_secondarypage_steps"]
                             forState:UIControlStateNormal];
//    [self.detailCenterButton setTitle:@"晒步"
//                             forState:UIControlStateNormal];
    [self.detailCenterButton addTarget:self action:@selector(shareSteps:)
                      forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)shareSteps:(id)sender {
    
}

@end
