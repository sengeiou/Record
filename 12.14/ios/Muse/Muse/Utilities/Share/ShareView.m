//
//  ShareView.m
//  Muse
//
//  Created by Ken.Jiang on 16/7/13.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "ShareView.h"
#import "UIView+FastKit.h"
#import "AppDelegate.h"
#import "ShareManager.h"

@interface ShareView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatButton;
@property (weak, nonatomic) IBOutlet UIButton *weiBoButton;


@end

@implementation ShareView

+ (instancetype)popShow {
    
    if ([ShareManager sharedManager].installedSharePlatforms == InstalledSharePlatformNone) {
        return nil;
    }
    
    ShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil] lastObject];
    [shareView show];
    
    return shareView;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    InstalledSharePlatform installed = [ShareManager sharedManager].installedSharePlatforms;
    self.qqButton.hidden = !(installed & InstalledSharePlatformQQ);
    self.weChatButton.hidden = !(installed & InstalledSharePlatformWeChat);
    self.weiBoButton.hidden = !(installed & InstalledSharePlatformWeiBo);
    _contentView.layer.cornerRadius = 8;
    _contentView.layer.masksToBounds = YES;

}

#pragma mark - Public

- (void)show {
    UIWindow *win = [AppDelegate appDelegate].window;
    self.frame = win.bounds;
    [win addSubview:self];
    
    _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1f, 0.1f);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.39 initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            _contentView.transform = CGAffineTransformIdentity;
                        } completion:nil];
}

- (void)dismiss {
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.25 animations:^{
        _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Private

- (IBAction)shareAction:(UIButton *)sender {
    if (!_captureView) {
        return;
    }
    
    UIImage *image = [_captureView snapshotImageAfterScreenUpdates:NO];
    ShareManager *shareMgr = [ShareManager sharedManager];
    switch (sender.tag) {
        case 0://QQ
            [shareMgr shareImage:image toPlatform:ShareTypeQZone];
            break;
        case 1://WeChat
            [shareMgr shareImage:image toPlatform:ShareTypeWeChatTimeline];
            break;
        case 2://
            [shareMgr shareImage:image toPlatform:ShareTypeWeiBo];
            break;
        case 3://
           [shareMgr shareImage:image toPlatform:ShareTypePengYou];
            break;
            
        default:
            break;
    }
    
    [self dismiss];
}
@end
