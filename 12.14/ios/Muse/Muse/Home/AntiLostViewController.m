//
//  AntiLostViewController.m
//  Muse
//
//  Created by Ken.Jiang on 16/7/19.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "AntiLostViewController.h"

#import "SettingHeaderBar.h"

#import "BlueToothHelper.h"

#import "AppDelegate.h"
//#import "BluetoothHelper.h"

@interface AntiLostViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (weak, nonatomic) IBOutlet UIButton *enableButton;
@property (weak, nonatomic) IBOutlet UIButton *disableButton;

@end

@implementation AntiLostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundImage = nil;
    
    [SettingHeaderBar addHeaderBarToController:self withType:SettingHeaderBarAntiLost];
//    _promptLabel.text = @"当手机离开戒指一定范围，设备之间连接的蓝牙将自动断开，戒指将发出连续三次的震动以示提醒。\n\n点击开启／关闭随时开启或关闭防丢功能。";
    
    _titleLbl.text = NSLocalizedString(@"phone_tracker", nil);

    _promptLabel.text = NSLocalizedString(@"phone_tracker2", nil);
    
    //TODO: save Settings
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:USERLOSTSTATE] boolValue] == YES) {
        _enableButton.enabled = NO;
        _disableButton.enabled = YES;
    } else {
        _enableButton.enabled = YES;
        _disableButton.enabled = NO;
    }
    
    
    [_enableButton setTitle:NSLocalizedString(@"turnOn", nil) forState:UIControlStateNormal];
    [_disableButton setTitle:NSLocalizedString(@"turnOff", nil) forState:UIControlStateNormal];

}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - Action

- (IBAction)changeAntiLostSetting:(UIButton *)sender {
    
    sender.enabled = NO;
    if (sender.tag == 0) { //enable anti lost
        _disableButton.enabled = YES;
       
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USERLOSTSTATE];
        [[BlueToothHelper sharedInstance] setMuse:BLESettingsDisconnect enable:YES];
        
    } else {
        
        _enableButton.enabled = YES;
        
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:USERLOSTSTATE];
        [[BlueToothHelper sharedInstance] setMuse:BLESettingsDisconnect enable:NO];
   
    }
  
    
}
@end
