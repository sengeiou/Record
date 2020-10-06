//
//  SettingHeaderBar.m
//  Muse
//
//  Created by Ken.Jiang on 16/7/18.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SettingHeaderBar.h"
#import "MSViewController.h"

@implementation SettingHeaderBar

+ (instancetype)headerBarFromNib {
    return [[[NSBundle mainBundle] loadNibNamed:@"SettingHeaderBar" owner:self options:nil] lastObject];
}

+ (instancetype)addHeaderBarToController:(MSViewController *)viewController
                                withType:(SettingHeaderBarType)type {
    SettingHeaderBar *headerBar = [SettingHeaderBar headerBarFromNib];
    [headerBar setType:type];
    [headerBar.backButton addTarget:viewController action:@selector(backToLastController:) forControlEvents:UIControlEventTouchUpInside];
    [viewController.view addSubview:headerBar];
    [headerBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@108);
    }];
    
    return headerBar;
}

- (void)setType:(SettingHeaderBarType)type {
   
    switch (type) {
        case SettingHeaderBarNotice:
            _headerIconView.image = [UIImage imageNamed:@"icon_homepage2_notice"];
            break;
        case SettingHeaderBarAntiLost:
            _headerIconView.image = [UIImage imageNamed:@"icon_homepage_close"];
            break;
        case SettingHeaderBarSecretTalk:
            _headerIconView.image = [UIImage imageNamed:@"icon_homepage2_mini"];
            break;
        case SettingHeaderBarSOS:
            _headerIconView.image = [UIImage imageNamed:@"icon_homepage2_help"];
            break;
        case SettingHeaderBarClock:
            _headerIconView.image = [UIImage imageNamed:@"icon_homepage2_clock"];
            break;
        case SettingHeaderBarMorse:
            _headerIconView.image = [UIImage imageNamed:@"icon_homepage2_argot"];
            break;
        case SettingHeaderBarSettings:
            _headerIconView.image = [UIImage imageNamed:@"icon_homepage2_set"];
            break;
        case SettingHeaderBarFriendList:
            _headerIconView.image = [UIImage imageNamed:NSLocalizedString(@"word_loading_people", nil)];
            break;
        case SettingHeaderBarPhoto:
            _headerIconView.image = [UIImage imageNamed:@"icon_homepage_photo2"];
            break;
        default:
            break;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
@end
