//
//  DisposeFriendPartnershipRequest.h
//  Muse
//
//  Created by paycloud110 on 16/7/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface DisposeFriendPartnershipRequest : MSRequest

@property (strong, nonatomic) NSString *fromID;
    
@property (assign, nonatomic) BOOL agree;

/** 处理亲友配对 */
+ (void)startWithFromID:(NSString *)fromID agree:(BOOL)aBool completionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock failure:(CompletionFailBlock)completionFailBlock;

@end
