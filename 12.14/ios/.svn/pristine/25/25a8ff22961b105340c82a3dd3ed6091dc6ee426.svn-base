//
//  ClockSettingViewController.m
//  Muse
//
//  Created by Ken.Jiang on 16/7/19.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "ClockSettingViewController.h"
#import "SettingHeaderBar.h"
#import "ClockSettingView.h"

#import "AppDelegate.h"
#import "UIColor+FastKit.h"

@interface ClockSettingViewController ()

@end

@implementation ClockSettingViewController


- (void)loadView {
    self.view = [UIView new];
    
    [SettingHeaderBar addHeaderBarToController:self withType:SettingHeaderBarClock];
    ClockSettingView *settingView = [ClockSettingView viewFromNib];
    settingView.tableView.backgroundColor = UIColorHex(0xEFEFEF);
    settingView.fullMode = YES;
    [self.view addSubview:settingView];
    [settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@108);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImage = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
