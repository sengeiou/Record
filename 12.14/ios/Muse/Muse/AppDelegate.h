//
//  AppDelegate.h
//  Muse
//
//  Created by jiangqin on 16/4/12.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  浮动窗window (亲友数据)
 */
@property (strong, nonatomic) UIWindow *floatingWindow;

/**
 *  消息提醒窗
 */
@property (strong, nonatomic) UIWindow *messageFloatingWindow;

/**
 *  临时弹出窗，层级最高
 */
@property (strong, nonatomic) UIWindow *popoverWindow;


@property BOOL isFirstEnterApp; //是否第一次进入 App

@property BOOL isBackgroundMode;


+ (instancetype)appDelegate;

- (void)relogin;

@end

