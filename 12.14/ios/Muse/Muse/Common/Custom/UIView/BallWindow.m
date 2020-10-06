//
//  BallWindow.m
//  ShuaShua
//
//  Created by paycloud110 on 16/7/1.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "BallWindow.h"
#include <objc/runtime.h>

@interface BallWindow ()

/**  */
@property (nonatomic, assign) UIOffset offsetFromCenter;
/**  */
@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;
/**  */
@property (nonatomic, strong) UIControl *overlayView;
/**  */
@property (nonatomic, strong) UIView *hudView;
/**  */
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation BallWindow

+ (BallWindow *)shareBallWindow
{
    static BallWindow *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return _instance;
}
#pragma mark - Instance Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
    }
    return self;
}
#pragma mark - Show Methods

- (instancetype)showBottomDisplayView {
    return [self showBottomDisplayViewColor:UIColorFromRGBA(0x333333, 0.6)];
}

- (instancetype)showBottomDisplayViewColor:(UIColor *)currentColor {
    // 设置背景色
    self.backgroundColor = currentColor;
  //  self.backgroundColor = [UIColor redColor];
    if (!self.overlayView.superview) {
#if !defined(SV_APP_EXTENSIONS)
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
        }
#else
#endif
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    if (!self.superview) {
        [self.overlayView addSubview:self];
    }
    
    self.overlayView.userInteractionEnabled = YES;
    self.hudView.isAccessibilityElement = YES;
    
    self.overlayView.hidden = NO;
    [self positionHUD:nil];
    
    if(self.alpha != 1 || self.hudView.alpha != 1) {
        self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
        
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3, 1/1.3);
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
                         }];
        
        [self setNeedsDisplay];
    }
    
    return self;
}

- (void)dismiss {
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 0.8f, 0.8f);
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         if(self.alpha == 0.0f || self.hudView.alpha == 0.0f) {
                             self.alpha = 0.0f;
                             self.hudView.alpha = 0.0f;
                             
                             [[NSNotificationCenter defaultCenter] removeObserver:self];
                             [_hudView removeFromSuperview];
                             _hudView = nil;
                             
                             [_overlayView removeFromSuperview];
                             _overlayView = nil;
                             
                             UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
                             
                             // Tell the rootViewController to update the StatusBar appearance
#if !defined(SV_APP_EXTENSIONS)
                             UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
                             if ([rootController respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                                 [rootController setNeedsStatusBarAppearanceUpdate];
                             }
#endif
                         }
                     }];
}
- (void)positionHUD:(NSNotification*)notification
{
    CGFloat keyboardHeight = 0.0f;
    double animationDuration = 0.0;
    
    self.frame = UIScreen.mainScreen.bounds;
    
#if !defined(SV_APP_EXTENSIONS)
    UIInterfaceOrientation orientation = UIApplication.sharedApplication.statusBarOrientation;
#else
    UIInterfaceOrientation orientation = CGRectGetWidth(self.frame) > CGRectGetHeight(self.frame) ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationPortrait;
#endif
    // no transforms applied to window in iOS 8, but only if compiled with iOS 8 sdk as base sdk, otherwise system supports old rotation logic.
    BOOL ignoreOrientation = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)]) {
        ignoreOrientation = YES;
    }
#endif
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            if(ignoreOrientation || UIInterfaceOrientationIsPortrait(orientation))
                keyboardHeight = CGRectGetHeight(keyboardFrame);
            else
                keyboardHeight = CGRectGetWidth(keyboardFrame);
        }
    } else {
        keyboardHeight = self.visibleKeyboardHeight;
    }
    
    CGRect orientationFrame = self.bounds;
#if !defined(SV_APP_EXTENSIONS)
    CGRect statusBarFrame = UIApplication.sharedApplication.statusBarFrame;
#else
    CGRect statusBarFrame = CGRectZero;
#endif
    
    if(!ignoreOrientation && UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = CGRectGetWidth(orientationFrame);
        orientationFrame.size.width = CGRectGetHeight(orientationFrame);
        orientationFrame.size.height = temp;
        
        temp = CGRectGetWidth(statusBarFrame);
        statusBarFrame.size.width = CGRectGetHeight(statusBarFrame);
        statusBarFrame.size.height = temp;
    }
    
    CGFloat activeHeight = CGRectGetHeight(orientationFrame);
    
    if(keyboardHeight > 0)
        activeHeight += CGRectGetHeight(statusBarFrame)*2;
    
    activeHeight -= keyboardHeight;
    CGFloat posY = floor(activeHeight * 0.45);
    CGFloat posX = CGRectGetWidth(orientationFrame)/2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    if (ignoreOrientation) {
        rotateAngle = 0.0;
        newCenter = CGPointMake(posX, posY);
    } else {
        switch (orientation) {
            case UIInterfaceOrientationPortraitUpsideDown:
                rotateAngle = M_PI;
                newCenter = CGPointMake(posX, CGRectGetHeight(orientationFrame)-posY);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                rotateAngle = -M_PI/2.0f;
                newCenter = CGPointMake(posY, posX);
                break;
            case UIInterfaceOrientationLandscapeRight:
                rotateAngle = M_PI/2.0f;
                newCenter = CGPointMake(CGRectGetHeight(orientationFrame)-posY, posX);
                break;
            default: // as UIInterfaceOrientationPortrait
                rotateAngle = 0.0;
                newCenter = CGPointMake(posX, posY);
                break;
        }
    }
    
    if(notification) {
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [self moveToPoint:newCenter rotateAngle:rotateAngle];
                             [self.hudView setNeedsDisplay];
                         } completion:NULL];
    } else {
        [self moveToPoint:newCenter rotateAngle:rotateAngle];
        [self.hudView setNeedsDisplay];
    }
    
}
- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle
{
    self.hudView.transform = CGAffineTransformMakeRotation(angle);
    self.hudView.center = CGPointMake(newCenter.x + self.offsetFromCenter.horizontal, newCenter.y + self.offsetFromCenter.vertical);
}
- (void)setWhetherExistTap:(BOOL)whetherExistTap
{
    _whetherExistTap = whetherExistTap;
    if (whetherExistTap) {
        [self addGestureRecognizer:self.tapGesture];
    }else {
        [self removeGestureRecognizer:self.tapGesture];
    }
}
#pragma mark --<layz>
- (UIControl *)overlayView
{
    if(!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _overlayView;
}

- (UIView *)hudView {
    if(!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _hudView.backgroundColor = [UIColor clearColor];
        // 圆角
        _hudView.layer.cornerRadius = 14;
        _hudView.layer.masksToBounds = YES;
        
        _hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
    }
    // 蒙版处的点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_hudView addGestureRecognizer:tap];
    
    if(!_hudView.superview)
        [self addSubview:_hudView];
    
    return _hudView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (_tapGesture == nil) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    }
    return _tapGesture;
}

- (CGFloat)visibleKeyboardHeight {
#if !defined(SV_APP_EXTENSIONS)
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        if ([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")]) {
            return CGRectGetHeight(possibleKeyboard.bounds);
        } else if ([possibleKeyboard isKindOfClass:NSClassFromString(@"UIInputSetContainerView")]) {
            for (__strong UIView *possibleKeyboardSubview in [possibleKeyboard subviews]) {
                if ([possibleKeyboardSubview isKindOfClass:NSClassFromString(@"UIInputSetHostView")]) {
                    return CGRectGetHeight(possibleKeyboardSubview.bounds);
                }
            }
        }
    }
#endif
    return 0;
}

/** 获取控件所有的属性 */
+ (void)getIvars:(Class)aClass {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(aClass, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        MSLog(@"getIvars--%s----%s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
    }
    free(ivars);
}

#pragma mark --<通知代理>
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if ([self.delegate respondsToSelector:@selector(ballWindow:)]) {
//        [self.delegate ballWindow:self];
//    }
//}
@end
