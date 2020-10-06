//
//  SectionTitleTableViewCell.m
//  Muse
//
//  Created by apple on 16/6/5.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SectionTitleTableViewCell.h"

@implementation SectionTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellFromNib {
    SectionTitleTableViewCell *cell;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];//加载自定义cell的xib文件
    cell = [array objectAtIndex:0];
    return cell;
}

+ (CGFloat)height
{
    return 28;
}

@end
