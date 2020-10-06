//
//  HeartRatePopView.m
//  Muse
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "HeartRatePopHelpView.h"
#import "HeartRateDataManager.h"
#import "MBProgressHUD+Simple.h"

@interface HeartRatePopHelpView ()

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIViewController *fatherVC;
@property (nonatomic,strong) NSMutableArray *openArr;

@property (nonatomic,strong) IBOutlet UITableViewCell *quietCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *normalCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *setCell;

@property (nonatomic,strong) IBOutlet UITableViewCell *quietCell_en;
@property (nonatomic,strong) IBOutlet UITableViewCell *normalCell_en;
@property (nonatomic,strong) IBOutlet UITableViewCell *setCell_en;

/*
 文本内容
 */

//@property IBOutlet UILabel *oneKeyFuncLbl1;
//@property IBOutlet UILabel *oneKeyFuncLbl2;
//@property IBOutlet UILabel *oneKeyFuncLbl3;
//@property IBOutlet UILabel *oneKeyFuncLbl4;
//@property IBOutlet UILabel *oneKeyFuncLbl5;
//@property IBOutlet UILabel *oneKeyFuncLbl6;
//@property IBOutlet UILabel *oneKeyFuncLbl7;
//@property IBOutlet UILabel *oneKeyFuncLbl8;
//@property IBOutlet UILabel *oneKeyFuncLbl9;
//
//
//@property IBOutlet UILabel *vLbl1;
//@property IBOutlet UILabel *vLbl2;
//@property IBOutlet UILabel *vLbl3;
//@property IBOutlet UILabel *vLbl4;
//@property IBOutlet UILabel *vLbl5;
//@property IBOutlet UILabel *vLbl6;
//@property IBOutlet UILabel *vLbl7;
//@property IBOutlet UILabel *vLbl8;
//
//@property IBOutlet UILabel *lightLbl1;
//@property IBOutlet UILabel *lightLbl2;
//@property IBOutlet UILabel *lightLbl3;
//@property IBOutlet UILabel *lightLbl4;
//@property IBOutlet UILabel *lightLbl5;
//@property IBOutlet UILabel *lightLbl6;
//@property IBOutlet UILabel *lightLbl7;
//@property IBOutlet UILabel *lightLbl8;
//@property IBOutlet UILabel *lightLbl9;
//@property IBOutlet UILabel *lightLbl10;
//@property IBOutlet UILabel *lightLbl11;
//@property IBOutlet UILabel *lightLbl12;
//@property IBOutlet UILabel *lightLbl13;
//@property IBOutlet UILabel *lightLbl14;
//@property IBOutlet UILabel *lightLbl15;
//@property IBOutlet UILabel *lightLbl16;
//@property IBOutlet UILabel *lightLbl17;
//@property IBOutlet UILabel *lightLbl18;
//@property IBOutlet UILabel *lightLbl19;
//@property IBOutlet UILabel *lightLbl20;
//@property IBOutlet UILabel *lightLbl21;
//@property IBOutlet UILabel *lightLbl22;
//@property IBOutlet UILabel *lightLbl23;

@end

@implementation HeartRatePopHelpView

+ (HeartRatePopHelpView *)viewFromNibByVc:(UIViewController *)vc
{
    HeartRatePopHelpView *pop;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    pop = [array objectAtIndex:0];
    pop.fatherVC = vc;
    
    pop.openArr = [NSMutableArray arrayWithObjects:@0, @1, @2, nil];
    
    return pop;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.scrollEnabled = YES;
    self.tableView.layer.cornerRadius = 8;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.bounces = NO;
}

- (void)dismiss
{
    [self fadeOut];
}

- (void)show
{   //添加遮罩
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = UIColorFromRGBA(0x333333, 0.6);
    maskView.frame = CGRectMake( 0, -20, SScreenWidth, SScreenHeight);
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
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.alpha = 1;
                     }];
    
}

- (void)fadeOut {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Action

- (IBAction)bgAction:(id)sender {
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

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
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
            [btn setTitle:NSLocalizedString(@"Key function", nil) forState:UIControlStateNormal];
            break;
        case 1:
            [btn setTitle:NSLocalizedString(@"Vibration mode", nil) forState:UIControlStateNormal];
            break;
        case 2:
            [btn setTitle:NSLocalizedString(@"Indicator light", nil) forState:UIControlStateNormal];
            
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.openArr containsObject:@(section)]) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0: {
            if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
                return _normalCell;
            } else {
                return _normalCell_en;
            }
        }
            break;
        case 1: {
            if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
                return _quietCell;
            } else {
                return _quietCell_en;
            }
        }
            break;
        case 2: {
            if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
                return _setCell;
            } else {
                return _setCell_en;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height ;
    switch (indexPath.section) {
        case 0: {
            if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
                height = 460 + 80 + 10;

            } else {
                height = 460 + 80 + 80;
            }
        }
            break;
        case 1: {
            if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
                height = 300 + 120;

            } else {
                height = 300 + 300;

            }
        }
           
            break;
        case 2: {
            if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
                height = 880 + 230;
            } else {
                height = 880 + 290;
                
            }
        }
            break;

    }
    return height;
}

#pragma mark -- tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
