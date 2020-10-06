//
//  HeartRatePopView.m
//  Muse
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "HeartRatePopView.h"
#import "HeartRateDataManager.h"
#import "MBProgressHUD+Simple.h"
#import "AppDelegate.h"

@interface HeartRatePopView ()

@property (nonatomic,weak) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *expandedSections;

@property (nonatomic,strong) IBOutlet UITableViewCell *quietCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *quietCell_en;

@property (nonatomic,strong) IBOutlet UITableViewCell *normalCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *normalCell_en;

@property (nonatomic,strong) IBOutlet UITableViewCell *setCell;
@property (nonatomic,strong) IBOutlet UILabel *alertTextLbl;

@property (nonatomic,weak) IBOutlet UIView *overTFView;
@property (weak, nonatomic) IBOutlet UIButton *heartRateAlertButton;

@property (weak, nonatomic) IBOutlet UITextField *heartRateAlertTF;

@property (strong, nonatomic) UITapGestureRecognizer *tapGes;

@end

@implementation HeartRatePopView

+ (HeartRatePopView *)viewFromNibByVc:(UIViewController *)vc {
    HeartRatePopView *pop;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    pop = [array objectAtIndex:0];
    
    pop.expandedSections = [NSMutableArray arrayWithObjects:@0, @1, @2, nil];
   
    return pop;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIView *mask = [[UIView alloc] init];
    mask.backgroundColor = UIColorFromRGBA(0x333333, 0.6);
    mask.frame = CGRectMake(0, -20, SScreenWidth, SScreenHeight);
    [self insertSubview:mask atIndex:0];
    
    NSString *alertHeartRate = [HeartRateDataManager alertHeartRate];
    _heartRateAlertTF.text = alertHeartRate;
    if ([alertHeartRate floatValue] > 0) {
        [_heartRateAlertButton setTitle:[NSString stringWithFormat:@"%@%@", alertHeartRate, NSLocalizedString(@"Time/Min", nil)]
                               forState:UIControlStateNormal];
    }
    
    
    _alertTextLbl.text = [NSString stringWithFormat:@"%@\n%@\n%@", NSLocalizedString(@"layout_xinlv_settip1", nil), NSLocalizedString(@"layout_xinlv_settip2", nil),NSLocalizedString(@"layout_xinlv_settip3", nil)];
    
    self.tableView.layer.cornerRadius = 8;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.bounces = NO;
}

- (void)dismiss {
    [self endEditingHeartRate:nil];
    
    [self fadeOut];
    _tapGes = nil;
}

- (void)show {

    _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingHeartRate:)];
    [[AppDelegate appDelegate].popoverWindow addGestureRecognizer:_tapGes];
    
    [[AppDelegate appDelegate].popoverWindow addSubview:self];
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
            [AppDelegate appDelegate].popoverWindow = nil;
        }
    }];
}

#pragma mark - Action

- (IBAction)overTFAction:(id)sender {
    self.overTFView.hidden = YES;
    [_heartRateAlertTF becomeFirstResponder];
}

- (IBAction)bgAction:(id)sender {
    [self dismiss];
}

- (void)sectionAction:(UIButton *)btn {
    NSInteger tag = btn.tag;
    if([self.expandedSections containsObject:@(tag)]) {
        [self.expandedSections removeObject:@(tag)];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:tag]] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.expandedSections addObject:@(tag)];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:tag]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITextFieldDelegate

- (void)endEditingHeartRate:(id)sender {
    if (_heartRateAlertTF.isEditing) {
        [self textFieldShouldReturn:_heartRateAlertTF];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger rate = [textField.text integerValue];
    
  
#warning mark---心率设置范围
    if (rate < 40 || rate > 225) {
      //  [MBProgressHUD showHUDWithMessageOnly:@"请设置正确的心率数值"];
        [MBProgressHUD showError:NSLocalizedString(@"pleaseSetNormalCount", nil) toView:self];
    } else {
        [HeartRateDataManager saveAlertHeartRate:textField.text];
        [textField resignFirstResponder];
    }
    
    return YES;
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
            [btn setTitle:NSLocalizedString(@"layout_xinlv_title1", nil) forState:UIControlStateNormal];
            break;
        case 1:
            [btn setTitle:NSLocalizedString(@"layout_xinlv_title2", nil) forState:UIControlStateNormal];
            break;
        case 2:
            [btn setTitle:NSLocalizedString(@"layout_xinlv_title3", nil) forState:UIControlStateNormal];
            
            break;
            
        default:
            break;
    }
    
    return btn;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .5f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.expandedSections containsObject:@(section)]) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0: {
            if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
                return _quietCell;

            } else {
                return _quietCell_en;

            }
        }
            break;
        case 1: {
            if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
                return _normalCell;

            } else {
                return _normalCell_en;

            }
        }
            break;
        case 2: {
                return _setCell;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 60;
    
    switch (indexPath.section) {
        case 0:
            height = 74;
            break;
        case 1:
            height = 138;
            break;
        case 2: {
            if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
                height = 138;
                
            } else {
                height = 190;
                
            }
        }
            break;
        default:
            break;
    }
    return height;
}

#pragma mark -- tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
