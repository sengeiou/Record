//
//  ContentBackView.m
//  Muse
//
//  Created by paycloud110 on 16/7/2.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "ContentBackView.h"

@implementation ContentBackView

- (instancetype)initWhetherBottomView:(BOOL)aBool
{
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGB(0xd7dcdd);
        [self setupDisplayChildView:aBool];
    }
    return self;
}
- (void)setupDisplayChildView:(BOOL)aBool
{
    UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_test2_1"]];
    if (aBool) {
        [self addSubview:bottomImageView];
        [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(20));
        }];
    }else {
    
    }   
}
@end
