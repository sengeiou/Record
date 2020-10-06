//
//  MorseViewController.m
//  Muse
//
//  Created by Ken.Jiang on 16/9/10.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MorseViewController.h"

#import "SettingHeaderBar.h"

#import "BlueToothHelper.h"

#import "LCSOSHandler.h"

#import "AddressBookController.h"

#import "PairPopView.h"

#import "SendMorseRequest.h"

@interface MorseViewController ()

@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *contentLbl;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;
@property (strong, nonatomic) IBOutlet UIButton *btn4;

@property (weak, nonatomic) IBOutlet UIButton *contactsButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *contactsView;

@property IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSMutableArray *morseContacts;


@property BOOL isSendingMorse;

@end

@implementation MorseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backView.backgroundColor = UIColorFromRGB(0xEFEFEF);
    self.backgroundImage = nil;
    [SettingHeaderBar addHeaderBarToController:self withType:SettingHeaderBarMorse];
    
    _titleLbl.text = NSLocalizedString(@"mosi_text_name", nil);
    _contentLbl.text = NSLocalizedString(@"mosi_text", nil);
    [_btn1 setTitle:NSLocalizedString(@"mosi_text_code1", nil) forState:UIControlStateNormal];
    [_btn2 setTitle:NSLocalizedString(@"mosi_text_code2", nil) forState:UIControlStateNormal];
    [_btn3 setTitle:NSLocalizedString(@"mosi_text_code3", nil) forState:UIControlStateNormal];
    [_btn4 setTitle:NSLocalizedString(@"mosi_text_code4", nil) forState:UIControlStateNormal];
    
    
    
    [self loadMorseContacts];
    
    [self.contactsButton setTitle:NSLocalizedString(@"morseConbtn", nil) forState:UIControlStateNormal];

}

- (void)viewDidLayoutSubviews {
    [_scrollView setContentSize:CGSizeMake(kScreenWidth, 550)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self saveMorseContacts];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateContactsButton];
}

#pragma mark - Actions
- (IBAction)sendMorseCode:(UIButton *)sender {
    
    if (_isSendingMorse == YES) {
        [MBProgressHUD showMessage:NSLocalizedString(@"morseSending", nil) toView:self.view hideAfterDelay:1];
        return;
    } else {
        

        _isSendingMorse = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isSendingMorse = NO;
        });
    }
    
    
  //  [[BlueToothHelper sharedInstance] vibrateWithDuration:1 interval:1 times:2];
    //红 蓝 绿 绿

//    dispatch_queue_t newQue = dispatch_queue_create("开新线程发送摩斯密码", DISPATCH_QUEUE_CONCURRENT);
    
//    dispatch_async(newQue, ^{
    
    [BlueToothHelper sharedInstance].sendingMorseCode = NO;
    [[BlueToothHelper sharedInstance] sendMorseCode:sender.tag withCompletion:^{
        [MBProgressHUD showMessage:NSLocalizedString(@"morseSended", nil) toView:self.view hideAfterDelay:1];

    }];
    
    
    NSArray *morseContactArray = [[LCSOSHandler loadMorseContacts] mutableCopy];

    if (morseContactArray.count == 0) {
        MSLog(@"没有需要发送的对象");
    }else {
        
        NSMutableString *phones = [[NSMutableString alloc] init];
        
        
        if (morseContactArray.count == 1) {
            AddressPerson *person = [morseContactArray firstObject];
            phones = [[phones stringByAppendingString:[NSString stringWithFormat:@"%@", person.phone]] mutableCopy];
        } else {
            for (AddressPerson *person in morseContactArray) {
                
                phones = [[phones stringByAppendingString:[NSString stringWithFormat:@"%@,", person.phone]] mutableCopy];
                
            }
            NSString *str = [phones substringToIndex:phones.length - 1];
            [phones setString:str];
        }
        
        NSString *morseStr = [NSString stringWithFormat:@"mosi_text_code%ld", 1 + sender.tag];
        
        [SendMorseRequest startWithUserID:phones sendMessage:[NSString stringWithFormat:@"\"%@\"%@\"%@\"", [MuseUser currentUser].phone, NSLocalizedString(@"morseCenterText", nil), NSLocalizedString(morseStr, nil)] type:[NSString stringWithFormat:@"%ld", 300 + sender.tag] completionBlockSuccess:^(NSDictionary *responseObject) {
            
        } failure:^(NSDictionary *responseObject) {
            
        }];

    }
}

#pragma mark - Actions
- (IBAction)clickPlus:(UIButton *)sender
{
    [self loadMorseContacts];
    // 添加亲友
    AddressBookController *vc = [[AddressBookController alloc] initWithNibName:@"AddressBookController" bundle:nil];
    vc.persons = _morseContacts;
//    vc.limitedCount = 3;
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
    [LCSOSHandler saveMorseContacts:friendModelArray];
    
    if (friendModelArray.count == 0) {
        [self.contactsButton setTitle:NSLocalizedString(@"morseConBtn", nil) forState:UIControlStateNormal];
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
    CGFloat contentWidth = iconWidth * ((_morseContacts.count > 5) ? 5 : _morseContacts.count) + padding * (((_morseContacts.count > 5) ? 5 : _morseContacts.count) - 1);
    CGFloat x = (_contactsView.width - contentWidth)/2;
    CGFloat y = (_contactsView.height - icon.size.height)/2;
    for (int i = 0; i < ((_morseContacts.count > 5) ? 5 : _morseContacts.count) ; i++) {
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
    
    [self loadMorseContacts];
    if (_morseContacts.count) {
        
        __weak typeof(self)weakSelf = self;
        PairPopView *pop = [PairPopView viewFromNibByVc:self peopleArr:_morseContacts];
        [pop setCompletionBlock:^(NSMutableArray *persons) {
            weakSelf.morseContacts = persons;
            [LCSOSHandler saveMorseContacts:weakSelf.morseContacts];
            [weakSelf updateContactsButton];
        }];
        [pop show];
        
    }else {
        // [self loadSecretTalkContacts];
        // 添加亲友
        AddressBookController *vc = [[AddressBookController alloc] initWithNibName:@"AddressBookController" bundle:nil];
        vc.persons = _morseContacts;
//        vc.limitedCount = 3;
        vc.isShowMuseUser = YES;
        [vc setCompletionBlock:^(NSMutableArray<AddressPerson *> *persons) {
            [self AddFriendViewController:nil friendModelArray:persons];
        }];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
}


#pragma mark - 存储数据
- (void)loadMorseContacts {
    NSArray *morseContacts = [LCSOSHandler loadMorseContacts];
    if (morseContacts) {
        _morseContacts = [morseContacts mutableCopy];
    } else {
        _morseContacts = [NSMutableArray arrayWithCapacity:3];
    }
}
- (void)saveMorseContacts {
    [LCSOSHandler saveMorseContacts:_morseContacts];
}

- (void)rebuildContactsIcon {
    NSArray *icons = _contactsView.subviews;
    [icons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImage *icon = [UIImage imageNamed:@"icon_homepage2_people"];
    
    CGFloat padding = 12;
    CGFloat iconWidth = icon.size.width;
    CGFloat contentWidth = iconWidth * ((_morseContacts.count > 5) ? 5 : _morseContacts.count) + padding * (((_morseContacts.count > 5) ? 5 : _morseContacts.count) - 1);
    CGFloat x = (_contactsView.width - contentWidth)/2;
    CGFloat y = (_contactsView.height - icon.size.height)/2;
    for (NSInteger i = 0; i < ((_morseContacts.count > 5) ? 5 : _morseContacts.count); i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
        imageView.frame = CGRectMake(x, y, icon.size.width, icon.size.height);
        [_contactsView addSubview:imageView];
        x += (iconWidth + padding);
    }
    
}

- (void)updateContactsButton {
    _morseContacts = [[LCSOSHandler loadMorseContacts] mutableCopy];
    if (_morseContacts.count) {
        [_contactsButton setTitle:nil forState:UIControlStateNormal];
    } else {
        [_contactsButton setTitle:NSLocalizedString(@"morseConbtn", nil) forState:UIControlStateNormal];
    }
    [self rebuildContactsIcon];
}

@end