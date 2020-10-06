//
//  MSUploadHeartRateRequest.h
//  Muse
//
//  Created by 朱祥巍 on 16/7/9.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface MSUploadHeartRateRequest : MSRequest

@property (strong, nonatomic) NSArray<NSDictionary<NSString *, NSString *> *> *datas;

/**
 *  上传蓝牙数据数组请求
 *
 *  @param datas 蓝牙数据数组，格式[{"bluetooth":"0d:55:de:f3:66:01","rate":120,"time":1459480507}, ...]
 *
 *  @return 上传蓝牙数据数组请求
 */
- (instancetype)initWithDatas:(NSArray<NSDictionary<NSString *, NSString *> *> *)datas;

@end
