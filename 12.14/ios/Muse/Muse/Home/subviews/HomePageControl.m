//
//  HomePageControl.m
//  Muse
//
//  Created by pg on 16/5/13.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "HomePageControl.h"

@implementation HomePageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    activeImage = [UIImage imageNamed:@"dot_homepage_on"];
    inactiveImage = [UIImage imageNamed:@"dot_homepage_none"];
    
    return self;
}

- (void)awakeFromNib {
    activeImage = [UIImage imageNamed:@"dot_homepage_on"];
    inactiveImage = [UIImage imageNamed:@"dot_homepage_none"];
    [super awakeFromNib];
}

- (void)updateDots {
    for (int i=0; i<[self.subviews count]; i++) {
        UIView* dot = [self.subviews objectAtIndex:i];
       
        CGSize size = activeImage.size;//自定义圆点的大小
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
        if (i == self.currentPage) {
            UIImageView *iv = [[UIImageView alloc] initWithImage:activeImage];
            iv.frame = CGRectMake(0, 0, size.width, size.height);
            
            [dot.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [dot addSubview:iv];
        } else {
            UIImageView *iv = [[UIImageView alloc]initWithImage:inactiveImage];
            iv.frame = CGRectMake(0, 0, size.width, size.height);
            
            [dot.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [dot addSubview:iv];
        }
    }
}

- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    
    [self updateDots];
}

@end
