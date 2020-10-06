//
//  LCSOSViewController.m
//  Muse
//
//  Created by songbaoqiang on 16/8/20.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "LCSOSViewController.h"

#import "SettingHeaderBar.h"
#import "PairPopView.h"

#import "AppDelegate.h"
#import "NSFileManager+FastKit.h"
#import "LCSOSHandler.h"
#import "FloatingBallWindowViewController.h"
#import "AddFriendViewController.h"
#import <MBProgressHUD.h>
#import "MJExtension.h"
#import "AddressBookController.h"

#import "LocationServer.h"

#define MiNiMessageContentKey @"MiNiMessageContentKey"

@interface LCSOSViewController ()<UITextFieldDelegate,AddFriendViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendMessageLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactsButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *contactsView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSMutableArray *emergencyContacts;
@property (nonatomic, strong)  UIImageView *imageV ;
@property (nonatomic, strong)  UITextField *filed ;
@property (nonatomic, strong) FloatingBallWindowViewController *ballWindow;

//@property (strong, nonatomic) NSMutableArray *emergencyContacts;

@end

@implementation LCSOSViewController
- (UIImageView *)imageV {
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_homepage2_1_enter"]];
    }
    return _imageV;
}

- (UITextField *)filed {
    if (_filed == nil) {
        _filed = [[UITextField alloc]init];
    }
    return _filed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.sendMessageLable setTitle:NSLocalizedString(@"sosbtn1", nil) forState:UIControlStateNormal];
    [self.contactsButton setTitle:NSLocalizedString(@"sosbtn2", nil) forState:UIControlStateNormal];
    
    self.promptLabel.textColor = UIColorFromRGB(0x808080);
    self.scrollView.backgroundColor = UIColorFromRGB(0xEFEFEF);
    self.backgroundImage = nil;
    
    NSString *message = [[NSUserDefaults standardUserDefaults] objectForKey:SOSMessageKey];
    
    LRLog(@"%@",message);
    
    if (message.length == 0) {
        [self.sendMessageLable setTitle:NSLocalizedString(@"sosbtn1", nil) forState:UIControlStateNormal];
    }else {
        [self.sendMessageLable setTitle:message forState:UIControlStateNormal];
    }
    
    [SettingHeaderBar addHeaderBarToController:self withType:SettingHeaderBarSOS];
    
    _titleLbl.text = NSLocalizedString(@"string_of_sos", nil);
    _promptLabel.text = NSLocalizedString(@"string_of_sos2", nil);

    
    [self loadEmergencyContacts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self saveEmergencyContacts];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [AppDelegate appDelegate].floatingWindow.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateContactsButton];
}
#pragma mark --<点击编辑短信>
- (IBAction)sendMessage:(UIButton *)sender
{
    sender.hidden = YES;
    self.imageV.frame = self.sendMessageLable.frame;
    [self.scrollView addSubview:self.imageV];
    
    self.filed.frame = CGRectMake(self.sendMessageLable.frame.origin.x + 10, self.sendMessageLable.frame.origin.y, self.sendMessageLable.width - 20, self.sendMessageLable.height);
    [self.scrollView addSubview:self.filed];
    [self.filed becomeFirstResponder];
    [self.filed addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.filed addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark -- textfiled
- (void)textFieldDidChange:(UITextField *)textField
{
    
   
    
    if (textField == self.filed) {
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
            [MBProgressHUD showMessage:NSLocalizedString(@"sos_max15word", nil) toView:self.scrollView hideAfterDelay:0.5];
        }
        
    //    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:MiNiMessageContentKey];
        
           [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:SOSMessageKey];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.text.length == 0 ) {
        [self.sendMessageLable setTitle:NSLocalizedString(@"customSosContent", nil) forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:SOSMessageKey];
    }
    
   
}
#pragma mark - Actions
- (IBAction)clickPlus:(UIButton *)sender
{
    [self loadEmergencyContacts];
    // 添加亲友
    AddressBookController *vc = [[AddressBookController alloc] initWithNibName:@"AddressBookController" bundle:nil];
    vc.persons = _emergencyContacts;
    vc.limitedCount = 3;
    vc.isShowMuseUser = NO;
    [vc setCompletionBlock:^(NSMutableArray<AddressPerson *> *persons) {
        [self AddFriendViewController:nil friendModelArray:persons];
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark -- AddFriendViewController
-(void)AddFriendViewController:(UIViewController *)vc friendModelArray:(NSMutableArray *)friendModelArray
{
    [LCSOSHandler saveEmergencyContacts:friendModelArray];
    
    if (friendModelArray.count == 0) {
        [self.contactsButton setTitle:NSLocalizedString(@"sosbtn2", nil) forState:UIControlStateNormal];
    }else {
        [self.contactsButton setTitle:@"" forState:UIControlStateNormal];
        NSArray *icons = _contactsView.subviews;
        [icons makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIImage *icon = [UIImage imageNamed:@"icon_homepage2_people"];
        
        CGFloat padding = 12;
        CGFloat iconWidth = icon.size.width;
        CGFloat contentWidth = iconWidth * friendModelArray.count + padding * (friendModelArray.count - 1);
        CGFloat x = (_contactsView.width - contentWidth)/2;
        CGFloat y = (_contactsView.height - icon.size.height)/2;
        for (int i = 0; i < friendModelArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
            CGRect frame = imageView.frame;
            frame.origin = CGPointMake(x, y);
            imageView.frame = frame;
            [_contactsView addSubview:imageView];
            
            x += (iconWidth + padding);
        }
    }
}

#pragma mark -- 设置联系人图标
- (void)rebuildContactIcon {
    //---------------------------------------------------
    NSArray *icons = _contactsView.subviews;
    [icons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImage *icon = [UIImage imageNamed:@"icon_homepage2_people"];
    
    CGFloat padding = 12;
    CGFloat iconWidth = icon.size.width;
    CGFloat contentWidth = iconWidth * _emergencyContacts.count + padding * (_emergencyContacts.count - 1);
    CGFloat x = (_contactsView.width - contentWidth)/2;
    CGFloat y = (_contactsView.height - icon.size.height)/2;
    for (int i = 0; i < _emergencyContacts.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
        CGRect frame = imageView.frame;
        frame.origin = CGPointMake(x, y);
        imageView.frame = frame;
        [_contactsView addSubview:imageView];
        
        x += (iconWidth + padding);
    }
}
#pragma mark --  实现删除亲友功能按钮
- (IBAction)showPersons:(id)sender {
    
    [self loadEmergencyContacts];
    if (_emergencyContacts.count) {
      
        __weak typeof(self)weakSelf = self;
        PairPopView *pop = [PairPopView viewFromNibByVc:self peopleArr:_emergencyContacts];
        [pop setCompletionBlock:^(NSMutableArray *persons) {
            weakSelf.emergencyContacts = persons;
            [LCSOSHandler saveEmergencyContacts:weakSelf.emergencyContacts];
            [weakSelf updateContactsButton];
        }];
        [pop show];
    }else {
       // [self loadSecretTalkContacts];
        // 添加亲友
        AddressBookController *vc = [[AddressBookController alloc] initWithNibName:@"AddressBookController" bundle:nil];
        vc.persons = _emergencyContacts;
        vc.limitedCount = 3;
        vc.isShowMuseUser = NO;
        [vc setCompletionBlock:^(NSMutableArray<AddressPerson *> *persons) {
            [self AddFriendViewController:nil friendModelArray:persons];
        }];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    }

}

#pragma mark - 存储数据
- (void)loadEmergencyContacts {
    NSArray *emergencyContacts = [LCSOSHandler loadEmergencyContacts];
    if (emergencyContacts) {
        _emergencyContacts = [emergencyContacts mutableCopy];
    } else {
        _emergencyContacts = [NSMutableArray arrayWithCapacity:3];
    }
}
- (void)saveEmergencyContacts {
    [LCSOSHandler saveEmergencyContacts:_emergencyContacts];
}

- (void)rebuildContactsIcon {
    NSArray *icons = _contactsView.subviews;
    [icons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImage *icon = [UIImage imageNamed:@"icon_homepage2_people"];
    
    CGFloat padding = 12;
    CGFloat iconWidth = icon.size.width;
    CGFloat contentWidth = iconWidth * _emergencyContacts.count + padding * (_emergencyContacts.count - 1);
    CGFloat x = (_contactsView.width - contentWidth)/2;
    CGFloat y = (_contactsView.height - icon.size.height)/2;
    for (int i = 0; i < _emergencyContacts.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
        imageView.frame = CGRectMake(x, y, icon.size.width, icon.size.height);
        [_contactsView addSubview:imageView];
        x += (iconWidth + padding);
    }
    
}

- (void)updateContactsButton {
    _emergencyContacts = [[LCSOSHandler loadEmergencyContacts] mutableCopy];
    if (_emergencyContacts.count) {
        [_contactsButton setTitle:nil forState:UIControlStateNormal];
    } else {
        [_contactsButton setTitle:NSLocalizedString(@"sosbtn2", nil) forState:UIControlStateNormal];
    }
    [self rebuildContactsIcon];
}
#pragma mark -- 监听键盘
-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (self.filed.text.length == 0) {
        self.sendMessageLable.hidden = NO;
        [self.filed endEditing:YES];
        _imageV.hidden = YES;
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    _imageV.hidden = NO;
}
@end
