//
//  AskforFriendAttentionRequest.m
//  Muse
//
//  Created by paycloud110 on 16/7/15.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "AskforFriendAttentionRequest.h"

@implementation AskforFriendAttentionRequest

- (NSString *)requestUrl {
    
    return @"/friend/create";
}

- (id)requestArgument {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]
                                       initWithDictionary:@{@"phones":_phones}];
    if (_remarks) {
//        parameters[@"remark"] = _remarks;
        [parameters setValue:_remarks forKey:@"remark"];
    }
    return [self addTokenToRequestArgument:parameters];
}

+ (void)startRequestWithPhones:(NSString *)phones
                       remarks:(NSString *)remarks
        completionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock
                       failure:(CompletionFailBlock)completionFailBlock {
    if (!phones) {
        if (completionFailBlock) {
            completionFailBlock(nil);
        }
        return;
    }
    
    AskforFriendAttentionRequest *req = [[self alloc] init];
    req.phones = phones;
    req.remarks = remarks;
    
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
