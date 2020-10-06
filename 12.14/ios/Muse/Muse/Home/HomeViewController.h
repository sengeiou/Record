//
//  HomeViewController.h
//  Muse
//
//  Created by pg on 16/5/13.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSViewController.h"

#import <iCarousel/iCarousel.h>
#import "CameraViewController.h"

#import "HeartTestManager.h"

@interface HomeViewController : MSViewController

@property (nonatomic,strong) NSArray *mycollectionViewArr;

@property (nonatomic,strong) NSArray *progressItems;

@property (nonatomic,strong) iCarousel *carousel;


@end
