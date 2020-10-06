//
//  HeartTestManager.m
//  Muse
//
//  Created by HaiQuan on 2016/11/19.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "HeartTestManager.h"
#import "AppDelegate.h"
#import "HeartRateDataManager.h"
#import "LocationServer.h"
#import "BlueToothHelper.h"
#import "MSHeartAlertRequest.h"

static HeartTestManager *manager;

@implementation HeartTestManager

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HeartTestManager alloc] init];
    });
    
    return manager;
}

- (void)initManager {
    _dataManager = [[HeartRateDataManager alloc] init];
    _progressCount = 0;
    [kNotificationCenter addObserver:self selector:@selector(stopBgTest) name:Notification_SyncHeartRate object:nil];
    [kNotificationCenter addObserver:self selector:@selector(startBgTest) name:Notify_CareInBgMode object:nil];
    [kNotificationCenter addObserver:self selector:@selector(startTest) name:LoveOtherNotification object:nil];
}

#pragma mark - 前台测心率/关爱测心率

- (void)startTest {
    if (_isTestHeart == YES) {
        return;
    }
    
    _progressCount = 0;
    
    _isTestHeart = YES;

    if ([self.delegate respondsToSelector:@selector(testStart)]) {
        [self.delegate testStart];
    }
    
    
    BlueToothHelper *bt = [BlueToothHelper sharedInstance];
    
    [bt writeByteValueToConnectedPeripheral:BLEHeartRateCommand
                             withCompletion:^(CBCharacteristic *characteristic, NSError *error) {
                                 if (error.localizedDescription) {
                                     _isTestHeart = NO;
                                     [MBProgressHUD showHUDWithMessageOnly:error.localizedDescription];
                                     return ;
                                 }
                             }];
    
    
    if (_isCare == YES) {
        [[BlueToothHelper sharedInstance] vibrateWithDuration:1 interval:0 times:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.monitorTimer) {
                [self.monitorTimer setFireDate:[NSDate date]];
            } else {
                self.monitorTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateMonitorProgress:) userInfo:nil repeats:YES];
            }
        });
    } else {
        if (self.monitorTimer) {
            [self.monitorTimer setFireDate:[NSDate date]];
        } else {
            self.monitorTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateMonitorProgress:) userInfo:nil repeats:YES];
        }
    }

    
    
}


- (void)updateMonitorProgress:(NSTimer *)sender {
    //MARK: 动画测试数据时间，每0.1秒增加1，时间约为16秒
    _progressCount += 1;
    
    //    LRLog(@"%ld",(long)progressCount__);
    float progress = _progressCount/800.f;
    
    if ([self.delegate respondsToSelector:@selector(testingWithProgress:)]) {
        [self.delegate testingWithProgress:progress];
    }
    
    if (progress > 1) {
        _progressCount = 0;
        [self stopTest];
    }
}

- (void)stopTest {
    _isBgCare = NO;
    self.isTestHeart = NO;
    [_monitorTimer setFireDate:[NSDate distantFuture]];
    _progressCount = 0;
    NSUInteger heartRate = [BlueToothHelper sharedInstance].heartRate;
    
    if ([self.delegate respondsToSelector:@selector(testEnd:)]) {
        [self.delegate testEnd:heartRate];
    }
}



#pragma mark - 后台被关爱测心率
- (void)startBgTest {

    if (_isTestHeart == YES) {
        return;
    }
    
    _isTestHeart = YES;
    
    BlueToothHelper *bt = [BlueToothHelper sharedInstance];
    
    [bt writeByteValueToConnectedPeripheral:BLEHeartRateCommand
                             withCompletion:^(CBCharacteristic *characteristic, NSError *error) {
                                 if (error.localizedDescription) {
                                     _isTestHeart = NO;
                                     return ;
                                 }
                             }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isTestHeart = NO;
    });
    
}

- (void)stopBgTest {
    self.isTestHeart = NO;
    NSUInteger heartRate = [BlueToothHelper sharedInstance].heartRate;

    
    if (heartRate == 0 || heartRate > 185) {
        if ([AppDelegate appDelegate].isBackgroundMode) {
            return;
        }
        [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"Please hand flat", nil)];
    } else {
        [kUserDefaults setObject:[NSString stringWithFormat:@"%lu",(unsigned long)heartRate] forKey:@"LASTHEARTTATE"];
        [_dataManager addANewHeartRate:heartRate isAuto:YES];
        _isBgCare = YES;
    }
    
    
    
    NSString *heartStr = [NSString stringWithFormat:@"%lu",(unsigned long)heartRate];

    if (heartRate >= [[HeartRateDataManager alertHeartRate] integerValue]
        && [[BlueToothHelper sharedInstance] isMuseSettingEnable:BLESettingsOverHeartRate]) {
        
        //TODO: 自己心率超标，给亲友发送mqtt消息
        //           "该亲友心率超标：" + rate_now + "，"+APP.getInstance().mMyAddress
        NSMutableArray *friendList = [[DBManager sharedManager] getUserFriendListfromDB];
        NSMutableString *phones = [[NSMutableString alloc] init];
        for (NSDictionary *list in friendList) {
            phones = [[phones stringByAppendingString:[NSString stringWithFormat:@"%@,", list[@"phone"]]] mutableCopy];
        }
        
        
        if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
            [[LocationServer sharedServer] locateWithCompletion:^(BMKReverseGeoCodeResult *locationResult) {
                if (CLLocationCoordinate2DIsValid(locationResult.location)
                    && locationResult.address.length) {
                    NSString *messageadd = [NSString stringWithFormat:@"%@:%f,%@:%f%@:%@", NSLocalizedString(@"long", nil), locationResult.location.longitude, NSLocalizedString(@"la", nil), locationResult.location.latitude, NSLocalizedString(@"address", nil), locationResult.address];
                    NSString *HQStr = [self appendingStringWith:heartStr and:messageadd];
                    [self sendHeartAlertMessage:HQStr];

                }
            }];
        } else {
            [[LocationServer sharedServer] locate_CL_WithCompletion:^(CLPlacemark *locationResult) {
                if (locationResult.addressDictionary[@"FormattedAddressLines"]) {
                    NSString *messageadd = [NSString stringWithFormat:@"%@:%.2f,%@:%.2f,%@:%@", NSLocalizedString(@"long", nil), locationResult.location.coordinate.longitude, NSLocalizedString(@"la", nil),locationResult.location.coordinate.latitude, NSLocalizedString(@"address", nil), [locationResult.addressDictionary[@"FormattedAddressLines"] firstObject]];
                    
                    NSString *HQStr = [self appendingStringWith:heartStr and:messageadd];
                    [self sendHeartAlertMessage:HQStr];

                }
            }];
        }
        
    }else{
        //  [[BlueToothHelper sharedInstance] lightingWithColor:LightColorBlue duration:1];
    }


}

- (NSString *)appendingStringWith:(NSString *)message and:(NSString *)address {
    
    
    NSString *user = [MuseUser currentUser].nickname;
    
    if (!user) {
        user = [MuseUser currentUser].phone;
    }
    
    NSString *temp = [NSString stringWithFormat:@"%@%@%@:%@", NSLocalizedString(@"friend", nil), user, NSLocalizedString(@"heartrateoverproof", nil), message] ;
    
    NSString *HQStr = [temp stringByAppendingString:[NSString stringWithFormat:@"%@",address]];
    
    return HQStr;
    
}


#pragma mark --<超标发送心率>
- (void)sendHeartAlertMessage:(NSString *)message
{
    
    MSHeartAlertRequest *req = [[MSHeartAlertRequest alloc] initWithMessage:message];
    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        MSLog(@"succeed send heartAlert");
    } failure:^(__kindof YTKBaseRequest *request) {
        MSLog(@"failed send heartAlert");
    }];
    
    
}


@end
