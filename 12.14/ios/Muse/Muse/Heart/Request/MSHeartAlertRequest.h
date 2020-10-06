//
//  MSHeartAlertRequest.h
//  Muse
//
//  Created by HaiQuan on 2016/12/9.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface MSHeartAlertRequest : MSRequest

@property (strong, nonatomic) NSString *message;


- (instancetype)initWithMessage:(NSString *)msg;

@end
