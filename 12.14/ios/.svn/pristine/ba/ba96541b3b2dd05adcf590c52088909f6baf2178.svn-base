//
//  DeleteListFriendRequest.m
//  Muse
//
//  Created by paycloud110 on 16/7/26.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "DeleteListFriendRequest.h"

@implementation DeleteListFriendRequest

NSString *_deleteID = nil;

- (NSString *)requestUrl {
    return @"/friend/delete";
}

- (id)requestArgument {
    NSNumber *numID = [[NSNumber alloc] initWithInteger:[_deleteID integerValue]];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]
                                       initWithDictionary:@{@"friend_id":numID,
                                                            }];
    return [self addTokenToRequestArgument:parameters];
}

/** 删除亲友 */
+ (void)startWithDeleteID:(NSString *)deleteID completionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock failure:(CompletionFailBlock)completionFailBlock {
    if (!deleteID) {
        if (completionFailBlock) {
            completionFailBlock(nil);
        }
    }
    
    _deleteID = deleteID;
    [[self alloc] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
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
