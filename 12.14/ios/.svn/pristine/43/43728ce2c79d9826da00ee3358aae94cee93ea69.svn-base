//
//  ClockSettingView.h
//  Muse
//
//  Created by Ken.Jiang on 23/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClockSettingViewDismissCompletion)();

@interface ClockSettingView : UIView

@property (weak, readonly, nonatomic) UITableView *tableView;

@property (copy, nonatomic) ClockSettingViewDismissCompletion dismissBlock;

+ (ClockSettingView *)viewFromNib;

@property (assign, nonatomic) BOOL fullMode; //DEFUALT NO

/**
 *  弹出闹铃设置页面，fullMode YES 下无效
 */
- (void)show;

/**
 *  消失闹铃设置页面，fullMode YES 下无效
 */
- (void)dismiss;

@end
