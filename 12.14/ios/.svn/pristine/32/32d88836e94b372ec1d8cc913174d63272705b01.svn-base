//
//  walkTitleView.m
//  Muse
//
//  Created by apple on 16/5/8.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "walkTitleView.h"

@interface walkTitleView ()

@property (nonatomic,weak) IBOutlet UILabel *content0LB;
@property (nonatomic,weak) IBOutlet UILabel *content1LB;
@property (nonatomic,weak) IBOutlet UILabel *content2LB;

@end

@implementation walkTitleView

+ (instancetype)walkViewWithContent0:(NSString *)content0 content1:(NSString *)content1 content2:(NSString *)content2
{
    walkTitleView *result = [[[NSBundle mainBundle] loadNibNamed:@"walkTitleView" owner:self options:nil] firstObject];
    result.content0LB.text = content0;
    result.content1LB.text = content1;
    result.content2LB.text = content2;
    return result;
}

@end
