//
//  sleep2TitleView.m
//  Muse
//
//  Created by apple on 16/5/8.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "sleep2TitleView.h"

@interface sleep2TitleView ()

@property (nonatomic,weak) IBOutlet UILabel *content0LB;
@property (nonatomic,weak) IBOutlet UILabel *content1LB;
@property (nonatomic,weak) IBOutlet UILabel *content2LB;
@property (nonatomic,weak) IBOutlet UILabel *content3LB;
@property (nonatomic,weak) IBOutlet UILabel *content4LB;
@property (nonatomic,weak) IBOutlet UILabel *content5LB;

@end

@implementation sleep2TitleView

+ (instancetype)walkViewWithContent0:(NSString *)content0 content1:(NSString *)content1 content2:(NSString *)content2 content3:(NSString *)content3 content4:(NSString *)content4 content5:(NSString *)content5
{
    sleep2TitleView *result = [[[NSBundle mainBundle] loadNibNamed:@"sleep2TitleView" owner:self options:nil] firstObject];
    result.content0LB.text = content0;
    result.content1LB.text = content1;
    result.content2LB.text = content2;
    result.content3LB.text = content3;
    result.content4LB.text = content4;
    result.content5LB.text = content5;
    return result;
}
@end
