//
//  SettingHeaderBar.h
//  Muse
//
//  Created by Ken.Jiang on 16/7/18.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SettingHeaderBarType) {
    SettingHeaderBarNotice,
    SettingHeaderBarAntiLost,
    SettingHeaderBarSecretTalk,
    SettingHeaderBarSOS,
    SettingHeaderBarClock,
    SettingHeaderBarMorse,
    SettingHeaderBarSettings,
    SettingHeaderBarFriendList,
    SettingHeaderBarPhoto
};

@class MSViewController;

@interface SettingHeaderBar : UIView

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerIconView;

+ (instancetype)headerBarFromNib;
+ (instancetype)addHeaderBarToController:(MSViewController *)viewController
                                withType:(SettingHeaderBarType)type;

- (void)setType:(SettingHeaderBarType)type;

@end
