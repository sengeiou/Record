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
    if (aBool) {
        UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_test2_1"]];
        [self addSubview:bottomImageView];
        [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(2));
        }];
    }else {
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_test2_3"]];
        [self addSubview:backImageView];
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
    }
}
@end
