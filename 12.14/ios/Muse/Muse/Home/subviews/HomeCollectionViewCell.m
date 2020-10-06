//
//  HomeCollectionViewCell.m
//  Muse
//
//  Created by pg on 16/5/13.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellData:(NSDictionary *)cellData {
    if ([_cellData isEqualToDictionary:cellData]) {
        return;
    }
    
    _cellData = cellData;
    _picIMV.image = cellData[@"image"];
    _contentLB.text = cellData[@"name"];
}

@end
