//
//  FloatingBallWindowViewController.m
//  Muse
//
//  Created by paycloud110 on 16/7/2.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "FloatingBallWindowViewController.h"
#import "ContentBackView.h"
#import "ContentButton.h"
#import "FriendTableViewCell.h"
#import "AddFriendTableViewCell.h"
#import "AddSecrectViewController.h"
#import "WSTableviewTree.h"
#import "FriendTableViewSubsCell.h"
#import "SecrectTableViewCell.h"
#import "FriendList.h"
#import "MJExtension.h"
#import "FriendListHealth.h"
#import "SelectFriendListViewController.h"

#import "AddressBookController.h"
#import <objc/runtime.h>
#import "DBManager+Contacts.h"
#import "BlueToothHelper.h"
#import "ContactManager.h"

#import "FriendSubSignalTableCell.h"

#define AddedSecrectKey @"AddedSecrectKey"
#define FriendCellA @"FriendCellA"
#define FriendSubCellB @"FriendSubCellB"
#define addFriendCellA @"addFriendCellA"
#define secrectCellA @"secrectCellA"

@interface FloatingBallWindowViewController () <UITableViewDataSource, UITableViewDelegate, WSTableViewDelegate, AddFriendTableViewCellDelegate>

/**  */
@property (nonatomic, strong) WSTableView *friendTableView;
/**  */
@property (nonatomic, strong) UITableView *addFriendTableView;
/**  */
@property (nonatomic, strong) UITableView *secretTableView;
/**  */
@property (nonatomic, weak) UIView *backView;
/**  */
@property (nonatomic, weak) ContentBackView *topBackView;
/**  */
@property (nonatomic, weak) UILabel *topLabel;
/**  */
@property (nonatomic, weak) UIImageView *leftImageView;
/**  */
@property (nonatomic, weak) ContentButton *friendButton;
/**  */
@property (nonatomic, weak) ContentButton *addFriendButton;
/**  */
@property (nonatomic, weak) ContentButton *secrectButton;
/**  */
@property (nonatomic, weak) UIView *bottomAddView;
/**  */
@property (nonatomic, weak) ContentButton *addFlagButton;
/**  */
@property (nonatomic, weak) UIButton *selectedButton;
/**  */
@property (nonatomic, weak) UITableView *selectedTableView;
/**  */
@property (nonatomic, strong) NSMutableArray *friendListArray;
/**  */
@property (nonatomic, strong) NSMutableArray *friendHealthArray;
/**  */
@property (nonatomic, strong) NSMutableArray *addressBookArray;
/**  */
@property (nonatomic, weak) UIView *secrectRedView;
/**  */
@property (nonatomic, weak) UIView *addFriendRedView;
/**  */
@property (nonatomic, weak) UIButton *addSecrectButton;
/**  */
@property (nonatomic, strong) NSMutableArray *addedSecrect;
/**  */
@property (nonatomic, strong) NSMutableArray *friendPartnershipArray;
/**  */
@property (nonatomic, strong) NSMutableArray *friendNineArray;
/**  */
@property (nonatomic, strong) AddressPerson *personedNeed;
/**  */
@property (nonatomic, strong) FriendList *friendList;
/**  */
@property (nonatomic, assign) BOOL whetherMiYu;
/**  */
@property (nonatomic, strong) NSMutableArray *friendsDataArray;
@end

@implementation FloatingBallWindowViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupViewController];
    
}

- (void)setupViewController
{
    
    
    
    self.whetherMiYu = [[NSUserDefaults standardUserDefaults] boolForKey:MiYuAcceptedToCurrentUserKey];
    
    self.addedSecrect = [[[NSUserDefaults standardUserDefaults] objectForKey:AddedSecrectKey] mutableCopy];
    
    self.friendPartnershipArray = [[[NSUserDefaults standardUserDefaults] objectForKey:FriendListPartishipKey] mutableCopy];
    
    UIView *coverView = [[UIView alloc] init];
    
    coverView.backgroundColor = UIColorFromRGBA(0, 0.5);
    
    [self.view addSubview:coverView];
    
    UIView *backView = [[UIView alloc] init];
    
    backView.backgroundColor = UIColorFromRGB(0xd7dcdd);
    
    self.backView = backView;
    [self.view addSubview:backView];
    
    self.view.layer.cornerRadius = 6;
    self.view.layer.masksToBounds = YES;
    
    ContentBackView *topBackView = [[ContentBackView alloc] initWhetherBottomView:YES];
    self.topBackView = topBackView;
    [backView addSubview:topBackView];
    
    UILabel *topLabel = [[UILabel alloc] init];
    self.topLabel = topLabel;
    topLabel.textColor = UIColorFromRGB(0x505050);
    topLabel.font = [UIFont systemFontOfSize:16];
    topLabel.text = NSLocalizedString(@"Friends Status", nil);
    [topLabel sizeToFit];
    [backView addSubview:topLabel];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_test2_2"]];
    self.leftImageView = leftImageView;
    leftImageView.userInteractionEnabled = YES;
    [backView addSubview:leftImageView];
    
    ContentButton *friendButton = [[ContentButton alloc] initWithImageName:@"btn_test2_friend"];
    self.friendButton = friendButton;
    friendButton.tag = 10;
    [friendButton addTarget:self action:@selector(selectedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftImageView addSubview:friendButton];
    
    ContentButton *addFriendButton = [[ContentButton alloc] initWithImageName:@"btn_test2_message"];
    self.addFriendButton = addFriendButton;
    addFriendButton.tag = 11;
    [addFriendButton addTarget:self action:@selector(selectedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftImageView addSubview:addFriendButton];
    
    UIView *addFriendRedView = [[UIView alloc] init];
    self.addFriendRedView = addFriendRedView;
    addFriendRedView.layer.cornerRadius = 5;
    //   addFriendRedView.backgroundColor = [UIColor redColor];
    addFriendRedView.backgroundColor = nil;
    [addFriendButton addSubview:addFriendRedView];
    
    //    ContentButton *secrectButton = [[ContentButton alloc] initWithImageName:@"btn_test2_sweet"];
    //    self.secrectButton = secrectButton;
    //    secrectButton.tag = 12;
    //    [secrectButton addTarget:self action:@selector(selectedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [leftImageView addSubview:secrectButton];
    
    //    UIView *secrectRedView = [[UIView alloc] init];
    //    self.secrectRedView = secrectRedView;
    //    secrectRedView.layer.cornerRadius = 5;
    //    secrectRedView.backgroundColor = [UIColor redColor];
    //    [secrectButton addSubview:secrectRedView];
    //    if (self.whetherMiYu) {
    //        secrectRedView.hidden = NO;
    //    }else {
    //        secrectRedView.hidden = YES;
    //    }
    
    UIView *bottomAddView = [[UIView alloc] init];
    self.bottomAddView = bottomAddView;
    bottomAddView.backgroundColor = UIColorFromRGB(0xc5cccf);
    [backView addSubview:bottomAddView];
    
    ContentButton *addFlagButton = [ContentButton buttonWithType:UIButtonTypeCustom];
    
    [addFlagButton setImage:nil forState:UIControlStateNormal];
    [addFlagButton addTarget:self action:@selector(addFlagButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //    [addFlagButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    self.addFlagButton = addFlagButton;
    
    [bottomAddView addSubview:addFlagButton];
    
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(SScreenWidth * 3));
        make.height.equalTo(@(SScreenHeight + 60));
    }];
    
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    /** top */
    [self.topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top);
        make.left.equalTo(self.backView.mas_left);
        make.height.equalTo(@(67));
        make.right.equalTo(self.backView.mas_right);
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBackView.mas_centerY);
        make.left.equalTo(self.topBackView.mas_left).offset(14);
        make.right.equalTo(self.topBackView.mas_right);
        make.height.equalTo(@(self.topLabel.height));
    }];
    /** left */
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBackView.mas_bottom);
        make.left.equalTo(self.backView.mas_left);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.width.equalTo(@(74));
    }];
    [self.friendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImageView.mas_top);
        make.left.equalTo(self.leftImageView.mas_left);
        make.right.equalTo(self.leftImageView.mas_right);
        make.height.equalTo(@(67));
    }];
    [self.addFriendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.friendButton.mas_bottom);
        make.left.equalTo(self.leftImageView.mas_left);
        make.right.equalTo(self.leftImageView.mas_right);
        make.height.equalTo(@(67));
    }];
    [self.addFriendRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addFriendButton.mas_top).offset(7);
        make.right.equalTo(self.addFriendButton.mas_right).offset(-18);
        make.width.equalTo(@(10));
        make.height.equalTo(@(10));
    }];
    [self.secrectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addFriendButton.mas_bottom);
        make.left.equalTo(self.leftImageView.mas_left);
        make.right.equalTo(self.leftImageView.mas_right);
        make.height.equalTo(@(67));
    }];
    [self.secrectRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secrectButton.mas_top).offset(7);
        make.right.equalTo(self.secrectButton.mas_right).offset(-18);
        make.width.equalTo(@(10));
        make.height.equalTo(@(10));
    }];
    /** bottom */
    [self.bottomAddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.right.equalTo(self.backView.mas_right);
        make.height.equalTo(@(59));
    }];
    [self.addFlagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomAddView.mas_centerX);
        make.centerY.equalTo(self.bottomAddView.mas_centerY);
        make.left.equalTo(self.bottomAddView.mas_left);
        make.right.equalTo(self.bottomAddView.mas_right);
        make.height.equalTo(@(30));
    }];
    
    [self.friendTableView registerClass:[FriendTableViewCell class] forCellReuseIdentifier:FriendCellA];
    // 注册 cell 注释
//    [self.friendTableView registerClass:[FriendSubsTableViewCell class] forCellReuseIdentifier:FriendSubCellB];
    [self.addFriendTableView registerClass:[AddFriendTableViewCell class] forCellReuseIdentifier:addFriendCellA];
    //    [self.secretTableView registerClass:[SecrectTableViewCell class] forCellReuseIdentifier:secrectCellA];
    [self sureSelectedDisplay:self.friendButton];
    // 注册通知
    [self registerNotification];
    if (self.friendPartnershipArray.count > 0) {
        self.addFriendRedView.hidden = NO;
    }else {
        self.addFriendRedView.hidden = YES;
    }
    
    
    [FloatingView sharedView].delegate = self;
    if ([FloatingView sharedView].friendsData && [FloatingView sharedView].friendListArray) {
        [self.friendListArray setArray: [FloatingView sharedView].friendListArray];
        self.friendsData = [FloatingView sharedView].friendsData;
        [_friendTableView reloadData];
    }
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayMessageRedView:) name:ReceiveFriendAskforNotification object:nil];
}



- (void)displayMessageRedView:(NSNotification *)notification {
    
    self.friendPartnershipArray = [[[NSUserDefaults standardUserDefaults] objectForKey:FriendListPartishipKey] mutableCopy];
    MSLog(@"%@",self.friendPartnershipArray);
    [self.addFriendTableView reloadData];
    self.addFriendRedView.hidden = NO;
}
- (void)displayMiYuRedView:(NSNotification *)notification
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.secrectRedView.hidden = NO;
    });
}
#pragma mark --<点击事件>
/** 添加亲友 */
- (void)addFlagButtonClick {
    if (self.selectedTableView == self.secretTableView) {
        /** 添加密语 */
        AddSecrectViewController *addSecrect = [[AddSecrectViewController alloc] init];
        addSecrect.existArray = self.addedSecrect;
        addSecrect.contentBlock = ^(NSMutableArray *contentArray){
            for (NSString *string in contentArray) {
                if ([self.addedSecrect containsObject:string]) {
                    
                }else {
                    [self.addedSecrect addObject:string];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:self.addedSecrect forKey:AddedSecrectKey];
            [self.secretTableView reloadData];
        };
        [self presentViewController:addSecrect animated:YES completion:nil];
    }else if (self.selectedTableView == self.friendTableView) {
        // 添加亲友
        AddressBookController *vc = [[AddressBookController alloc]initWithNibName:@"AddressBookController" bundle:nil];
        vc.isShowMuseUser = YES;
        
        [vc setCompletionBlock:^(NSMutableArray<AddressPerson *> *persons) {
            self.addressBookArray = persons;
            NSMutableString *phones = [[NSMutableString alloc] init];
            NSMutableString *remarks = [[NSMutableString alloc] init];
            for (NSInteger i = 0; i < self.addressBookArray.count; i++) {
                AddressPerson *addPerson = self.addressBookArray[i];
                if (i == 0) {
                    [phones appendFormat:@"%@", addPerson.phone];
                    [remarks appendFormat:@"%@", addPerson.name];
                } else {
                    [phones appendFormat:@",%@", addPerson.phone];
                    [remarks appendFormat:@",%@", addPerson.name];
                }
            }
            NSLog(@"%@", self.addressBookArray);
            
            // 发送亲友请求
            [AskforFriendAttentionRequest startRequestWithPhones:phones
                                                         remarks:remarks
                                          completionBlockSuccess:^(id request) {
                                              [MBProgressHUD showSuccess:NSLocalizedString(@"friendRequestSucceed", nil) toView:self.view];
                                              
                                              [[BlueToothHelper sharedInstance] lightingWithColor:LightColorBlue duration:1];
                                              
                                          } failure:^(id request) {
                                              NSString *message = request[@"message"];
                                              if (message) {
                                                  [MBProgressHUD showError:message toView:self.view];
                                              } else {
                                                  [MBProgressHUD showError:NSLocalizedString(@"Network Error", nil) toView:self.view];
                                              }
                                          }];
        }];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
/** 添加谜语发送亲友 */
- (void)addSecrectButtonClick:(UIButton *)button {
    if (self.friendListArray.count == 0 ) {
        [MBProgressHUD showMessage:@"未添加亲友，请添加" toView:self.view hideAfterDelay:2];
        return;
    }
    SelectFriendListViewController *friendList = [[SelectFriendListViewController alloc] init];
    friendList.friendListArray = self.friendListArray;
    friendList.friendListBlock = ^(FriendList *list){
        self.friendList = list;
        [self.addSecrectButton setTitle:list.phone forState:UIControlStateNormal];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:friendList];
    [self presentViewController:nav animated:YES completion:nil];
}

/** 确定选中显示 */
- (void)sureSelectedDisplay:(UIButton *)button {
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    self.selectedTableView.hidden = YES;
    if (button == self.friendButton) {
        self.selectedTableView = self.friendTableView;
        self.topLabel.text = NSLocalizedString(@"homepage_healthContent_title1", nil);
        
        
        
        [_addFlagButton setImage:[UIImage imageNamed:@"btn_test2_plus"] forState:UIControlStateNormal];
        
        //        [self getFloatingBallWindowData];
    } else if (button == self.addFriendButton) {
        self.selectedTableView = self.addFriendTableView;
        self.topLabel.text = NSLocalizedString(@"homepage_healthContent_title2", nil);
        
        [_addFlagButton setImage:nil forState:UIControlStateNormal];
        
        [self whetherFriendAskfor];
        
    } else if (button == self.secrectButton) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MiYuAcceptedToCurrentUserKey];
        self.selectedTableView = self.secretTableView;
        self.topLabel.text = @"一键密语";
        self.secrectRedView.hidden = YES;
        [self whetherSecrect];
    }
    self.selectedTableView.hidden = NO;
}

- (void)selectedButtonClicked:(UIButton *)button {
    [self sureSelectedDisplay:button];
}



/** 返回指定用户ID数据 */
- (NSDictionary *)backFriendListOneToOneData:(NSString *)userID {
    for (NSInteger i = 0; i < self.friendNineArray.count; i++) {
        NSDictionary *dict = self.friendNineArray[i];
        NSString *ID = dict[@"user_id"];
        if ([ID isEqualToString:userID]) {
            return dict;
        }
    }
    return nil;
}

- (void)whetherFriendListData {
    for (UIView *view in self.friendTableView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    UILabel *contentLabel = [[UILabel alloc] init];
    if (self.friendListArray.count == 0) {
        contentLabel.text = NSLocalizedString(@"no friend", nil);
        [contentLabel sizeToFit];
        [self.friendTableView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.friendTableView.mas_centerX);
            make.centerY.equalTo(self.friendTableView.mas_centerY);
            make.width.equalTo(@(contentLabel.width));
            make.height.equalTo(@(contentLabel.height));
        }];
    }
}

- (void)whetherFriendAskfor {
    
    for (UIView *view in self.addFriendTableView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    MSLog(@"💐");
    
    UILabel *contentLabel = [[UILabel alloc] init];
    
    if ([kUserDefaults objectForKey:FriendListPartishipKey]) {
        [self.friendPartnershipArray setArray: [kUserDefaults objectForKey:FriendListPartishipKey]];
    }
    
    if (self.friendPartnershipArray.count == 0) {
        contentLabel.text = NSLocalizedString(@"No friend Apply", nil);
        [contentLabel sizeToFit];
        [self.addFriendTableView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.addFriendTableView.mas_centerX);
            make.centerY.equalTo(self.addFriendTableView.mas_centerY);
            make.width.equalTo(@(contentLabel.width));
            make.height.equalTo(@(contentLabel.height));
        }];
        [self.addFriendTableView reloadData];

    } else {
        [self displayMessageRedView:nil];
    }
}

- (void)whetherSecrect {
    for (UIView *view in self.secretTableView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    UILabel *contentLabel = [[UILabel alloc] init];
    if (self.addedSecrect.count == 0) {
        contentLabel.text = @"暂未添加密语";
        [contentLabel sizeToFit];
        [self.secretTableView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.secretTableView.mas_centerX);
            make.centerY.equalTo(self.secretTableView.mas_centerY).offset(60);
            make.width.equalTo(@(contentLabel.width));
            make.height.equalTo(@(contentLabel.height));
        }];
    }
}

#pragma mark --<UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.friendTableView) {
        return self.friendListArray.count;
    } else if (tableView == self.addFriendTableView) {
        return self.friendPartnershipArray.count;
    } else if (tableView == self.secretTableView) {
        return self.addedSecrect.count;
    }
    return 0;
}

- (CGFloat)tableView:(WSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(WSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.friendTableView) {
        FriendList *list = self.friendListArray[indexPath.row];
        if (self.friendsData.count > 0) {
            
            if ([self.friendsData[list.ID] count] > 1) {
                return [self.friendsData[list.ID] count] - 1;
            } else {
                return 0;
            }
            
        } else {
            return 0;
        }
    } else {
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    
    if (tableView == self.friendTableView) {
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendCellA];
        cell.expandable = YES; // 点击后需要扩展
        
        FriendList *list = self.friendListArray[indexPath.row];
        
        
        if (self.friendsData.count > 0) {
            NSArray *userIdArr = [self.friendsData allKeys];
            
            
            NSString *heartRate;
            for (NSInteger i = 0; i < userIdArr.count; i ++) {
                
                if ([list.ID isEqualToString:userIdArr[i]]) {
                    
                    if ([self.friendsData[list.ID] count] > 0) {
                        NSDictionary *dataDic = self.friendsData[list.ID][0];
                        heartRate = dataDic [@"rate"];
                        break;
                    }
                }
            }
            
            NSString *name = list.nickname;
            [cell setName:name heartRate:heartRate sleepTime:@""];
        }
        

        return cell;
    } else if (tableView == self.addFriendTableView) {
        AddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addFriendCellA];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dict = self.friendPartnershipArray[indexPath.row];
        
        
        NSString *phone = dict[@"from_phone"];
        NSString *name = [[DBManager sharedManager] nameForPhone:phone];
        
        [cell addChildeViewConstantsNameLabel:name ? name : phone];
        
        //   MSLog(@"%@",cell);
        
        return cell;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendTableViewSubsCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendSubCellB];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendTableViewSubsCell" owner:self options:nil] firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = NO;
    
    FriendList *list = self.friendListArray[indexPath.row];
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.friendsData[list.ID][indexPath.subRow + 1][@"created"] doubleValue]];
    
    [cell setCellDataWithTimeStr:[date stringWithFormat:@"MM-dd HH:mm"] rateStr:self.friendsData[list.ID][indexPath.subRow + 1][@"rate"] isOther:[self.friendsData[list.ID][indexPath.subRow + 1][@"auto"] boolValue]];
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ContentBackView *backView = [[ContentBackView alloc] initWhetherBottomView:NO];
    backView.frame = CGRectMake(0, 0, tableView.frame.size.width, 126);
    
    NSString *add = self.friendList.phone;
    if (add == nil) {
        add = @"添加发送对象";
    }
    UIButton *secrectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addSecrectButton = secrectButton;
    [secrectButton setTitle:add forState:UIControlStateNormal];
    secrectButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [secrectButton setTitleColor:UIColorFromRGBA(0x505050, 0.5) forState:UIControlStateNormal];
    [secrectButton setBackgroundImage:[UIImage imageNamed:@"btn_test2_white1"] forState:UIControlStateNormal];
    [secrectButton addTarget:self action:@selector(addSecrectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:secrectButton];
    
    [secrectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(33);
        make.centerX.equalTo(backView.mas_centerX);
        make.width.equalTo(@(200));
        make.height.equalTo(@(66));
    }];
    
    return backView;
}

#pragma mark --<UITableViewDelegate>
- (void)tableView:(WSTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.friendTableView) {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        FriendList *list = self.friendListArray[indexPath.row];
        [FloatingView sharedView].currentCareID = list.ID;
        [kUserDefaults setValue:list.ID forKey:UserDefaultKey_LastCareFriend];
        [kUserDefaults synchronize];
        [[FloatingView sharedView] updateDataWithUserID:list.ID];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.friendTableView) {
        return 66;
    } else if (tableView == self.addFriendTableView) {
        return 133;
    } else if (tableView == self.secretTableView) {
        return 66;
    }
    return 0;
}

- (void)tableView:(WSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1关爱 2  100SOS 101 102心率超标
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.secretTableView) {
        return 126;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView ==  self.friendTableView) {
        [MBProgressHUD showHUDWithMessage:NSLocalizedString(@"friendDelete", nil) toView:self.view];
        FriendList *list = self.friendListArray[indexPath.row];
        [DeleteListFriendRequest startWithDeleteID:list.ID completionBlockSuccess:^(id request) {
            [MBProgressHUD hideHUDForView:self.view];
            [self.friendListArray removeObjectAtIndex:indexPath.row];
            [self.friendTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            // 删除后必须刷新数据，不然有问题
            [self.friendTableView refreshData];
            
            [self whetherFriendListData];
        } failure:^(id request) {
            NSString *message = request[@"message"];
            if (message) {
                [MBProgressHUD showError:message toView:self.view];
            }else {
                [MBProgressHUD showError:NSLocalizedString(@"Network Error", nil) toView:self.view];
            }
            self.friendTableView.editing = NO;
        }];
    } else if (tableView == self.secretTableView) {
        [self.addedSecrect removeObjectAtIndex:indexPath.row];
        [self.secretTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [[NSUserDefaults standardUserDefaults] setObject:self.addedSecrect forKey:AddedSecrectKey];
        [self whetherSecrect];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"tbvDelete", nil);
}

#pragma mark --<AddFriendTableViewCellDelegate>
- (void)addFriendTableViewCell:(AddFriendTableViewCell *)addFriendTableViewCell withButton:(UIButton *)button {
    
    
    
    
    NSIndexPath *indexPath = [self.addFriendTableView indexPathForCell:addFriendTableViewCell];
    NSDictionary *dict = self.friendPartnershipArray[indexPath.row];
    NSString *from_id = dict[@"from_id"];
    
    ContactManager *_manager = [ContactManager sharedInstance];
    
    _manager.currentAddFriendPhone = dict[@"from_phone"];
    if (_manager.allContacts.count > 0) {
        
        for (AddressPerson *person in _manager.allContacts) {
            if ([person.phone isEqualToString:dict[@"from_phone"]]) {
                _manager.currentAddFriendName = person.name;
                break;
            }
        }
    }
    
    //    [MBProgressHUD showHUDWithMessageOnly:@"处理中"];
    MBProgressHUD *hud = [MBProgressHUD showHUDWithMessage:@"" toView:self.view];

    if (button.tag == 10) { // 同意
        [DisposeFriendPartnershipRequest startWithFromID:from_id agree:YES completionBlockSuccess:^(id request) {
            [self.friendPartnershipArray removeObjectAtIndex:indexPath.row];
            [self.addFriendTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            if (self.friendPartnershipArray.count > 0) {
                self.addFriendRedView.hidden = NO;
            }else {
                self.addFriendRedView.hidden = YES;
            }
            [[NSUserDefaults standardUserDefaults] setObject:self.friendPartnershipArray forKey:FriendListPartishipKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [[FloatingView sharedView] refreshFriendList];
            [hud hide:YES];

        } failure:^(id request) {
            [hud hide:YES];

            NSString *message = request[@"message"];
            if (message) {
                [MBProgressHUD showError:message toView:self.view];
            }else {
                [MBProgressHUD showError:NSLocalizedString(@"Network Error", nil) toView:self.view];
            }
        }];
    } else if (button.tag == 11) { // 拒绝
        [DisposeFriendPartnershipRequest startWithFromID:from_id agree:NO completionBlockSuccess:^(id request) {
            [self.friendPartnershipArray removeObjectAtIndex:indexPath.row];
            [self.addFriendTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            if (self.friendPartnershipArray.count > 0) {
                self.addFriendRedView.hidden = NO;
            }else {
                self.addFriendRedView.hidden = YES;
            }
            [[NSUserDefaults standardUserDefaults] setObject:self.friendPartnershipArray forKey:FriendListPartishipKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[FloatingView sharedView] refreshFriendList];
            [hud hide:YES];

        } failure:^(id request) {
            [hud hide:YES];

            NSString *message = request[@"message"];
            if (message) {
                [MBProgressHUD showError:message toView:self.view];
            }else {
                [MBProgressHUD showError:NSLocalizedString(@"Network Error", nil) toView:self.view];
            }
        }];
    }
    
}
- (NSDictionary *)backPartnershipFriendListData:(NSMutableArray *)friendListData withId:(NSString *)userID
{
    for (NSDictionary *dict in friendListData) {
        NSString *string = dict[@"user_id"];
        if ([string isEqualToString:userID]) {
            return dict;
        }
    }
    return @{@"heart_info":@"", @"sleep_info":@"", @"step":@""};
}
#pragma mark --<FloatingViewFriendsDataRefreshDelegate>
- (void)didRefreshFriendsData:(NSDictionary *)friendsData friendList:(NSArray *)friendList {
    
   

    
    // 空数据就直接刷新空数据了
    if (!friendsData && !friendList) {
        [self.friendListArray removeAllObjects];
        [self.friendTableView reloadData];
        // 显示没有好友的页面
        [self whetherFriendListData];
        return;
    }
    
    self.friendsData = friendsData;
    
    
    // friendListArray 里面的内容是 FriendList 对象
    /*
     avatar = "";
     "contact_name" = "";
     id = 12;
     nickname = "\U9a6c180";
     phone = 8618018778778;
     */
    self.friendListArray = [FriendList objectArrayWithKeyValuesArray:friendList];
    
    // 显示没有好友的页面
    
    [self.friendTableView refreshData];
    [self.addFriendTableView reloadData];
    
    [self whetherFriendListData];

}
#pragma mark --<layz>

- (WSTableView *)friendTableView {
    
    if (_friendTableView == nil) {
        _friendTableView = [[WSTableView alloc] init];
        _friendTableView.WSTableViewDelegate = self;
        _friendTableView.hidden = YES;
        _friendTableView.backgroundColor = UIColorFromRGB(0xd7dcdd);
        //        _friendTableView.backgroundColor = [UIColor yellowColor];
        _friendTableView.shouldExpandOnlyOneCell = YES; // 控制是否有扩展功能
        _friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.backView addSubview:_friendTableView];
        
        [self.friendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topBackView.mas_bottom);
            make.left.equalTo(self.leftImageView.mas_right);
            make.bottom.equalTo(self.bottomAddView.mas_top).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
        }];
    }
    return _friendTableView;
}
- (UITableView *)addFriendTableView
{
    if (_addFriendTableView == nil) {
        //        SSWeakSelf();
        
        _addFriendTableView = [[UITableView alloc] init];
        _addFriendTableView.dataSource = self;
        _addFriendTableView.delegate = self;
        _addFriendTableView.hidden = YES;
        _addFriendTableView.backgroundColor = UIColorFromRGB(0xd7dcdd);
        _addFriendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.backView addSubview:_addFriendTableView];
        
        [self.addFriendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topBackView.mas_bottom);
            make.left.equalTo(self.leftImageView.mas_right);
            make.bottom.equalTo(self.bottomAddView.mas_top).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
        }];
    }
    return _addFriendTableView;
}

//- (UITableView *)secretTableView {
//    if (_secretTableView == nil) {
//        _secretTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _secretTableView.dataSource = self;
//        _secretTableView.delegate = self;
//        _secretTableView.hidden = YES;
//        _secretTableView.backgroundColor = UIColorFromRGB(0xd7dcdd);
//        _secretTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _secretTableView.contentInset = UIEdgeInsetsMake(0, 0, -38, 0);
//        [self.backView addSubview:_secretTableView];
//
//        [self.secretTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.topBackView.mas_bottom);
//            make.left.equalTo(self.leftImageView.mas_right);
//            make.bottom.equalTo(self.bottomAddView.mas_top).offset(0);
//            make.right.equalTo(self.view.mas_right).offset(0);
//        }];
//    }
//    return _secretTableView;
//}

- (NSMutableArray *)friendHealthArray {
    if (_friendHealthArray == nil) {
        _friendHealthArray = [[NSMutableArray alloc] init];
    }
    return _friendHealthArray;
}

- (NSMutableArray *)addressBookArray {
    if (_addressBookArray == nil) {
        _addressBookArray = [[NSMutableArray alloc] init];
    }
    return _addressBookArray;
}

- (NSMutableArray *)addedSecrect {
    if (_addedSecrect == nil) {
        _addedSecrect = [[NSMutableArray alloc] init];
    }
    return _addedSecrect;
}

- (NSMutableArray *)friendPartnershipArray {
    if (_friendPartnershipArray == nil) {
        _friendPartnershipArray = [[NSMutableArray alloc] init];
    }
    return _friendPartnershipArray;
}

- (NSMutableArray *)friendNineArray {
    if (_friendNineArray == nil) {
        _friendNineArray = [[NSMutableArray alloc] init];
    }
    return _friendNineArray;
}
- (NSMutableArray *)friendsDataArray
{
    if (_friendTableView == nil) {
        _friendsDataArray = [[NSMutableArray alloc] init];
    }
    return _friendsDataArray;
}
@end
