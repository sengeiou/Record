//
//  LCSOSViewController.m
//  Muse
//
//  Created by songbaoqiang on 16/8/20.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SecretTalkViewController.h"

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
#import "BlueToothHelper.h"

@interface SecretTalkViewController ()<UITextFieldDelegate,AddFriendViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendMessageLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactsButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *contactsView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSMutableArray *secretTalkContacts;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UITextField *filed;
@property (nonatomic, strong) FloatingBallWindowViewController *ballWindow;

@property (strong, nonatomic) NSMutableArray *friendContacts;
/**  */



@end

@implementation SecretTalkViewController
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
    
    [_sendMessageLable setTitle:NSLocalizedString(@"mbtn1", nil) forState:UIControlStateNormal];
    [_contactsButton setTitle:NSLocalizedString(@"mbtn2", nil) forState:UIControlStateNormal];

    self.promptLabel.textColor = UIColorFromRGB(0x808080);
    
    NSString *message = [[NSUserDefaults standardUserDefaults] objectForKey:MiNiMessageKey];
    if (message.length == 0) {
        [self.sendMessageLable setTitle:NSLocalizedString(@"mbtn1", nil) forState:UIControlStateNormal];
    }else {
        [self.sendMessageLable setTitle:message forState:UIControlStateNormal];
    }
    
    self.scrollView.backgroundColor = UIColorFromRGB(0xEFEFEF);
    self.backgroundImage = nil;
    
    [SettingHeaderBar addHeaderBarToController:self withType:SettingHeaderBarSecretTalk];
    
    
    _titleLbl.text = NSLocalizedString(@"one_key_sweet_title", nil);
    _promptLabel.text = NSLocalizedString(@"one_key_sweet_text", nil);
    [self loadSecretTalkContacts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickView)];
    [self.contactsView addGestureRecognizer:tap];
  //  self.contactsView.userInteractionEnabled = YES;
    
    
    [self refreshLocationBtnState]; // 刷新位置按钮状态
    self.locationLbl.text = NSLocalizedString(@"locationLbl", nil);

}
- (void)ClickView {
    
//  NSArray *views =  [self.contactsView subviews];
    
    
    
   
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self saveSecretTalkContacts];
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
#pragma mark --<点击编辑蜜语>
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
        if (textField.text.length > 200) {
            textField.text = [textField.text substringToIndex:200];
            [MBProgressHUD showMessage:NSLocalizedString(@"inputMax200", nil) toView:self.scrollView hideAfterDelay:0.5];
        }
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:MiNiMessageKey];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.text.length == 0 ) {
        [self.sendMessageLable setTitle:NSLocalizedString(@"customMiContent", nil) forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:MiNiMessageKey];
    }
    
    
}
#pragma mark - Actions
- (IBAction)clickPlus:(UIButton *)sender
{
    [self loadSecretTalkContacts];
    // 添加亲友
    AddressBookController *vc = [[AddressBookController alloc] initWithNibName:@"AddressBookController" bundle:nil]; 
    vc.persons = _secretTalkContacts;
    vc.limitedCount = 99;
    vc.isShowMuseUser = YES;
    [vc setCompletionBlock:^(NSMutableArray<AddressPerson *> *persons) {
        [self AddFriendViewController:nil friendModelArray:persons];
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark -- AddFriendViewController
-(void)AddFriendViewController:(UIViewController *)vc friendModelArray:(NSMutableArray *)friendModelArray
{
    [LCSOSHandler saveSecretTalkContacts:friendModelArray];
    if (friendModelArray.count == 0) {
        [self.contactsButton setTitle:NSLocalizedString(@"btn1", nil) forState:UIControlStateNormal];
    }else {
        [self.contactsButton setTitle:@"" forState:UIControlStateNormal];
        NSArray *icons = _contactsView.subviews;
        [icons makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIImage *icon = [UIImage imageNamed:@"icon_homepage2_people"];
        
        CGFloat padding = 12;
        CGFloat iconWidth = icon.size.width;
        CGFloat contentWidth = iconWidth * (friendModelArray.count > 5 ? 5 : friendModelArray.count) + padding * ((friendModelArray.count > 5 ? 5 : friendModelArray.count) - 1);
        CGFloat x = (_contactsView.width - contentWidth)/2;
        CGFloat y = (_contactsView.height - icon.size.height)/2;
        for (int i = 0; i < (friendModelArray.count > 5 ? 5 : friendModelArray.count); i++) {
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
    CGFloat contentWidth = iconWidth * ((_secretTalkContacts.count > 5) ? 5 : _secretTalkContacts.count) + padding * (((_secretTalkContacts.count > 5) ? 5 : _secretTalkContacts.count) - 1);
    CGFloat x = (_contactsView.width - contentWidth)/2;
    CGFloat y = (_contactsView.height - icon.size.height)/2;
    for (int i = 0; i < ((_secretTalkContacts.count > 5) ? 5 : _secretTalkContacts.count) ; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
        imageView.frame = CGRectMake(x, y, icon.size.width, icon.size.height);
        [_contactsView addSubview:imageView];
        x += (iconWidth + padding);
    }
}
#pragma mark --  实现删除亲友功能按钮
- (IBAction)showPersons:(id)sender {
    
    
    
    
    [self loadSecretTalkContacts];
    if (_secretTalkContacts.count) {
    
        __weak typeof(self)weakSelf = self;
        PairPopView *pop = [PairPopView viewFromNibByVc:self peopleArr:_secretTalkContacts];
        [pop setCompletionBlock:^(NSMutableArray *persons) {
            weakSelf.secretTalkContacts = persons;
            [LCSOSHandler saveSecretTalkContacts:weakSelf.secretTalkContacts];
            [weakSelf updateContactsButton];
        }];
        [pop show];
    }else {
    //    [self loadSecretTalkContacts];
        // 添加亲友
        AddressBookController *vc = [[AddressBookController alloc] initWithNibName:@"AddressBookController" bundle:nil];
        vc.persons = _secretTalkContacts;
        vc.limitedCount = 99;
        vc.isShowMuseUser = YES;
        [vc setCompletionBlock:^(NSMutableArray<AddressPerson *> *persons) {
            [self AddFriendViewController:nil friendModelArray:persons];
        }];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];

    }
}
#pragma mark - 存储数据
- (void)loadSecretTalkContacts {
    NSArray *secretTalkContacts = [LCSOSHandler loadSecretTalkContacts];
    if (secretTalkContacts) {
        _secretTalkContacts = [secretTalkContacts mutableCopy];
    } else {
        _secretTalkContacts = [NSMutableArray arrayWithCapacity:3];
    }
}
- (void)saveSecretTalkContacts {
    
    [LCSOSHandler saveSecretTalkContacts:_secretTalkContacts];
}

- (void)rebuildContactsIcon
{
    NSArray *icons = _contactsView.subviews;
    [icons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImage *icon = [UIImage imageNamed:@"icon_homepage2_people"];
    CGFloat padding = 12;
    CGFloat iconWidth = icon.size.width;
    CGFloat contentWidth = iconWidth * ((_secretTalkContacts.count > 5) ? 5 : _secretTalkContacts.count) + padding * (((_secretTalkContacts.count > 5) ? 5 : _secretTalkContacts.count) - 1);
    CGFloat x = (_contactsView.width - contentWidth) / 2;
    CGFloat y = (_contactsView.height - icon.size.height) / 2;
    for (NSInteger i = 0; i < ((_secretTalkContacts.count > 5) ? 5 : _secretTalkContacts.count); i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
        imageView.frame = CGRectMake(x, y, icon.size.width, icon.size.height);
        [_contactsView addSubview:imageView];
        x += (iconWidth + padding);
    }
    
}

- (void)updateContactsButton
{
    _secretTalkContacts = [[LCSOSHandler loadSecretTalkContacts] mutableCopy];
    if (_secretTalkContacts.count) {
        [_contactsButton setTitle:nil forState:UIControlStateNormal];
    } else {
        [_contactsButton setTitle:NSLocalizedString(@"mbtn2", nil) forState:UIControlStateNormal];
    }
    [self rebuildContactsIcon];
}
- (BOOL)judgeWhetherFriend
{
    self.friendContacts = [[DBManager sharedManager] getUserFriendListfromDB];
    if (self.friendContacts.count == 0) {
        return NO;
    }else {
        AddressPerson *person = self.secretTalkContacts.firstObject;
        for (NSDictionary *list in self.friendContacts) {
            NSString *phone = list[@"phone"];
            if ([person.phone isEqualToString:phone]) {
                return YES;
            }
        }
        return NO;
    }
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



#pragma mark - LOCATION BUTTON

- (IBAction)locationBtnAction:(UIButton *)btn {
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:USERMILOCATIONSTATE] boolValue] == YES) {
        [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:USERMILOCATIONSTATE];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:USERMILOCATIONSTATE];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self refreshLocationBtnState];
}

- (void)refreshLocationBtnState {
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:USERMILOCATIONSTATE] boolValue] == YES) {
        [_locationBtn setImage:[UIImage imageNamed:@"btn_clocktest_switch_on"] forState:UIControlStateNormal];
    } else {
        [_locationBtn setImage:[UIImage imageNamed:@"btn_clocktest_switch_off"] forState:UIControlStateNormal];
    }
}

@end
