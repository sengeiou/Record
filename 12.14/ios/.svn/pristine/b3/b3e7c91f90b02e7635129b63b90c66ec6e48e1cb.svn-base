//
//  AddFriendViewController.m
//  Muse
//
//  Created by songbaoqiang on 16/8/21.
//  Copyright © 2016年 Muse. All rights reserved.
//
#import "LCSOSHandler.h"
#import "AddFriendViewController.h"
#import "FriendList.h"
#import "MJExtension.h"
#import "SettingHeaderBar.h"

#define AddFriendListCellA @"AddFriendListCellA"

@interface AddFriendViewController () <UITableViewDataSource, UITableViewDelegate>

/**  */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIButton *btn;
@property (nonatomic, strong) NSArray *emergencyContacts;
@property (nonatomic, strong) NSMutableArray *listFriendName;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendListArray = [FriendList objectArrayWithKeyValuesArray:[[[DBManager sharedManager] getUserFriendListfromDB] copy]];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AddFriendListCellA];
    [SettingHeaderBar addHeaderBarToController:self withType:SettingHeaderBarFriendList];
    
    [self setupUI];
}
- (void)setupUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"icon_loading_on"] forState:UIControlStateNormal];
    _btn = btn;
    btn.hidden = YES;
    [self.view addSubview:btn];
    btn.frame = CGRectMake(330, 40, 45, 45);
    [btn addTarget:self action:@selector(rigthBtnClick)  forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark -- 通知代理方法
- (void)rigthBtnClick
{
    if ([self.delegate respondsToSelector:@selector(AddFriendViewController:friendModelArray:)]) {
        [self.delegate AddFriendViewController:self friendModelArray:self.friendModelArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --<UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddFriendListCellA];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AddFriendListCellA];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.imageView.image = [UIImage imageNamed:@"icon_loading_photo"];
    
    FriendList *list = self.friendListArray[indexPath.row];
    cell.textLabel.text = list.nickname;
    
    for (int i = 0; i < self.friendModelArray.count; i++) {
        FriendList *li = self.friendModelArray[i];
        if ([li.nickname isEqualToString:cell.textLabel.text]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}
#pragma mark --<UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.friendModelArray.count > 3) {
        [MBProgressHUD showHUDWithMessageOnly:[NSString stringWithFormat:@"最多只能选择3个人哦"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return;
    }
    FriendList *list = self.friendListArray[indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        for (int i = 0; i < self.friendModelArray.count; i++) {
            FriendList *li = self.friendModelArray[i];
            if ([li.nickname isEqualToString:list.nickname]) {
                [self.friendModelArray removeObjectAtIndex:i];
            }
        }
        [self.friendModelArray removeObject:list];
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.friendModelArray addObject:list];
    }
    self.btn.hidden = NO;
}
#pragma mark --<layz>

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 66;
        _tableView.backgroundColor = UIColorFromRGB(0xd7dcdd);
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(108);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
    }
    return _tableView;
}

- (NSMutableArray *)friendListArray {
    if (_friendListArray == nil) {
        _friendListArray = [[NSMutableArray alloc] init];
    }
    return _friendListArray;
}
- (NSMutableArray *)friendModelArray {
    if (_friendModelArray == nil) {
        _friendModelArray = [NSMutableArray array];
    }
    return _friendModelArray;
}
@end
