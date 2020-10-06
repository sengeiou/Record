//
//  SpecialNumView.m
//  Muse
//
//  Created by apple on 16/6/5.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SpecialNumView.h"

#import "Photo.h"

@implementation SpecialNumView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setNum:(NSString *)num {
    
    [self layoutIfNeeded];
    
    if ([_num isEqualToString:num]) {
        return;
    }
    
    _num = num;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImage *base = [UIImage imageNamed:[NSString stringWithFormat:@"number_disk_0"]];
    base = [Photo scaleImage:base toWidth:0 toHeight:105];
    
    CGFloat margin = -29;
    CGFloat margin_x = 0;
    CGFloat special_w = 40;
    
    for (int i = 0; i < num.length; i++) {
        NSString *letter = [num substringWithRange:NSMakeRange(i, 1)];
        
        if ([letter isEqualToString:@"."]) {
            margin_x += (special_w + margin);
        } else if ([letter isEqualToString:@":"]) {
            margin_x += (special_w + margin);
        } else {
            margin_x += (base.size.width + margin);
        }
    }
    
    CGFloat x = (200 - (margin_x - margin))/2.f;
    for (int i = 0; i < num.length; i++) {
        NSString *letter = [num substringWithRange:NSMakeRange(i, 1)];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"number_disk_%@",letter]];
        
        CGFloat image_w = image.size.width;
        
        if ([letter isEqualToString:@"."]) {
            image = [UIImage imageNamed:@"number_disk_dot"];
            image_w = special_w;
        } else if ([letter isEqualToString:@":"]) {
            image = [UIImage imageNamed:@"number_disk_colon"];
            image_w = special_w;
        } else {
            image_w = base.size.width;
        }
        
        image = [Photo scaleImage:image toWidth:0 toHeight:105];
        
        UIImageView *imagev = [[UIImageView alloc] initWithImage:image];
        imagev.frame = CGRectMake(x, self.frame.size.height - base.size.height, (image_w + margin), image.size.height);
        imagev.contentMode = UIViewContentModeCenter;
        [self addSubview:imagev];
        
        x += imagev.frame.size.width;
    }
    
    self.myContentSize = CGSizeMake(margin_x - margin, base.size.height);
}

@end
