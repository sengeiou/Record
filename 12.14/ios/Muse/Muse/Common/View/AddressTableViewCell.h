//
//  AddressTableViewCell.h
//  Muse
//
//  Created by pg on 16/6/7.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell

@property (weak,nonatomic)IBOutlet UILabel *titleLB;
@property (weak,nonatomic)IBOutlet UIImageView *imv;
@property (weak,nonatomic)IBOutlet UIImageView *chooseIMV;

@property (assign,nonatomic)id cellData;

+ (instancetype)cellFromNib;
+ (CGFloat)height;

@end
