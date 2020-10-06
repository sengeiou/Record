//
//  NewsNoticeViewController.m
//  Muse
//
//  Created by songbaoqiang on 16/8/14.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "NewsNoticeViewController.h"

#import "NewsNoticeCell.h"

#import "AppDelegate.h"

#import "DBManager+MessageBox.h"

 static NSString *const ID = @"msgBoxCell";

@interface NewsNoticeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) NSMutableArray *cellHeightArray;


@property (nonatomic, assign) BOOL whetherEnterCell;

@end

@implementation NewsNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xEFEFEF);
    _array = [[NSMutableArray alloc] init];
    _cellHeightArray = [[NSMutableArray alloc] init];
    [self setupUI];
    [self loadData];
    [kNotificationCenter addObserver:self selector:@selector(loadData) name:Notify_AppBecomeActive object:nil];
    [kNotificationCenter addObserver:self selector:@selector(refreshData) name:Notify_ReceiveNewMsg object:nil];
}

- (void)refreshData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadData];
    });
}

- (void)setupUI {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SScreenWidth, 454 / 3)];
    
    headView.backgroundColor = UIColorFromRGB(0xDCDCDC);
    
    [self.view addSubview:headView];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_homepage_news"]];
    imageV.center = headView.center;
    NSInteger imgW = 318 / 3;
    NSInteger imgH = 212 / 3;
    imageV.bounds = CGRectMake(0, 0, imgW, imgH);
    [headView addSubview:imageV];
    
 
    
    UILabel *lable = [[UILabel alloc]init];
    lable.text = NSLocalizedString(@"MsgBox", nil);
    lable.textColor = UIColorFromRGB(0x000000);
    lable.font = [UIFont systemFontOfSize:16];
    [lable sizeToFit];
    [headView addSubview:lable];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX );
        make.bottom.equalTo(headView.mas_bottom).offset(-75 / 3);
    }];
    
    
    UIButton *imgbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgbtn setImage:[UIImage imageNamed:@"icon_loading_off"] forState:UIControlStateNormal];
    [imgbtn sizeToFit];
    [headView addSubview:imgbtn];
    [imgbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right).offset(-15);
        make.top.equalTo(headView.mas_top).offset(30);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    
    [imgbtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    
   // imageV.frame   318   212
    UIView *middleV = [[UIView alloc]initWithFrame:CGRectMake(0, 454 / 3, SScreenWidth, 1)];
    middleV.backgroundColor = UIColorFromRGB(0xa5a5a5);
    [self.view addSubview:middleV];
 
    
    //设置uitableview
    CGFloat lcx = 0;
    CGFloat lcy = 454 / 3 + 1 ;
    CGFloat lcw = SScreenWidth;
    CGFloat lch = SScreenHeight - lcy - 1 - (172 + 90 +88 + 48 ) / 3;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(lcx, lcy, lcw, lch)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColorFromRGB(0xefefef);
    self.tableView.rowHeight = 80;
    
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0,SScreenHeight - (172 + 90 +88 + 48 ) / 3 , SScreenWidth, (172 + 90 +88 + 48 ) / 3)];
    bottomV.backgroundColor = UIColorFromRGB(0xEFEFEF);
    [self.view addSubview:bottomV];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_homepage2_1"] forState:UIControlStateNormal];
    [btn setTitle:NSLocalizedString(@"clear", nil) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [btn sizeToFit];
    [bottomV addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomV.mas_centerX);
        make.bottom.equalTo(bottomV.mas_bottom).offset(-30);
        make.width.equalTo(@(btn.width));
        make.height.equalTo(@(btn.height));
    }];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)loadData {
    [self.array removeAllObjects];
    [self.cellHeightArray removeAllObjects];
    [self.array setArray: [[DBManager sharedManager] readMessageBoxTableAllData]];
    NSArray *resultArr = [[self.array reverseObjectEnumerator] allObjects];
    [self.array setArray:resultArr];
    
    NSString *countStr = [NSString stringWithFormat:@"%lu",(unsigned long)self.array.count];
    
    [kUserDefaults setObject:countStr forKey:@"NEWHADENTERMESSAGERVC"];
   
    
    
    for (int i = 0; i < self.array.count; i ++) {
        NSString *message = self.array[i][@"message"];
        CGFloat width = SScreenWidth - (65 + 16 + 9 + 11 + 11);
        CGFloat contentsH = [message boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        [_cellHeightArray addObject:@(contentsH)];
    }
    
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    self.whetherEnterCell = YES;
    NewsNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
    
        cell = [[NewsNoticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    NSDictionary *dict = self.array[indexPath.row];
    [cell setupChildView:dict[@"time"] content:dict[@"message"] height:[_cellHeightArray[indexPath.row] floatValue]];
    
    if (indexPath.row == 0) {
        cell.topLineView.hidden = YES;
        cell.bottomLineView.hidden = NO;
    }else if (indexPath.row == self.array.count - 1) {
        cell.bottomLineView.hidden = YES;
        cell.topLineView.hidden = NO;
    }
    cell.layer.masksToBounds = YES;
    cell.contentView.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([_cellHeightArray[indexPath.row] floatValue] < 80) {
        return 80 + 10;
    }else {
        return [_cellHeightArray[indexPath.row] floatValue] + 20;
    }

}

- (void)click {
    
    [AppDelegate appDelegate].floatingWindow.hidden = NO;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        _iconImageView.hidden = NO;
        
        _redMessageCountImage.hidden = NO;
        
        self.messageFloatingWin.frame = _messageFloatingWinFrame;
        
    }];
}

- (void)btnClick {
    
    [[DBManager sharedManager] cancelMessageBoxTableAllData];
    
    self.array = [[DBManager sharedManager] readMessageBoxTableAllData];
    
    NSString *countStr = [NSString stringWithFormat:@"%@",@0];
    
    [kUserDefaults setObject:countStr forKey:@"NEWHADENTERMESSAGERVC"];

    
    [self.tableView reloadData];
}

@end
