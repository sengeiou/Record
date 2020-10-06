//
//  MSViewController.m
//  Muse
//
//  Created by jiangqin on 16/4/14.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSViewController.h"
#import "UIViewController+MethodSwizzlingForPanBack.h"
#import "AppDelegate.h"

@implementation MSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundImage:[UIImage imageNamed:@"block_homepage_1"]];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if ([_backgroundImage isEqual:backgroundImage]) {
        return;
    }
    
    _backgroundImage = backgroundImage;
    self.view.layer.contentsGravity = @"resizeAspectFill";
    self.view.layer.contents = (id)[backgroundImage CGImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_headerView updateView];
}

#pragma mark - Public

- (void)setupHeaderView:(ControllerHeaderType)type {
    if (!_headerView) {
        _headerView = [ControllerHeaderView controllerHeaderViewType:type];
        [self.view addSubview:_headerView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.height.equalTo(@([ControllerHeaderView headViewHeight]));
        }];
        
        [_headerView.backButton addTarget:self
                                   action:@selector(backToLastController:)
                         forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_headerView resetType:type];
    }
}

- (void)backToLastController:(id)sender
{
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            if ([AppDelegate appDelegate].window.rootViewController != self.navigationController) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
