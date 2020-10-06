//
//  HeartRatePopView.h
//  Muse
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartRatePopView : UIView

+ (HeartRatePopView *)viewFromNibByVc:(UIViewController *)vc;

- (void)dismiss;
- (void)show;

@end
