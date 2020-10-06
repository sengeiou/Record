//
//  SendSecrectToFriendRequest.m
//  Muse
//
//  Created by paycloud110 on 16/7/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SendSecrectToFriendRequest.h"

@implementation SendSecrectToFriendRequest

- (NSString *)requestUrl {
    
    return @"/sweetWord/create";
}

- (id)requestArgument {
    if (!_phones || !_message) {
        return nil;
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]
                                       initWithDictionary:@{@"message":_message,
                                                            @"phones":_phones
                                                            }];
    return [self addTokenToRequestArgument:parameters];
}

/** 发送密语到亲友 */
+ (void)startWithUserID:(NSString *)phones sendMessage:(NSString *)message completionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock failure:(CompletionFailBlock)completionFailBlock {
    
    if (!phones) {
        if (completionFailBlock) {
            completionFailBlock(nil);
        }
    }
    
    SendSecrectToFriendRequest *req = [[SendSecrectToFriendRequest alloc] init];
    req.phones = phones;
    req.message = message;
    
    MSLog(@"%@\n%@", phones, message);
    
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
