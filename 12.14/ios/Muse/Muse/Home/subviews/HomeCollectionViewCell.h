//
//  HomeCollectionViewCell.h
//  Muse
//
//  Created by pg on 16/5/13.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *cellData;

@property (nonatomic, weak) IBOutlet UIImageView *picIMV;
@property (nonatomic, weak) IBOutlet UILabel *contentLB;

@end
