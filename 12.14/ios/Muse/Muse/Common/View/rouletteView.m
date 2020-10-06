//
//  rouletteView.m
//  Muse
//
//  Created by apple on 16/5/8.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "rouletteView.h"

@interface rouletteView ()

@property (nonatomic,weak) IBOutlet UILabel *content0LB;
@property (nonatomic,weak) IBOutlet UILabel *content1LB;
@property (nonatomic,weak) IBOutlet UILabel *content2LB;

@end

@implementation rouletteView

+ (instancetype)rouletteViewWithContent0:(NSString *)content0 content1:(NSString *)content1 content2:(NSString *)content2 {
    rouletteView *result = [[[NSBundle mainBundle] loadNibNamed:@"rouletteView" owner:self options:nil] firstObject];
    result.content0LB.text = content0;
    result.content1LB.text = content1;
    result.content2LB.text = content2;
    return result;
}

@end
