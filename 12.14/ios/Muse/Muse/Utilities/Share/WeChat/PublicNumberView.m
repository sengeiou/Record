//
//  PublicNumberView.m
//  Muse
//
//  Created by 博云智慧 on 16/9/28.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "PublicNumberView.h"

#import "UIView+FastKit.h"

#import "AppDelegate.h"

#import "ShareManager.h"

#import "WXApi.h"

@interface PublicNumberView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end


@implementation PublicNumberView

+ (instancetype)popShow {
    
    
    PublicNumberView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"PublicNumberView" owner:nil options:nil] lastObject];
    
    
    [shareView show];
    
    return shareView;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    _contentView.layer.cornerRadius = 8;
    _contentView.layer.masksToBounds = YES;
    
}

#pragma mark - Public

- (void)show {
    
    _titleLbl.text = NSLocalizedString(@"publicnumberbtn", nil);
    
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
    
    //    JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc]init];
    //    //    req.username = @"gh_27f25014d7e8";
    //    req.username = @"gh_2c00ed526a3d";
    //    req.extMsg = @"";
    //    req.profileType =WXBizProfileType_Normal;
    //    [WXApi sendReq:req];

    
//    JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc]init];
//    
//    req.username = @"gh_2c00ed526a3d"; //Mustert
//    
//    req.profileType = WXBizProfileType_Normal;
//    
//    req.extMsg = @"";
//    
//    [WXApi sendReq:req];

    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.museheart.cn/"]];
    
        
    [self dismiss];
}

@end
