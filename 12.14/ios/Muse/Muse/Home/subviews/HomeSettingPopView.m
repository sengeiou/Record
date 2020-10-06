//
//  HomeSettingPopView.m
//  Muse
//
//  Created by pg on 16/6/13.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "HomeSettingPopView.h"

@interface HomeSettingPopView ()

@property IBOutlet UIView *backView;

@end


@implementation HomeSettingPopView

- (instancetype)init
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    self = [array objectAtIndex:0];
    
    if(self)
    {
        self.backView.layer.cornerRadius = 8;
        self.backView.layer.masksToBounds = YES;
    }
    
    return self;
}

- (IBAction)bgAction:(id)sender
{
    [self dismiss];
}

- (void)dismiss
{
    [self fadeOut];
}

- (void)showOnVC:(UIViewController *)vc;
{
    [vc.view addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(vc.view);
    }];
    
    [self fadeIn];
}


- (void)fadeIn
{
    self.transform = CGAffineTransformMakeTranslation(0, 0);
    self.alpha = 0;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.alpha = 1;
                     }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
