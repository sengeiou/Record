//
//  SelectFriendListViewController.m
//  Muse
//
//  Created by paycloud110 on 16/7/27.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SelectFriendListViewController.h"
#import "FriendList.h"
#import "SettingHeaderBar.h"
#import <MBProgressHUD.h>

#define SelectFriendListCellA @"SelectFriendListCellA"

@interface SelectFriendListViewController () <UITableViewDataSource, UITableViewDelegate>

/**  */
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SelectFriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SelectFriendListCellA];
    [SettingHeaderBar addHeaderBarToController:self withType:SettingHeaderBarFriendList];
   
}

#pragma mark --<UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectFriendListCellA];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SelectFriendListCellA];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.imageView.image = [UIImage imageNamed:@"icon_loading_photo"];
    
    FriendList *list = self.friendListArray[indexPath.row];
    cell.textLabel.text = list.nickname ? : (list.contact_name ? : list.phone);
    
    return cell;
}

#pragma mark --<UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.friendListBlock) {
        FriendList *list = self.friendListArray[indexPath.row];
        self.friendListBlock(list);
        self.friendListBlock = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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

@end
