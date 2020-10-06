//
//  DisposeFriendPartnershipRequest.m
//  Muse
//
//  Created by paycloud110 on 16/7/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "DisposeFriendPartnershipRequest.h"
#import "ContactManager.h"

@implementation DisposeFriendPartnershipRequest

NSString *fromId = nil;

- (NSString *)requestUrl {
    if (_agree) {
        return @"/friend/agree";
    }else {
        return @"/friend/unAgree";
    }
}

- (id)requestArgument {
    NSString *friendName;
    ContactManager *manager = [ContactManager sharedInstance];
    if (manager.currentAddFriendName) {
        friendName = manager.currentAddFriendName;
    } else {
        friendName = manager.currentAddFriendPhone;
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]
                                       initWithDictionary:@{@"from_id":fromId,@"remark":friendName}];
    return [self addTokenToRequestArgument:parameters];
}

/** 处理亲友配对 */
+ (void)startWithFromID:(NSString *)fromID agree:(BOOL)agree completionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock failure:(CompletionFailBlock)completionFailBlock {
    
    if (!fromID) {
        if (completionFailBlock) {
            completionFailBlock(nil);
        }
    }
    
    fromId = fromID;
    
    DisposeFriendPartnershipRequest *req = [[DisposeFriendPartnershipRequest alloc] init];
    req.fromID = fromID;
    req.agree = agree;
    
    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if (MSRequestIsSuccess(responseData)) {
            if (completionSuccessBlock) {
                completionSuccessBlock(responseData);
            }
        } else if (completionFailBlock) {
            completionFailBlock(responseData);
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        if (completionFailBlock) {
            if (request.responseData) {
                NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
                completionFailBlock(responseData);
            }else {
                completionFailBlock(@{@"message":@"数据为空"});
            }
        }
    }];
}

@end
