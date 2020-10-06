//
//  HeartRatePopView.m
//  Muse
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SleepPopHelpView.h"
#import "HeartRateDataManager.h"
#import "MBProgressHUD+Simple.h"

@interface SleepPopHelpView ()

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIViewController *fatherVC;
@property (nonatomic,strong) NSMutableArray *openArr;

@property (nonatomic,strong) IBOutlet UITableViewCell *quietCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *normalCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *setCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *lookCell;

@end

@implementation SleepPopHelpView

+ (SleepPopHelpView *)viewFromNibByVc:(UIViewController *)vc
{
    SleepPopHelpView *pop;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    pop = [array objectAtIndex:0];
    pop.fatherVC = vc;
    
    pop.openArr = [NSMutableArray arrayWithObjects:@0, @1, @2, @3, nil];
   
    return pop;
}


- (void)dismiss
{
    [self fadeOut];
}

- (void)show
{  //添加遮罩
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = UIColorFromRGBA(0x333333, 0.6);
    maskView.frame = CGRectMake( 0, -30, SScreenWidth, SScreenHeight);
    [self insertSubview:maskView atIndex:0];
    
    [_fatherVC.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.top.equalTo(@20);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    [self fadeIn];
}

- (void)fadeIn {
    self.transform = CGAffineTransformMakeTranslation(0, 0);
    self.alpha = 0;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.alpha = 1;
                     }];
    
}

- (void)fadeOut {
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Action

- (IBAction)bgAction:(id)sender
{
    [self dismiss];
}

- (void)sectionAction:(UIButton *)btn {
    NSInteger tag = btn.tag;
    if([self.openArr containsObject:@(tag)]) {
        [self.openArr removeObject:@(tag)];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:tag]] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.openArr addObject:@(tag)];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:tag]] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark - UITableViewDataSource UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderButtonViewIdentifier = @"HeaderButtonViewIdentifier";
    UIButton *btn = (UIButton *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderButtonViewIdentifier];
    if (!btn) {
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_homepage_test"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sectionAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitleColor:RGBACOLOR(40, 40, 40, 1) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    
    btn.tag = section;
    switch (section) {
        case 0:
            [btn setTitle:@"什么是深度睡眠" forState:UIControlStateNormal];
            break;
        case 1:
            [btn setTitle:@"不同年龄段适宜的睡眠时长" forState:UIControlStateNormal];
            break;
        case 2:
            [btn setTitle:@"影响睡眠质量的因素" forState:UIControlStateNormal];
            break;
        case 3:
            [btn setTitle:@"缪斯智能戒指APP提供睡眠质量巡查" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    return btn;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 66; // 修改header高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .5f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.openArr containsObject:@(section)]) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            return _quietCell;
            break;
        case 1:
            return _normalCell;
            break;
        case 2:
            return _setCell;
            break;
        case 3:
            return _lookCell;
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 66;
    switch (indexPath.section) {
        case 0:
            height = 250;
            break;
        case 1:
            height = 123;
            break;
        case 2:
            height = 60;
            break;
        case 3:
            height = 411;
            break;
        default:
            break;
    }
    return height;
}

#pragma mark -- tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
