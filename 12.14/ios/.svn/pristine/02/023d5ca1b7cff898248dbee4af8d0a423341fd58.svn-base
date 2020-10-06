//
//  BallWindow.h
//  ShuaShua
//
//  Created by paycloud110 on 16/7/1.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BallWindow;

@protocol BallWindowDelegate <NSObject>

- (void)ballWindow:(BallWindow *)ballWindow;

@end

@interface BallWindow : UIView

+ (BallWindow *)shareBallWindow;

/** 点按手势 */
@property (nonatomic, assign) BOOL whetherExistTap;

/**  */
@property (nonatomic, weak) id<BallWindowDelegate> delegate;

/** 显示 */
- (instancetype)showBottomDisplayView; // 默认white 1 alpha 0.5
- (instancetype)showBottomDisplayViewColor:(UIColor *)currentColor;
/** 消失 */
- (void)dismiss;

/** 获取传入类所有的属性 */
+ (void)getIvars:(Class)aClass;

@end
