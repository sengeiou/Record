//
//  FloatingRootController.m
//  Muse
//
//  Created by jiangqin on 16/4/17.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "FloatingRootController.h"

#import "FloatingBallWindowViewController.h"

#import "AppDelegate.h"

#import <Masonry.h>

#import "FloatingView.h"

@interface FloatingRootController () {
    
    FloatingView *_floatingView;
    CGFloat _fullWinWidth;
    BOOL _expanded;
    
    CGPoint _beganPoint;
    CGPoint _prePoint;
    __weak UIWindow *_floatingWin;
}

/**  */
@property (nonatomic, strong) FloatingBallWindowViewController *ballWindow;

@end

@implementation FloatingRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    //redDot
    _floatingWin = [AppDelegate appDelegate].floatingWindow;
    _fullWinWidth = [UIScreen mainScreen].bounds.size.width;
    
    _floatingView = [FloatingView sharedView];
    
  //  [_floatingView.redDot removeFromSuperview];
    
  //  self.view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:_floatingView];
    _floatingView.autoresizingMask = UIViewAutoresizingNone;
    
    [self setWindowFrameExpanded:NO];
    _floatingView.frame = CGRectMake(0, 0, 306, 81);
//    self.view.frame = CGRectMake(10, 60, 306, 81);
    [self.view sizeToFit];
    _floatingView.userInteractionEnabled = NO;
    
    [_floatingView.centerButton addTarget:self
                                       action:@selector(showOrHideFriendsWindow:)
                             forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriendState) name:RefreshFriendStateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCantactShow) name:Notify_AddCantactShow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCantactHide) name:Notify_AddCantactHide object:nil];
    
    if (_ballWindow == nil) {
        
        _ballWindow = [[FloatingBallWindowViewController alloc] init];
        
        
        [self.view insertSubview:_ballWindow.view atIndex:0];
        
        [self addChildViewController:_ballWindow];
        
        UIScreen  *screen = [[UIApplication sharedApplication].delegate window].screen;
        
        
        
        CGFloat height = screen.bounds.size.height;
        
        CGFloat width = screen.bounds.size.width;
        
        if (width != 414) {
            
            if (width == 320) {
                [_ballWindow.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(_floatingView.mas_top).offset(53);
                    
                    make.right.equalTo(_floatingView.mas_right).offset(-24);
                    
                    //            make.centerY.equalTo(@(kScreenWidth / 2));
                    
                    make.width.equalTo(@(width - 48));
                    
                    make.height.equalTo(@(height - 175));
                    
                }];
            } else {
                [_ballWindow.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(_floatingView.mas_top).offset(53);
                    
                    make.right.equalTo(_floatingView.mas_right).offset(-24);
                    
                    //            make.centerY.equalTo(@(kScreenWidth / 2));
                    
                    make.width.equalTo(@(width - 48));
                    
                    make.height.equalTo(@(height - 282));
                    
                }];
            }
            
            
        } else if (kIOSVersion >= 9) {
            [_ballWindow.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(_floatingView.mas_top).offset(50);
                
                make.right.equalTo(_floatingView.mas_right).offset(-40);
                
                //            make.centerY.equalTo(@(kScreenWidth / 2));
                
                make.width.equalTo(@(width - 80));
                
                make.height.equalTo(@(height - 335));
            }];
        } else {
            [_ballWindow.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(_floatingView.mas_top).offset(175);
                
                make.right.equalTo(_floatingView.mas_right).offset(70);
                
                //            make.centerY.equalTo(@(kScreenWidth / 2));
                
                make.width.equalTo(@(width - 80));
                
                make.height.equalTo(@(height - 335));
            }];
        }
      
        
        
        
        
        _ballWindow.view.hidden = YES;
//        _floatingView.delegate = _ballWindow;
    }
    
}

- (void)addCantactShow {
    _isShowAddCantactVC = YES;
}

- (void)addCantactHide {
    _isShowAddCantactVC = NO;
}

- (void)refreshFriendState {
    [_floatingView refreshFriendList];
}


- (void)viewWillLayoutSubviews {
    
   // [super viewWillLayoutSubviews];
    
 //   self.view.frame = CGRectMake(10, 50, 306, 81);

    
}
#pragma mark - Actions

- (void)showInfoBar:(id)sender {
    
    if (_isShowAddCantactVC == YES) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self setWindowFrameExpanded:YES];
    _floatingView.frame = CGRectMake(_fullWinWidth - 306, 122, 306, 81);
    //    _floatingView.frame = CGRectMake(_fullWinWidth - 306, 122, 306 / 2, 81 / 2);
    }];
    
}

- (void)hideInfoBar:(id)sender {
    
    if (_isShowAddCantactVC == YES) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self setWindowFrameExpanded:NO];
        _ballWindow.view.hidden = YES;
        _floatingView.frame = CGRectMake(0, 0, 306, 81);
    }];
}

#pragma mark --<增加亲友列表>

//显示亲友列表的功能
- (void)showOrHideFriendsWindow:(id)sender {
    BOOL hide = NO;
    if (_ballWindow) {
        hide = !_ballWindow.view.hidden;
        [_floatingView refreshFriendList];
    } else {
        hide = NO;
    }
    NSArray *friendPartnershipArray = [[NSUserDefaults standardUserDefaults] objectForKey:FriendListPartishipKey];
    [UIView animateWithDuration:0.25 animations:^{
        self.ballWindow.view.hidden = hide;
        if (friendPartnershipArray.count > 0) {
            self.ballWindow.whetherClicked = YES;
        }else {
            self.ballWindow.whetherClicked = NO;
        }
    }];
}

#pragma mark - Helper 

- (void)setWindowFrameExpanded:(BOOL)expanded {
    
  
    
    _expanded = expanded;
    
    if (expanded) {
        _floatingWin.frame = [UIScreen mainScreen].bounds;
    } else {
        _floatingWin.frame = CGRectMake(_fullWinWidth - 40, 122, 40, 81);
    }
    
    _floatingView.userInteractionEnabled = expanded;
}

#pragma mark --<Friends>

- (FloatingBallWindowViewController *)ballWindow {
    
   
    
//    _ballWindow.friendsData = _floatingView.friendsData;
    
    return _ballWindow;
}

#pragma mark - Touch Events

- (CGPoint)moveFloatingViewWithTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:_floatingWin];
    CGFloat delta = point.x - _prePoint.x;
    
    CGPoint center = _floatingView.center;
    
    CGFloat x = center.x + delta;
    if ((x >= (_fullWinWidth - 306/2)) && (x <= (_fullWinWidth + (306 - 40)/2))) {
        center.x = x;
        _floatingView.center = center;
    }
    
    _prePoint = point;
    
    return point;
}

- (void)touchEnd:(UITouch *)touch {
    
    _prePoint = [touch locationInView:_floatingWin];
    
    CGFloat delta = _prePoint.x - _beganPoint.x;
    
   
    
    if (delta > 0) { // prepare to hide
        if (delta > 30) {
            [self hideInfoBar:nil];
        } else {
            [self showInfoBar:nil];
        }
    } else { // prepare to show
//        if (delta < -30) {
//            [self showInfoBar:nil];
//        } else {
//            [self hideInfoBar:nil];
//        }
        if (delta < -30) {
            [self showInfoBar:nil];
        } else {
            [self hideInfoBar:nil];
        }

    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    _beganPoint = [self moveFloatingViewWithTouch:[touches anyObject]];
    
    if (!_expanded) {
        _floatingWin.frame = [UIScreen mainScreen].bounds;
        _floatingView.frame = CGRectMake(_fullWinWidth - 40, 122, 306, 81);
        
        _beganPoint.x += _fullWinWidth - 40;
    }
    
    _prePoint = _beganPoint;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self moveFloatingViewWithTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchEnd:[touches anyObject]];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchEnd:[touches anyObject]];
}

@end
