//
//  MSRequest.m
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"
#import <SSKeyChain/SSKeychain.h>
#import "NSDate+FastKit.h"
#import "MuseUser.h"

#import "MSRequestRefreshToken.h"

@implementation MSRequest

static NSString *_access_token = nil;

+ (NSString *)accessToken {
    if (!_access_token) {
        NSString *phone = [MuseUser currentUser].phone;
        if (phone) {
            _access_token = [SSKeychain passwordForService:@"jq.muse" account:phone];
            [self refreshTokenCompleteBlock:nil failedBlock:nil];
        }
    }
  // MSLog(@"%@",_access_token);
    return _access_token;
}

+ (void)setAccessToken:(NSString *)token {
    _access_token = token;
    
    NSString *phone = [MuseUser currentUser].phone;
    if (phone) {
        [SSKeychain setPassword:_access_token forService:@"jq.muse" account:phone];
    }
}

+ (void)refreshTokenCompleteBlock:(void (^)())completeBlock failedBlock:(void (^)())failedBlock {
    
    NSString *phone = [MuseUser currentUser].phone;
    if (!phone) {
        return;
    }
    
    MSRequestRefreshToken *req = [[MSRequestRefreshToken alloc] initWithPhone:phone];
    
    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if (MSRequestIsSuccess(responseData)) {
            NSDictionary *data = MSResponseData(responseData);
            _access_token = data[@"access_token"];
            [SSKeychain setPassword:_access_token forService:@"jq.muse" account:phone];
            completeBlock();
        } else {
            failedBlock();
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        failedBlock();
    }];
}

+ (BOOL)isRequestSuccessFromRequestResponse:(NSDictionary *)dic {
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        NSInteger flag = [[dic objectNotNullForKey:@"status"] integerValue];
        if (flag == 1) {
            return YES;
        }
    }
    return NO;
}

+ (id)dataFromRequestResponse:(NSDictionary *)dic {
    
    return [dic objectNotNullForKey:@"data"];
}

+ (NSString *)messageFromRequestResponse:(NSDictionary *)response {
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        
      //  MSLog(@"%@",[response objectNotNullForKey:@"message"]);
        
        return [response objectNotNullForKey:@"message"];
    }
    return nil;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (NSTimeInterval)requestTimeoutInterval { 
    return 10;
}

- (NSMutableDictionary *)addTokenToRequestArgument:(NSMutableDictionary *)args {
    
    NSString *token = [MSRequest accessToken];
    if (token) {
        args[@"access_token"] = token;
    }
//    MSLog(@"%@",args);
    return args;
}

@end
