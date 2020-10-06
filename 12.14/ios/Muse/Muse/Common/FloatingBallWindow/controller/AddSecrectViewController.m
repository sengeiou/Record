//
//  AddSecrectViewController.m
//  Muse
//
//  Created by paycloud110 on 16/7/7.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "AddSecrectViewController.h"
#import "AddSecrectTableViewCell.h"
#import "AddSecrect.h"

#define AddSecrectCellA @"AddSecrectCellA"

@interface AddSecrectViewController () <UITableViewDataSource, UITableViewDelegate, AddSecrectTableViewCellDelegate>

/**  */
@property (nonatomic, strong) UITableView *tableView;
/**  */
@property (nonatomic, weak) UIButton *selectedButton;
/**  */
@property (nonatomic, strong) NSMutableArray *addedSecrect;
/**  */
@property (nonatomic, strong) NSMutableArray *secrectContent;

@end

@implementation AddSecrectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupChildView];
    [self.tableView registerClass:[AddSecrectTableViewCell class] forCellReuseIdentifier:AddSecrectCellA];
    self.secrectContent = [[NSMutableArray alloc] initWithArray:@[@"亲爱的，想你了，么么哒...",
                                                                  @"出门路上小心，注意安全，开心...",
                                                                  @"亲爱的，别太辛苦，注意休息...",
                                                                  @"亲爱的，你该休息了",
                                                                  @"亲爱的，你昨晚休息的太晚了...",
                                                                  @"亲爱的，你心率超出了健康值了...",
                                                                  @"亲爱的猪，你真能睡，该起床了...",
                                                                  @"注意安全，你心率超出了健康"]
                           ];
    self.addedSecrect = self.existArray;
}

- (void)setupChildView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SScreenWidth, 130)];
    backView.backgroundColor = UIColorFromRGB(0xdadfe0);
    [self.view addSubview:backView];
    
    UIButton *heartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [heartButton setImage:[UIImage imageNamed:@"btn_test2_sweet"] forState:UIControlStateNormal];
    [backView addSubview:heartButton];
    
    UILabel *secrectLabel = [[UILabel alloc] init];
    secrectLabel.text = @"添加密语";
    secrectLabel.font = [UIFont systemFontOfSize:16];
    secrectLabel.textColor = UIColorFromRGB(0x505050);
    [secrectLabel sizeToFit];
    [backView addSubview:secrectLabel];
    
    UIView *bottomBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SScreenWidth, 130)];
    bottomBackView.backgroundColor = UIColorFromRGB(0xdadfe0);
    [self.view addSubview:bottomBackView];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.tag = 10;
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureButton setTitleColor:UIColorFromRGB(0x505050) forState:UIControlStateNormal];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"btn_test2_white4"] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackView addSubview:sureButton];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.tag = 11;
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancleButton setTitleColor:UIColorFromRGB(0x505050) forState:UIControlStateNormal];
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"btn_test2_white4"] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackView addSubview:cancleButton];
    
    [heartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.top.equalTo(backView.mas_top).offset(40);
        make.width.equalTo(@(72));
        make.height.equalTo(@(66));
    }];
    [secrectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.top.equalTo(backView.mas_top).offset(98);
        make.width.equalTo(@(secrectLabel.width));
        make.height.equalTo(@(secrectLabel.height));
    }];
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@(90));
    }];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomBackView.mas_centerY);
        make.centerX.equalTo(bottomBackView.mas_centerX).offset(-60);
        make.width.equalTo(@(82));
        make.height.equalTo(@(44));
    }];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomBackView.mas_centerY);
        make.centerX.equalTo(bottomBackView.mas_centerX).offset(60);
        make.width.equalTo(@(82));
        make.height.equalTo(@(44));
    }];
}

- (void)bottomButtonClicked:(UIButton *)button {
    if (self.contentBlock) {
        self.contentBlock(self.addedSecrect);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --<UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.secrectContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddSecrectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddSecrectCellA];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    AddSecrect *addSecrect = [[AddSecrect alloc] init];
    addSecrect.content = self.secrectContent[indexPath.row];
    addSecrect.stateButton = [self.existArray containsObject:addSecrect.content];
    
    cell.addSecrect = addSecrect;
    
    return cell;
}

#pragma mark --<UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --<AddSecrectTableViewCellDelegate>

- (void)addSecrectTableViewCell:(AddSecrectTableViewCell *)addSecrectTableViewCell withButton:(UIButton *)button {
    button.selected = !button.selected;
    NSString *contentLabel = addSecrectTableViewCell.contentLabel.text;
    if (button.selected) {
        [self.addedSecrect addObject:contentLabel];
    } else {
        [self.addedSecrect removeObject:contentLabel];
    }
}

#pragma mark --<layz>

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, SScreenWidth, SScreenHeight - 130 - 90)];
        _tableView.backgroundColor = UIColorFromRGB(0xdadfe0);
        _tableView.rowHeight = 66;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)addedSecrect {
    if (_addedSecrect == nil) {
        _addedSecrect = [[NSMutableArray alloc] init];
    }
    return _addedSecrect;
}

@end
