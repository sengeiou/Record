//
//  MusePageControl.m
//  Muse
//
//  Created by pg on 16/6/7.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MusePageControl.h"

@interface MusePageControl ()
{
    
    UIImage* activeImage;
    
    UIImage* inactiveImage;
    
}


@property (nonatomic,strong)NSArray *imageArr;

@end

@implementation MusePageControl

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


- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    
    [self layoutSubviews];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat margin = 10;
    CGFloat x = (self.frame.size.width - _numberOfPages*activeImage.size.width - (_numberOfPages - 1) * margin)/2;
    CGFloat y = (self.frame.size.height - activeImage.size.height)/2;
    
    for (int i = 0 ; i<_numberOfPages; i++) {
        if(_currentPage == i)
        {
            UIImageView *imv = [[UIImageView alloc]initWithImage:activeImage];
            imv.frame = CGRectMake(x, y, activeImage.size.width, activeImage.size.height);
            
            [self addSubview:imv];
            x += (margin + activeImage.size.width);
        }
        else
        {
            UIImageView *imv = [[UIImageView alloc]initWithImage:inactiveImage];
            imv.frame = CGRectMake(x, y, inactiveImage.size.width, inactiveImage.size.height);
            
            [self addSubview:imv];
            x += (margin + inactiveImage.size.width);
        }
    }
}

@end
