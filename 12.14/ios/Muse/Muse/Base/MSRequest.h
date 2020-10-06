//
//  MSRequest.h
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>
#import "NSDictionary+FastKit.h"

typedef void(^CompletionSuccessBlock)(NSDictionary *responseObject);
typedef void(^CompletionFailBlock)(NSDictionary *responseObject);

#define MSRequestIsSuccess(dic) ([MSRequest isRequestSuccessFromRequestResponse:dic])
#define MSResponseData(dic) ([MSRequest dataFromRequestResponse:dic])
#define MSResponseMessage(dic) ([MSRequest messageFromRequestResponse:dic])


@interface MSRequest : YTKRequest


+ (NSString *)accessToken;
+ (void)setAccessToken:(NSString *)token;
+ (void)refreshTokenCompleteBlock:(void(^)())completeBlock failedBlock:(void(^)())failedBlock;

+ (BOOL)isRequestSuccessFromRequestResponse:(NSDictionary *)dic;
+ (id)dataFromRequestResponse:(NSDictionary *)dic;
+ (NSString *)messageFromRequestResponse:(NSDictionary *)response;

- (NSMutableDictionary *)addTokenToRequestArgument:(NSMutableDictionary *)args;

@end
