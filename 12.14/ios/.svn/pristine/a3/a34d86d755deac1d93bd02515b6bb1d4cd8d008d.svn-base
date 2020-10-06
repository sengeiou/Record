//
//  SendMorseRequest.m
//  Muse
//
//  Created by HaiQuan on 2016/11/28.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SendMorseRequest.h"

@implementation SendMorseRequest

- (NSString *)requestUrl {
    return @"/tool/mose";
}


- (id)requestArgument {
    if (!_phones || !_message || !_type) {
        return nil;
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]
                                       initWithDictionary:@{@"msg":_message,
                                                            @"phone_nums":_phones,
                                                            @"type":_type
                                                            }];
    return [self addTokenToRequestArgument:parameters];
}

+ (void)startWithUserID:(NSString *)phones sendMessage:(NSString *)message type:(NSString *)type completionBlockSuccess:(CompletionSuccessBlock)completionSuccessBlock failure:(CompletionFailBlock)completionFailBlock {
    if (!phones) {
        if (completionFailBlock) {
            completionFailBlock(nil);
        }
    }
    
    SendMorseRequest *req = [[SendMorseRequest alloc] init];
    req.phones = phones;
    req.message = message;
    req.type = type;
    
    MSLog(@"%@\n%@\n%@", phones, message, type);

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
