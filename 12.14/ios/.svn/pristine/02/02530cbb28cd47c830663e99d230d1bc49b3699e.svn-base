//
//  SettingSubTableViewCell.h
//  Muse
//
//  Created by paycloud110 on 16/7/17.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "WSTableViewCell.h"
@class SettingSubTableViewCell;

@protocol SettingSubTableViewCellDelegate <NSObject>

- (void)settingSubTableViewCell:(SettingSubTableViewCell *)settingSubTableViewCell withButton:(UIButton *)button;

@end

@interface SettingSubTableViewCell : WSTableViewCell

/**  */
@property (nonatomic, weak) id<SettingSubTableViewCellDelegate> delegate;
/** woshi  */
@property (nonatomic, weak) UILabel *leftLabel;

- (void)setupChildViewOnlyLeft:(NSString *)text;
- (void)setupChildView:(NSString *)text buttonState:(BOOL)aBool;

@end
