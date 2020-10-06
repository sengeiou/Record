//
//  RippleView.h
//  Muse
//
//  Created by jiangqin on 16/4/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RippleView : UIView

@property (strong, nonatomic) UIImage *rippleImage;

- (void)startRipple;

- (void)stop;

@end
