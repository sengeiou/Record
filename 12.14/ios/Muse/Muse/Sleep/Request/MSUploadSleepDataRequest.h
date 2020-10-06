//
//  MSUploadSleepDataRequest.h
//  Muse
//
//  Created by Ken.Jiang on 27/7/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "MSRequest.h"

@interface MSUploadSleepDataRequest : MSRequest


@property (strong, nonatomic) NSArray<NSDictionary<NSString *, NSString *> *> *datas;

/**
 *  上传蓝牙数据数组请求
 *
 *  @param datas 蓝牙数据数组，格式[{"bluetooth":"0d:55:de:f3:66:01","is_deep":1,"time":1462032000}, ...]
 *
 *  @return 上传蓝牙数据数组请求
 */
- (instancetype)initWithDatas:(NSArray<NSDictionary<NSString *, NSString *> *> *)datas;

@end
