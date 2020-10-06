//
//  ContentButton.m
//  Muse
//
//  Created by paycloud110 on 16/7/2.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "ContentButton.h"

@implementation ContentButton

- (instancetype)initWithImageName:(NSString *)imageName
{
    if (self = [super init]) {
        self.backgroundColor = ColorWithLightTan;
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    return self;
}
- (void)setHighlighted:(BOOL)highlighted
{

}
@end
