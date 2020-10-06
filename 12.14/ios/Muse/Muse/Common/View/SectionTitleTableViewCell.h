//
//  SectionTitleTableViewCell.h
//  Muse
//
//  Created by apple on 16/6/5.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

//
@interface SectionTitleTableViewCell : UITableViewCell

@property (weak,nonatomic)IBOutlet UILabel *titleLB;
@property (weak,nonatomic)IBOutlet UIImageView *imv;

@property (assign,nonatomic)id cellData;

+ (instancetype)cellFromNib;
+ (CGFloat)height;

@end
