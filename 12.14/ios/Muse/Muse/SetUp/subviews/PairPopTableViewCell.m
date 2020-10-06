//
//  PairPopTableViewCell.m
//  Muse
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "PairPopTableViewCell.h"

@implementation PairPopTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (id)cellFromNib {
    PairPopTableViewCell *cell;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];//加载自定义cell的xib文件
    cell = [array objectAtIndex:0];
    return cell; 
}

+ (CGFloat)height {
    return 44;
}

- (void)setCellData:(id)cellData {
    _cellData = cellData;
}

- (IBAction)deleteAction:(id)sender {
    if(self.deleteBlock) {
        self.deleteBlock();
    }
}


@end
