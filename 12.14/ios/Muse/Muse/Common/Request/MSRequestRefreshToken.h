//
//  MSRequestRefreshToken.h
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface MSRequestRefreshToken : MSRequest

- (instancetype)initWithPhone:(NSString *)phone;

@property (strong, nonatomic) NSString *phone;


@end
