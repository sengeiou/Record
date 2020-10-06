//
//  sleepTitleView.m
//  Muse
//
//  Created by apple on 16/5/8.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "sleepTitleView.h"

@interface sleepTitleView ()

@property (nonatomic,weak) IBOutlet UILabel *rightTopLB;

@property (nonatomic,weak) IBOutlet UILabel *lightSleepLB;
@property (nonatomic,weak) IBOutlet UILabel *deepSleepLB;
@property (nonatomic,weak) IBOutlet UILabel *weakUpLB;

@property (nonatomic,weak) IBOutlet UILabel *timeLB;

@property (nonatomic,weak) IBOutlet UIView *bgView;

@end

@implementation sleepTitleView

+ (instancetype)sleepViewWithData:(id)data;
{
    sleepTitleView *result = [[[NSBundle mainBundle] loadNibNamed:@"sleepTitleView" owner:self options:nil] firstObject];
    [result setColorViews:data];
    
    return result;
}

- (void)setColorViews:(id)data
{
    NSArray *arr = data;
    
    if(!arr)
    {
        arr = [self testData];
    }
    
    __block UIView *v;
    
    __block CGFloat currentX = 0;
    __weak typeof(self)myself = self;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        v = [[UIView alloc]initWithFrame:CGRectMake(currentX, 0, [obj[@"length"] intValue], 40)];
        v.backgroundColor = obj[@"color"];
        [myself.bgView addSubview:v];
        
        currentX += v.frame.size.width;
    }];
    
    
}

- (NSArray *)testData
{
    return   @[@{@"length":@10,@"color":[UIColor blueColor]},
             @{@"length":@5,@"color":[UIColor blueColor]},
             @{@"length":@20,@"color":[UIColor magentaColor]},
             @{@"length":@30,@"color":[UIColor blueColor]},
             @{@"length":@10,@"color":[UIColor greenColor]},
             @{@"length":@10,@"color":[UIColor blueColor]},
             @{@"length":@50,@"color":[UIColor blueColor]}];
}

@end
