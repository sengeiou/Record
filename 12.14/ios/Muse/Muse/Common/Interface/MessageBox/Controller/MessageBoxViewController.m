//
//  MessageBoxViewController.m
//  Muse
//
//  Created by paycloud110 on 16/8/14.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MessageBoxViewController.h"


#import "AppDelegate.h"

#import "NewsNoticeViewController.h"

#import "NSTimer+FastKit.h"


#define angle2Radio(angle) ((angle) * M_PI / 180.0)

#define MessageBoxWandH 64

NSString *const HADENTERMESSAGERVC = @"HADENTERMESSAGERVC";


@interface MessageBoxViewController ()

/**  */
@property (nonatomic, weak) UIWindow *messageFloatingWin;
/**  */
@property (nonatomic, strong) UIView *floatingView;
/**  */
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, assign) CGRect  messageFloatingWinFrame;

@property (nonatomic, strong) UIImageView *redMessageCountImage;

@property (nonatomic, strong) UILabel *messageCountLabel;

@property (weak, nonatomic) NSTimer *monitorTimer;


@end

@implementation MessageBoxViewController

CGFloat winFrameX = 0;
CGFloat winFrameY = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.messageFloatingWin = [AppDelegate appDelegate].messageFloatingWindow;
    
    [self.view addSubview:self.floatingView];
    
    [self.floatingView addSubview:self.iconImageView];

    
    self.messageFloatingWin.frame = CGRectMake(SScreenWidth - MessageBoxWandH, 20 + 108 + 72, MessageBoxWandH, MessageBoxWandH);
    self.floatingView.frame = CGRectMake(0, 0, MessageBoxWandH, MessageBoxWandH);
    self.iconImageView.frame = CGRectMake(0, 0, MessageBoxWandH, MessageBoxWandH);
    
    
    [self redMessageCountImage];
    [self messageCountLabel];
    
   
    //闹钟震动效果
    [self setupClockShake];
    
    
    [kNotificationCenter addObserver:self selector:@selector(startUpdateTimer) name:Notify_AppBecomeActive object:nil];
    [kNotificationCenter addObserver:self selector:@selector(stopUpdateTimer) name:Notify_AppEnterBg object:nil];

    
}
- (void)onUpdateTimerTicked:(NSTimer *)sender {
    
    NSMutableArray *countOfMessages = [[DBManager sharedManager] readMessageBoxTableAllData];
    
    
    NSInteger inte = countOfMessages.count;
    
   
  
    
    NSInteger hadRead = [[kUserDefaults objectForKey:@"NEWHADENTERMESSAGERVC"]integerValue];
 
    if (inte >= hadRead ) {
        
        inte -= hadRead ;
        
//        NSString *countStr = [NSString stringWithFormat:@"%lu",inte];
        
      //  [kUserDefaults setObject:countStr forKey:@"NEWHADENTERMESSAGERVC"];

    }
    
//    MSLog(@"%ld %ld",inte,hadRead); 连接频率消息
   //   MSLog(@"%ld",[[self.redMessageCountImage subviews] count]);
   

 //   if (![[self.redMessageCountImage subviews] count] ) {
    
    
    [self.view addSubview:self.redMessageCountImage];
   
//    MSLog(@"%ld",[[self.redMessageCountImage subviews] count]);
   // }
    
    if (inte <= 0 ) {
        
        [self.redMessageCountImage removeFromSuperview];
        
        return;
    }
    
    self.messageCountLabel.text = [NSString stringWithFormat:@"%ld",inte];
        
    
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    
    [self startUpdateTimer];
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
   
    [self stopUpdateTimer];

}
-(void) stopUpdateTimer
{
    if (_monitorTimer) {
        [_monitorTimer setFireDate:[NSDate distantFuture]];
    }
}
-(void) startUpdateTimer
{
    if (_monitorTimer == nil) {
        _monitorTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onUpdateTimerTicked:) userInfo:nil repeats:YES];
        [_monitorTimer fire];
    } else {
        [_monitorTimer setFireDate:[NSDate date]];
    }
}
//闹钟震动效果
- (void)setupClockShake {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.values = @[@(angle2Radio(-8)), @(angle2Radio(8)),@(angle2Radio(-8))];
    [animation setDuration:0.02];
    animation.repeatCount = HUGE;
    _iconImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.iconImageView.layer addAnimation:animation forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.iconImageView.layer removeAllAnimations];
    });
}

- (void)moveFloatingView:(UIPanGestureRecognizer *)pan
{
    CGPoint transP = [pan translationInView:self.floatingView];
    
    self.floatingView.transform = CGAffineTransformTranslate(self.floatingView.transform, transP.x, transP.y);
    
    [pan setTranslation:CGPointZero inView:self.floatingView];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
         winFrameX = self.messageFloatingWin.x;
         winFrameY = self.messageFloatingWin.y;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        CGFloat locationX = self.floatingView.frame.origin.x + winFrameX;
        CGFloat locationY = self.floatingView.frame.origin.y + winFrameY;
        
        if (locationX > SScreenWidth - MessageBoxWandH) {
            self.messageFloatingWin.frame = CGRectMake(SScreenWidth - MessageBoxWandH, locationY, MessageBoxWandH, MessageBoxWandH);
        }else if (locationX < 0) {
            self.messageFloatingWin.frame = CGRectMake(0, locationY, MessageBoxWandH, MessageBoxWandH);
        }else if (locationY < 0) {
            self.messageFloatingWin.frame = CGRectMake(locationX, 0, MessageBoxWandH, MessageBoxWandH);
        }else if (locationY > SScreenHeight - MessageBoxWandH) {
            self.messageFloatingWin.frame = CGRectMake(locationX, SScreenHeight - MessageBoxWandH, MessageBoxWandH, MessageBoxWandH);
        }else {
            self.messageFloatingWin.frame = CGRectMake(locationX, locationY, MessageBoxWandH, MessageBoxWandH);
        }
        self.floatingView.frame = CGRectMake(0, 0, MessageBoxWandH, MessageBoxWandH);
    }
}
- (void)pointIconImageView:(UITapGestureRecognizer *)tap
{
    self.iconImageView.hidden = YES;
    self.redMessageCountImage.hidden = YES;
    
    _messageFloatingWinFrame = self.messageFloatingWin.frame;
    self.messageFloatingWin.frame = CGRectMake(0  , 0, SScreenWidth  , SScreenHeight);
    
    NewsNoticeViewController *vc = [[NewsNoticeViewController alloc]init];
    vc.messageFloatingWinFrame = _messageFloatingWinFrame;
    
    vc.iconImageView = _iconImageView;
    
    vc.redMessageCountImage = _redMessageCountImage;
    
    vc.messageFloatingWin = _messageFloatingWin;

    [self presentViewController:vc animated:YES completion:nil];
    
   // [[DBManager sharedManager] cancelMessageBoxTableAllData];
    
   // [kUserDefaults setBool:YES forKey:HADENTERMESSAGERVC];
}
#pragma mark --<layz>
- (UIView *)floatingView
{
    if (_floatingView == nil) {
        _floatingView = [[UIView alloc] init];
        
        UIGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveFloatingView:)];
        [_floatingView addGestureRecognizer:ges];
    }
    return _floatingView;
}
- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"btn_homepage_news"];
        _iconImageView.userInteractionEnabled = YES;
        
        UIGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pointIconImageView:)];
        [_iconImageView addGestureRecognizer:ges];
    }
    return _iconImageView;
}
- (UIImageView *)redMessageCountImage
{
    if (_redMessageCountImage == nil) {
        
        _redMessageCountImage = [UIImageView hyb_imageViewWithImage:@"dot_homepage_red" superView:self.floatingView constraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(@(10));
            make.left.equalTo(@(12));
           make.size.mas_equalTo(CGSizeMake(18, 18));
            
            }];
        
        //_redMessageCountImage.alpha = 0.7;
        
       
    }
    return _redMessageCountImage;
}

- (UILabel *)messageCountLabel {
    
    if (_messageCountLabel == nil) {
        kWeakObject(self)
        
        _messageCountLabel = [UILabel hyb_labelWithFont:11 superView:weakObject.redMessageCountImage constraints:^(MASConstraintMaker *make) {
            
            make.center.mas_equalTo(weakObject.redMessageCountImage.center);
            
        }];
//        _messageCountLabel.textColor = UIColorFromRGB(0xa5a5a5);
        _messageCountLabel.textColor = [UIColor whiteColor];
    }
    return _messageCountLabel;
}



@end
