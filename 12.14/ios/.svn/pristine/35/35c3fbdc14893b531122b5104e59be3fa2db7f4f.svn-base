//
//  AddressTableViewCell.m
//  Muse
//
//  Created by pg on 16/6/7.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellFromNib {
    AddressTableViewCell *cell;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];//加载自定义cell的xib文件
    cell = [array objectAtIndex:0];
    return cell;
}

+ (CGFloat)height {
    return 67;
}

@end
