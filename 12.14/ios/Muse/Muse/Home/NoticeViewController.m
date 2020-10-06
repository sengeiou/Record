//
//  NoticeViewController.m
//  Muse
//
//  Created by Ken.Jiang on 16/7/18.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "NoticeViewController.h"
#import "SettingHeaderBar.h"

#import "AppDelegate.h"
#import "BluetoothHelper.h"


@interface NoticeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *noticeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property IBOutlet UILabel *titleLbl;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundImage = nil;
    
    [SettingHeaderBar addHeaderBarToController:self withType:SettingHeaderBarNotice];
    
 
    
    if ([[kUserDefaults objectForKey:MonitorCallEvent] boolValue] == YES) {
        
       [self.noticeSwitch setImage:[UIImage imageNamed:@"btn_clocktest_switch_on"] forState:UIControlStateNormal];
//        
    } else {
        [self.noticeSwitch setImage:[UIImage imageNamed:@"btn_clocktest_switch_off"] forState:UIControlStateNormal];
    }

    
    _titleLbl.text = NSLocalizedString(@"tel_notice", nil);
     _promptLabel.text = NSLocalizedString(@"tel_notice2", nil);
}

//- (void)viewWillLayoutSubviews {
//    
//        // [self.noticeSwitch setImage:[UIImage imageNamed:@"btn_clocktest_switch_on"] forState:UIControlStateNormal];
//    
//    MSLog(@"%d",self.noticeSwitch.selected);
//    
//
//}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
 
    
}

#pragma mark - Action
- (IBAction)switchNotice:(id)sender {
    
//    [[BlueToothHelper sharedInstance] monitorPhoneCall:!button.selected];
    
//    [kUserDefaults setBool:button.selected forKey:@"isSelectted"];

    
    if ([[kUserDefaults objectForKey:MonitorCallEvent] boolValue] == YES) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MonitorCallEvent];

        [self.noticeSwitch setImage:[UIImage imageNamed:@"btn_clocktest_switch_off"] forState:UIControlStateNormal];
        //
        
        
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MonitorCallEvent];

        [self.noticeSwitch setImage:[UIImage imageNamed:@"btn_clocktest_switch_on"] forState:UIControlStateNormal];
    }
}


@end
