//
//  LoginViewController.h
//  Muse
//
//  Created by jiangqin on 16/4/14.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSViewController.h"
#import "CountryCodeCell.h"


@interface LoginViewController : MSViewController


@property NSTimer *cdTimer; // 点击验证码 60 秒冷却
@property BOOL isAllowEnterCode; // 限制输入验证码
@property NSInteger timeCount; // 60 秒计数器

@property BOOL isLoginFailed;

@end
