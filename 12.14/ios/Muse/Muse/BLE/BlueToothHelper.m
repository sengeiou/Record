
//  BlueToothHelper.m
//  Muse
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "BlueToothHelper.h"

#import "DeviceSelectionViewController.h"
#import "AppDelegate.h"

#import "MBProgressHUD+Simple.h"
#import "NSDate+FastKit.h"
#import "NSTimer+FastKit.h"

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#import "DBManager+HeartRate.h"
#import "MSUploadHeartRateRequest.h"

#import "DBManager+Sleep.h"
#import "MSUploadSleepDataRequest.h"

#import "ClockManager.h"
#import "SOSHandler.h"
#import "SOSRequest.h"
#import "AddressBookManager.h"
#import "LocationServer.h"

#import "LCSOSHandler.h"

#define ServerUUID              @"84A58D28-713E-45ED-9d5E-27568D5b2A08"
#define CharacteristicUUID      @"33836A55-2075-46D0-B778-CA37D18914B1"

#define MuseSettings            @"MuseSettings"

#define LastSyncHeartRateDate   @"LastSyncHeartRateDate"
#define LastSyncSleepDate       @"LastSyncSleepDate"

Byte const BLEBandingCommand = 0x59; //连接成功后绑定指令
Byte const BLECalibrationTimeCommand = 0x51; //校准时间
Byte const BLESettingsCommand = 0x5C; //各种开关设置
Byte const BLEPowerLevelCommand = 0x5D; //读取电量

/**
 *  每天测三次，得到3个数组，发送7天的数据 0-220（一般不会返回超这范围的数据，app端最好做下判断）
 *  心率，次数/分钟，7天每天3次
 */
Byte const BLEFetchHeartRateDataCommand = 0x52; //同步心率数据:
Byte const BLEHeartRateCommand = 0x53; //获取心率
Byte const BLESOSCommand = 0x54; //一键呼救
Byte const BLEVibrateCommand = 0x55; //震动
Byte const BLESetClocksCommand = 0x56; //设置闹钟时间
Byte const BLEChangeModeCommand = 0x57; //切换模式
Byte const BLESleepCommand = 0x58; //睡眠监测
Byte const BLETakePictureCommand = 0x5A; //拍照or密语
Byte const BLELightingCommand = 0x5B; //亮灯指令


NSString *const PeripheralBeginConnectNotification = @"PeripheralBeginConnectNotification";
NSString *const PeripheralConnectedNotification = @"PeripheralConnectedNotification";
NSString *const PeripheralDisconnectedNotification = @"PeripheralDisconnectedNotification";

NSString *const ReadBLEPowerLevelNotification = @"ReadBLEPowerLevelNotification";
NSString *const ReceivedSOSNotification = @"ReceivedSOSNotification";
NSString *const ReceivedTakePictureNotification = @"ReceivedTakePictureNotification";

NSString *const SendSecretNotification = @"SendSecretNotification";

typedef NS_ENUM(NSUInteger, SyncStep) {
    SyncStepStart,
    SyncStepTime = SyncStepStart,
    SyncStepHeartRate,
    SyncStepSleep,
    SyncStepClocks,
    SyncStepSettings,
    SyncStepEnd
};

@interface BlueToothHelper () {
    NSMutableArray *peripherals;
    NSMutableArray *peripheralsAD;
    NSMutableArray *descriptors;
    
    __weak BabyBluetooth *_baby;
    
    BLESettings _settings;
    
    BOOL _sendingSOSReq;
    SyncStep _syncStep;
    
    NSInteger _tryLocationTimes;
    
}



@property (strong, nonatomic, nullable) NSMutableArray<CBPeripheral *> *scanedPeripherals;

@property (strong, nonatomic, nullable) CBPeripheral *connectedPeripheral;

@property (strong, nonatomic, nullable) CBCharacteristic *availableCharacteristic;

@property (assign, nonatomic) Byte heartRate;
@property (assign, nonatomic) Byte powerLevel;

@property (weak, nonatomic) NSTimer *powerTimer;

@property (nonatomic, strong) CTCallCenter *callCenter;

@end

@implementation BlueToothHelper

static BlueToothHelper *__singletion;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    
//    dispatch_once(&onceToken, ^{
//    });
    if (__singletion == nil) {
        __singletion=[[self alloc] init];
    }
    
    
    return __singletion;
}

+ (void)killBlueToothHelper {
    __singletion = nil;
}

+ (NSDate *)lastSyncHeartRateDate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:LastSyncHeartRateDate];
}

+ (void)saveLastSyncHeartRateDate:(NSDate *)date {
    if (!date) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:LastSyncHeartRateDate];
}
#pragma mark - Setup

- (instancetype)init {
    if (self = [super init]) {
        _baby = [BabyBluetooth shareBabyBluetooth];
//        [self _setupBabyDelegate];
        
        _scanedPeripherals = [NSMutableArray array];
        //当用户来电1戒指将发出1秒的震动提醒初始化
        _callCenter = [[CTCallCenter alloc] init];
        [self monitorPhoneCall];
        
        NSNumber *settings = [[NSUserDefaults standardUserDefaults] objectForKey:MuseSettings];
        if (settings) {
            _settings = [settings unsignedIntegerValue];
        } else {
            _settings = 0b11111111;
        }
        
        _powerLevel = 100;
        
        _secretMode = YES;
        
        _needPop = false;
        
    }
    
    return self;
}

- (void)cancelAllConnected {
    [_baby cancelAllPeripheralsConnection];
}

- (void)_setupBabyDelegate {
    
    __weak typeof(self)weakSelf = self;
    
    [_baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        
        NSLog(@"系统蓝牙状态被改变!");
        
        if (central.state == CBCentralManagerStatePoweredOn && _needPop == false && self.connectedPeripheral.state == CBPeripheralStateDisconnected) {
            [weakSelf tryToConnectLastConnectedDevice2];
            return;
        }
        
        NSString *prompt;
        
        switch (central.state) {
            case CBCentralManagerStateUnsupported:
                prompt = NSLocalizedString(@"ble_not_supported", nil);
                break;
            case CBCentralManagerStateUnauthorized:
                prompt = NSLocalizedString(@"ble_nopermission", nil);
                break;
            case CBCentralManagerStatePoweredOff:
                prompt = NSLocalizedString(@"ble_poweroff", nil);
                break;
               
            default:
                break;
        }
        
        if (prompt) {
            [MBProgressHUD showHUDWithMessageOnly:prompt];
            [_baby stop];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PeripheralDisconnectedNotification object:nil];
        }
    }];
    
    //设置babyOptions
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@NO};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    [_baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions
                              connectPeripheralWithOptions:connectOptions
                            scanForPeripheralsWithServices:nil
                                      discoverWithServices:nil
                               discoverWithCharacteristics:nil];
    
    //    [_baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
    //        NSLog(@"setBlockOnCancelScanBlock");
    //    }];
    
    //设置查找设备的过滤器
    [_baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        return [peripheralName isEqualToString:@"MuseHeart"];
    }];
    
    //设置扫描到设备的委托
    [_baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        BOOL added = NO;
        for (CBPeripheral *addedP in strongSelf.scanedPeripherals) {
            if ([addedP.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
                added = YES;
                break;
            }
        }
        if (!added) {
            [strongSelf.scanedPeripherals addObject:peripheral];
        }
    }];
    
    //设置设备断开连接的委托
    [_baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        
        if (_isSaveAutoConnect) {
            [_baby AutoReconnect:peripheral];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PeripheralBeginConnectNotification object:nil];
    }];
}

#pragma mark - Scan

- (void)startScanWithCompletion:(void (^)(NSArray<CBPeripheral *> *scanedPeripherals))completion {
    
//    [_baby cancelAllPeripheralsConnection];
//    [_baby cancelScan];
    [_scanedPeripherals removeAllObjects];
    
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    _baby.scanForPeripherals().begin();
    [[NSNotificationCenter defaultCenter] postNotificationName:PeripheralBeginConnectNotification
                                                        object:nil];
    
    NSLog(@"开始扫描 6 秒周边的外设");
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf cancelScan];
        if (completion) {
            completion(strongSelf.scanedPeripherals);
        }
    });
}

- (void)cancelScan {
    [_baby cancelScan];
}

#warning 连接上一次的设备
- (void)scanAndConnectLastDevice2 {
    
    _tryConnectTimes++;
    __weak typeof(self) weakSelf = self;
    
    if (_baby.centralManager.state != CBCentralManagerStatePoweredOn) {
        
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.connectedPeripheral.state != CBPeripheralStateConnected) {
                [weakSelf scanAndConnectLastDevice2];
            }
        });
        
        return;
    }
    
    NSString *lastConnectedDeviceUUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastConnectedDevice"];
    [self startScanWithCompletion:^(NSArray<CBPeripheral *> * _Nonnull scanedPeripherals) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        CBPeripheral *peripheralToConnect;
        
        if (lastConnectedDeviceUUID && strongSelf->_tryConnectTimes < 600) {
            
            for (CBPeripheral *peripheral in scanedPeripherals) {
            
                if ([peripheral.identifier.UUIDString isEqualToString:lastConnectedDeviceUUID]) {
                    peripheralToConnect = peripheral;
                    break;
                }
            }
        }
        
        if (peripheralToConnect) {
            [weakSelf connectPeripheral:peripheralToConnect
                            deviceQurey:NO
                             completion:nil];
        } else {
            [weakSelf scanAndConnectLastDevice2];
        }
    }];
}

- (void)scanAndConnectLastDevice {
    _tryConnectTimes++;
    __weak typeof(self) weakSelf = self;
    
    if (_baby.centralManager.state != CBCentralManagerStatePoweredOn) {
        
        //[MBProgressHUD showHUDWithMessageOnly:@"智能珠宝连接中，请稍候"];
        
      
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.connectedPeripheral.state != CBPeripheralStateConnected) {
                [weakSelf scanAndConnectLastDevice];
            }
        });
    
        return;
    }
    
    NSString *lastConnectedDeviceUUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastConnectedDevice"];
    
    [self startScanWithCompletion:^(NSArray<CBPeripheral *> * _Nonnull scanedPeripherals) {
    
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        CBPeripheral *peripheralToConnect;
      
        if (lastConnectedDeviceUUID && strongSelf->_tryConnectTimes < 6) {
            for (CBPeripheral *peripheral in scanedPeripherals) {
                if ([peripheral.identifier.UUIDString isEqualToString:lastConnectedDeviceUUID]) {
                    peripheralToConnect = peripheral;
                    break;
                }
            }
        } else {
            if (scanedPeripherals.count) {
                if (scanedPeripherals.count == 1) {
                    peripheralToConnect = [scanedPeripherals lastObject];
                } else {
                    DeviceSelectionViewController *vc = [[DeviceSelectionViewController alloc] init];
                    vc.peripherals = scanedPeripherals;
                    [vc setCompletionBlock:^(CBPeripheral *selectedPeripheral) {
                        [weakSelf connectPeripheral:peripheralToConnect
                                        deviceQurey:NO
                                         completion:nil];
                    }];
                    
                    [[AppDelegate appDelegate].window.rootViewController presentViewController:vc animated:YES completion:nil];
                    return;
                }
            }
        }
        
        if (peripheralToConnect) {
            [weakSelf connectPeripheral:peripheralToConnect
                            deviceQurey:NO
                             completion:nil];
        } else {
            [weakSelf scanAndConnectLastDevice];
        }
    }];
}

#pragma mark - Connect
- (void)tryToConnectLastConnectedDevice2 {
    _tryConnectTimes = 0;
    [self scanAndConnectLastDevice2];
}

- (void)tryToConnectLastConnectedDevice {
    _tryConnectTimes = 0;
    [self scanAndConnectLastDevice];
}

- (void)connectPeripheral:(CBPeripheral *)peripheralToConnect
              deviceQurey:(BOOL)isDeviceQurey
               completion:(void (^)(BOOL successed))completion {
    
    

    
    __weak typeof(self) weakSelf = self;
    
    [_baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.connectedPeripheral = peripheral;
        
        if ([self.connectedPeripheral.identifier.UUIDString
             isEqualToString:peripheralToConnect.identifier.UUIDString]) {
            if (completion) {
                completion(YES);
                
                _isSaveAutoConnect = YES;
                
                [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"device_connected_success", nil)];
                
                [[NSUserDefaults standardUserDefaults] setObject:peripheral.identifier.UUIDString
                                                          forKey:@"LastConnectedDevice"];
                [strongSelf readPower];
                
                if (!strongSelf.powerTimer) {
                    strongSelf.powerTimer = [NSTimer fk_scheduledTimerWithTimeInterval:60
                                                                                target:self
                                                                              selector:@selector(readPower)
                                                                              userInfo:nil
                                                                               repeats:YES];
                }
         
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PeripheralConnectedNotification object:nil];
                
            }
            return;
        } else {
            [_baby cancelPeripheralConnection:_connectedPeripheral];
            [self.powerTimer invalidate];
            self.powerTimer = nil;
            completion(NO);
        }

    }];
    

    
    [_baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.connectedPeripheral = nil;
        strongSelf.availableCharacteristic = nil;
        
        if (completion) {
            completion(NO);
        } else {
            [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"device_connected_failed", nil)];
        }
    }];
    
    [_baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID.UUIDString isEqualToString:CharacteristicUUID]) {
                strongSelf.availableCharacteristic = characteristic;
                
                [strongSelf writeByteValueToConnectedPeripheral:BLEBandingCommand
                                                 withCompletion:nil];

                
                if (isDeviceQurey) {
                    return;
                }
                
                strongSelf->_syncStep = SyncStepStart;
                
//                //监听数据
                [strongSelf notifiyConnectedPeripheral:YES withCallback:nil];
                _isSaveAutoConnect = YES;

                [[NSNotificationCenter defaultCenter] postNotificationName:PeripheralConnectedNotification object:nil];

                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf sendSyncCommands];
                });
                
                break;
            }
        }
    }];
    
    [_baby cancelScan];
    
    _baby.having(peripheralToConnect).connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().begin();
}

#pragma mark - Write And Notifiy

- (void)writeByteValueToConnectedPeripheral:(Byte)value
                             withCompletion:(_Nullable BBDidWriteValueForCharacteristicBlock)completion {
    if (!_availableCharacteristic) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"com.muse.ken" code:404 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"write Data Failed", nil)}];
            completion(nil, error);
        }
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PeripheralConnectedNotification object:nil];

    
    MSLog(@"进行写数据");

    
    [_baby setBlockOnDidWriteValueForCharacteristic:completion];
    
    NSData *data = [NSData dataWithBytes:&value length:sizeof(value)];
    [_connectedPeripheral writeValue:data forCharacteristic:_availableCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)writeDataToConnectedPeripheral:(NSData *)data
                        withCompletion:(_Nullable BBDidWriteValueForCharacteristicBlock)completion {
    
    if (!_availableCharacteristic) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"com.muse.ken" code:404 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"write Data Failed", nil)}];
            completion(nil, error);
        }
        return;
    }
    

    MSLog(@"进行写数据");
    
    [_baby setBlockOnDidWriteValueForCharacteristic:completion];
    
  //  LRLog(@"%@ %@",completion,data);
    
    [_connectedPeripheral writeValue:data forCharacteristic:_availableCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)notifiyConnectedPeripheral:(BOOL)notify withCallback:(void (^)(BLEValueType type, Byte value, NSError *error))callback {
    if (notify) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PeripheralConnectedNotification object:nil];

        
        __weak typeof(self) weakSelf = self;
        
        
        //MARK: 同步返回数据
        [_baby notify:_connectedPeripheral characteristic:_availableCharacteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSData *data = characteristics.value;
            NSUInteger length = data.length;
            Byte *resultByte = (Byte *)[data bytes];
            
            Byte indicator = resultByte[0];
            
            LRLog(@"%hhu",indicator);
            
            switch (indicator) {
                case BLEFetchHeartRateDataCommand://同步心率
                {
                 //   [self syncHeartRates:resultByte length:length];
                    
                    strongSelf->_syncStep = SyncStepSleep;
                    [strongSelf sendSyncCommands];
                }
                    break;
                case BLEHeartRateCommand:
                {
                    if (length < 2) {
                        return;
                    }
                    strongSelf.heartRate = [strongSelf validHeartRate:resultByte[1]];
                    if (callback) {
                        callback(BLEValueTypeHeartRate, strongSelf.heartRate, error);
                    }
                    if ([AppDelegate appDelegate].isBackgroundMode) {
                        [kNotificationCenter postNotificationName:Notification_SyncHeartRate object:nil];

                    }
                }
                    break;
                case BLESOSCommand:
                {
                    if (_isRingBusy == YES) {
                        return;
                    } else {
                        _isRingBusy = YES;
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        _isRingBusy = NO;
                    });
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedSOSNotification object:nil];
                    
                    _sendingSOSReq = NO;
                    [strongSelf prepareSendSOSRequest];
                    
                }
                    break;
                case BLESleepCommand: //同步睡眠
                {
                 //   [self syncSleepStates:resultByte length:length];
                    
                    strongSelf->_syncStep = SyncStepClocks;
                    [strongSelf sendSyncCommands];
                }
                    break;
                case BLETakePictureCommand:
                {
                    if (_isRingBusy == YES) {
                        return;
                    } else {
                        _isRingBusy = YES;
                        if (_secretMode) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:SendSecretNotification
                                                                                object:nil];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                _isRingBusy = NO;
                            });
                        } else {
                            [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedTakePictureNotification object:nil];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                _isRingBusy = NO;
                            });
                        }
                    }
                    
                }
                    break;
                case BLEPowerLevelCommand:
                {
                    if (length < 2) {
                        return;
                    }
                    strongSelf.powerLevel = resultByte[1];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ReadBLEPowerLevelNotification object:@(resultByte[1])];
                    if (strongSelf.powerLevel <= 20) {
                        [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"lowPower20", nil)];
                        return;
                    }
                    if (strongSelf.powerLevel <= 10) {
                        [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"lowPower10", nil)];
                        return;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }];
    } else {
        [_baby cancelNotify:_connectedPeripheral characteristic:_availableCharacteristic];
    }
}

/*
 + (NSString *)stringFromHexString:(NSString *)hexString {
 
 char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
 bzero(myBuffer, [hexString length] / 2 + 1);
 for (int i = 0; i < [hexString length] - 1; i += 2) {
 unsigned int anInt;
 NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
 NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
 [scanner scanHexInt:&anInt];
 myBuffer[i / 2] = (char)anInt;
 }
 NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
 NSLog(@"------字符串=======%@",unicodeString);
 return unicodeString;
 }
 */

#pragma mark - Private

- (Byte)validHeartRate:(Byte)heartRate {
    if (heartRate < 50) {
        return 50;
    }
    
    if (heartRate > 240) {
        return 240;
    }
    
    return heartRate;
}

- (void)prepareSendSOSRequest {
    if (_sendingSOSReq) {
        return;
    }
    
    _sendingSOSReq = YES;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self replySOSSuccses];
    });
    
//    [self writeByteValueToConnectedPeripheral:BLESOSCommand withCompletion:nil];
    _tryLocationTimes = 8;
    
    [self SOSLocate];
}

- (void)SOSLocate {
    _tryLocationTimes--;
    
    if (_tryLocationTimes < 0) {
        [self sendSOSRequestWithMessage:nil];
    } else {
        if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
            [[LocationServer sharedServer] locateWithCompletion:^(BMKReverseGeoCodeResult *locationResult) {
                if (CLLocationCoordinate2DIsValid(locationResult.location)
                    && locationResult.address.length) {
                    NSString *message = [NSString stringWithFormat:@"%@:%.2f,%@:%.2f,%@:%@", NSLocalizedString(@"long", nil), locationResult.location.longitude, NSLocalizedString(@"la", nil),locationResult.location.latitude, NSLocalizedString(@"address", nil), locationResult.address];
                    //                [self sendSOSRequestWithMessage:message];
                    [self judgeWhetherFriendXMl:nil withAddressBook:[[LCSOSHandler loadEmergencyContacts] mutableCopy] address:message];
                } else {
                    [self SOSLocate];
                }
            }];
        } else {
            [[LocationServer sharedServer] locate_CL_WithCompletion:^(CLPlacemark *locationResult) {
                if (locationResult.addressDictionary[@"FormattedAddressLines"]) {
                    NSString *message = [NSString stringWithFormat:@"%@:%.2f,%@:%.2f,%@:%@", NSLocalizedString(@"long", nil), locationResult.location.coordinate.longitude, NSLocalizedString(@"la", nil),locationResult.location.coordinate.latitude, NSLocalizedString(@"address", nil), [locationResult.addressDictionary[@"FormattedAddressLines"] firstObject]];
                    
                    [self judgeWhetherFriendXMl:nil withAddressBook:[[LCSOSHandler loadEmergencyContacts] mutableCopy] address:message];
                } else {
                    [self SOSLocate];
                }

            }];
        }

    }
}

- (void)sendSOSRequestWithMessage:(NSString *)message {
    NSArray *contacts = [SOSHandler loadEmergencyContacts];
    if (contacts.count == 0) {
        return;
    }
    
    NSMutableString *phones = [NSMutableString string];
    for (AddressPerson *person in contacts) {
        if (person.phone.length) {
            [phones appendFormat:@"%@,", person.phone];
        }
    }
    
    if (phones.length == 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    //调用求救接口
    SOSRequest *req = [[SOSRequest alloc] initWithPhones:phones];
    req.area = message;
    req.message = [[NSUserDefaults standardUserDefaults] objectForKey:FriendSOSHelpSendMessageKey];
    
    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if (MSRequestIsSuccess(responseData)) {
            //接口调用成功后调用 replySOSSuccses
//            [strongSelf replySOSSuccses];
            [[BlueToothHelper sharedInstance] vibrateWithDuration:2 interval:1 times:1];
            
//            [AppDelegate registerLocalNotification:0 alertContent:NSLocalizedString(@"sos didsend", nil)];
        }
        
        strongSelf->_sendingSOSReq = NO;
    } failure:^(__kindof YTKBaseRequest *request) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_sendingSOSReq = NO;
    }];
    
#warning 此处同蜜语，不同点是用sos消息格式
}

- (void)syncHeartRates:(Byte const *)resultByte length:(NSUInteger)length {
    NSDate *now = [NSDate date];
    
    //每天测三次，得到3个数组，发送7天的数据 0-220
    //文档未给出说明，假设测试时间为 08:00， 12:00， 20:00
    NSDate *date = [BlueToothHelper lastSyncHeartRateDate];
    NSInteger daysBetween = 0;
    if (date) { //有值就检查是否可以同步
        daysBetween = [NSDate daysBetweenDate:date andDate:now];
    } else { //无值直接同步
        daysBetween = 7; //戒指最多存储7天的值
    }
    
    // NSInteger startTimeDay = resultByte[1]; //戒指记录开始的日期 1～31
    
    if (daysBetween >= 1) { //大于一天的更新前几天数据（并保存最后更新时间），小于一天不更新
        [BlueToothHelper saveLastSyncHeartRateDate:now];
        
        NSMutableArray<HeartRateData *> *heartRateDatas = [NSMutableArray array];
        NSMutableArray<NSDictionary *> *uploadDatas = [NSMutableArray array];
        NSString *bluetooth = self.connectedPeripheral.identifier.UUIDString;
        if (!bluetooth) {
            bluetooth = @"iOS";
        }
        
        NSInteger j = length;
        for (int i = 0; i < daysBetween; i++) {
            NSDate *dataDate = [[now dateByAddingDays:(i + 1) * -1] beginningOfDay];
            NSTimeInterval timeSecs = [dataDate timeIntervalSince1970];
            
            //时间算前一天开始; 3 + 2，3为一天的数据组，+1为一个标识位，一个日期位占位
            if (j > (3 + 1)) {
                HeartRateData *heartRateData = [[HeartRateData alloc] init];
                heartRateData.time = timeSecs + 8 * 3600;
                heartRateData.heartRate = [NSString stringWithFormat:@"%d", [self validHeartRate:resultByte[j-2]]];
                heartRateData.isAuto = @"NO";
                [heartRateDatas addObject:heartRateData];
                [uploadDatas addObject:@{@"bluetooth":bluetooth,
                                         @"rate":@(resultByte[j-2]),
                                         @"time":@(timeSecs + 8 * 3600)}];
                
                heartRateData = [[HeartRateData alloc] init];
                heartRateData.time = timeSecs + 12 * 3600;
                heartRateData.heartRate = [NSString stringWithFormat:@"%d", [self validHeartRate:resultByte[j-1]]];
                heartRateData.isAuto = @"NO";
                [heartRateDatas addObject:heartRateData];
                [uploadDatas addObject:@{@"bluetooth":bluetooth,
                                         @"rate":@(resultByte[j-1]),
                                         @"time":@(timeSecs + 12 * 3600)}];
                
                heartRateData = [[HeartRateData alloc] init];
                heartRateData.time = timeSecs + 20 * 3600;
                heartRateData.heartRate = [NSString stringWithFormat:@"%d", [self validHeartRate:resultByte[j]]];
                heartRateData.isAuto = @"NO";
                [heartRateDatas addObject:heartRateData];
                [uploadDatas addObject:@{@"bluetooth":bluetooth,
                                         @"rate":@(resultByte[j]),
                                         @"time":@(timeSecs + 20 * 3600)}];
            } else {
                break;
            }
            
            j-=3;
        }
        
        
        
        if (heartRateDatas.count) {
            MSUploadHeartRateRequest *req = [[MSUploadHeartRateRequest alloc] initWithDatas:uploadDatas];
            [req startWithCompletionBlockWithSuccess:nil failure:nil];
            
//            [[DBManager sharedManager] addHeartRateRecords:heartRateDatas];
        }
    }
}

//- (void)syncSleepStates:(Byte const *)resultByte length:(NSUInteger)length {
//    NSDate *now = [NSDate date];
//    
//    //每8位表示连续的四个数组（即40分钟的测量数据）所以一天的数据即24X60/10/4 = 36
//    //Bit流，每两位表示每十分钟测量的睡眠数据，其中01表示浅睡，10表示深睡，11表示清醒，00表示数据无效
//    NSDate *date = [BlueToothHelper lastSyncHeartRateDate];
//    NSInteger daysBetween = 0;
//    if (date) { //有值就检查是否可以同步
//        daysBetween = [NSDate daysBetweenDate:date andDate:now];
//    } else { //无值直接同步
//        daysBetween = 7; //戒指最多存储7天的值
//    }
//    
//    // NSInteger startTimeDay = resultByte[1]; //戒指记录开始的日期 1～31
//    
//    if (daysBetween >= 1) { //大于一天的更新前几天数据（并保存最后更新时间），小于一天不更新
//        [BlueToothHelper saveLastSyncSleepDate:now];
//        
//        NSMutableArray<SleepData *> *sleepDatas = [NSMutableArray array];
//        NSMutableArray<NSDictionary *> *uploadDatas = [NSMutableArray array];
//        NSString *bluetooth = self.connectedPeripheral.identifier.UUIDString;
//        if (!bluetooth) {
//            bluetooth = @"iOS";
//        }
//        
//        NSInteger j = length;
//        NSInteger secsPerTenMin = 10 * 60;
//        for (int i = 0; i < daysBetween; i++) {
//            NSDate *dataDate = [[now dateByAddingDays:i * -1] beginningOfDay];
//            NSTimeInterval timeSecs = [dataDate timeIntervalSince1970] + 12 * 3600; //时间从中午开始倒序
//            
//            //时间范围从 前一天中午12点，到当天中午12点； 36 + 1，36为一天的数据组，+1 为一个标识位，一个日期位占位
//            if (j > (36 + 1)) {
//                for (int k = 0; k < 36; k++, j--) {
//                    Byte byteData = resultByte[j-2];
//                    
//                    Byte getValue = 0b00000011;
//                    for (int l = 0; l < 4; l++, timeSecs -= secsPerTenMin) {//一个byte含有4个数据
//                        getValue = getValue << l;
//                        
//                        SleepState value = byteData & getValue;
//                        
//                        SleepData *sleepData = [[SleepData alloc] init];
//                        sleepData.date = @(timeSecs);
//                        sleepData.sleepState = value;
//                        [sleepDatas addObject:sleepData];
//                        [uploadDatas addObject:@{@"bluetooth":bluetooth,
//                                                 @"is_deep":@(value),
//                                                 @"time":sleepData.date}];
//                    }
//                }
//            } else {
//                break;
//            }
//        }
//        
//        if (sleepDatas.count) {
//            MSUploadSleepDataRequest *req = [[MSUploadSleepDataRequest alloc] initWithDatas:uploadDatas];
//            [req startWithCompletionBlockWithSuccess:nil failure:nil];
//            
//            [[DBManager sharedManager] addSleepRecords:sleepDatas];
//        }
//    }
//}

//MARK: 发送同步数据命令
- (void)sendSyncCommands {
    //各个同步操作延迟，避免一下指令太多蓝牙断开链接
    switch (_syncStep) {
        case SyncStepTime://同步时间
        {
            [self calibrationTime];
            _syncStep = SyncStepSettings;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self sendSyncCommands];
               
            });
        }
            break;
        case SyncStepHeartRate:
        {
//            NSDate *now = [NSDate date];
//            
//            //同步心率数据
//            NSDate *date = [BlueToothHelper lastSyncHeartRateDate];
//            NSInteger daysBetween = 0;
//            if (date) { //有值就检查是否可以同步
//                daysBetween = [NSDate daysBetweenDate:date andDate:now];
//            } else { //无值直接同步
//                daysBetween = 7;
//            }
//            if (daysBetween >= 1) { //距离上次同步大于1天时间才发送同步命令
//                [self writeByteValueToConnectedPeripheral:BLEFetchHeartRateDataCommand withCompletion:nil];
//            }
        }
            break;
            //MARK: 因硬件问题暂时屏蔽
        case SyncStepSleep:
            //        {
            //            NSDate *now = [NSDate date];
            //
            //            //同步睡眠数据
            //            NSDate *date = [BlueToothHelper lastSyncSleepDate];
            //            NSInteger daysBetween = 0;
            //            if (date) { //有值就检查是否可以同步
            //                daysBetween = [NSDate daysBetweenDate:date andDate:now];
            //            } else { //无值直接同步
            //                daysBetween = 7;
            //            }
            //            if (daysBetween >= 1) { //距离上次同步大于1天时间才发送同步命令
            //                [self writeByteValueToConnectedPeripheral:BLESleepCommand withCompletion:nil];
            //            }
            //        }
            //            break;
        case SyncStepClocks: //同步闹钟
            //        {
            //            [self syncClocks];
            //            _syncStep = SyncStepSettings;
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [self sendSyncCommands];
            //            });
            //        }
            //MARK: 因硬件问题直接跳到同步设置
          //  _syncStep = SyncStepSettings;
          //  [self sendSyncCommands];
            break;
        case SyncStepSettings:
            //同步开关
            [self setMuse:BLESettingsDisconnect enable:NO];
            _syncStep = SyncStepEnd;
            break;
            
        default:
            break;
    }
}

#pragma mark - Muse Functions

- (void)calibrationTime {
    
    NSDate *date = [NSDate date];
    Byte command[] = {BLECalibrationTimeCommand, date.year, date.month, date.day,
        date.hour, date.minute, date.second};
    
    NSData *data = [NSData dataWithBytes:command length:7];
    [self writeDataToConnectedPeripheral:data withCompletion:nil];
}

- (void)vibrateWithDuration:(Byte)duration interval:(Byte)interval times:(Byte)times {
    
    Byte command[] = {BLEVibrateCommand, duration, interval, times};
    
    NSData *data = [NSData dataWithBytes:command length:4];
    
   //  LRLog(@"%hhu %hhu",command[0],duration);
    
    [self writeDataToConnectedPeripheral:data withCompletion:nil];
}

- (void)lightingWithColor:(LightColor)color duration:(Byte)duration {
    
    Byte command[] = {BLELightingCommand, color, duration};
    //主动发送0 1 01
   NSData *data = [NSData dataWithBytes:command length:3];
    
    [self writeDataToConnectedPeripheral:data withCompletion:nil];
}

- (BOOL)isMonitorPhoneCall {
    
    BOOL monitorCall = [[[NSUserDefaults standardUserDefaults] objectForKey:MonitorCallEvent]boolValue];
    
    if (monitorCall) {
        return YES;
    }
    
    return NO;
}

//当用户来电1戒指将发出1秒的震动提醒
- (void)monitorPhoneCall {
    
//        if (_callCenter) {
//            return;
//        }
    
        __weak typeof(self) weakSelf = self;
    
        // Monitoring the call information
        _callCenter.callEventHandler = ^(CTCall *call) {
            
            if ([self isMonitorPhoneCall] == YES) {
                //MARK: 来电 发送震动1秒, 等3秒后, 亮绿灯1秒.
                if ([call.callState isEqualToString:CTCallStateIncoming]) {
                    
                    NSLog(@"111111111111");
                    
                    [weakSelf vibrateWithDuration:1 interval:1 times:1];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf lightingWithColor:LightColorGreen duration:3];
                    });
                }
            }

        };
}

- (void)replySOSSuccses {
    
    Byte command[] = {BLESOSCommand, 0x01}; //0x01: 成功， 0x02: 失败
    
    NSData *data = [NSData dataWithBytes:command length:2];
    
    [self writeDataToConnectedPeripheral:data withCompletion:nil];
    
}

- (NSUInteger)convertClockRepeatDay:(ClockRepeatDay)repeatDay {
    NSUInteger bleValue = repeatDay;
    
    if (repeatDay & ClockRepeatEveryday) {
        bleValue = 0b10000000;
    }
    
    return bleValue;
}

//MARK: 因硬件问题暂时屏蔽
- (void)syncClocks {
    //    ClockManager *clockMgr = [ClockManager sharedManager];
    //    if (clockMgr.clocks.count == 0) {
    //        return;
    //    }
    //
    //    NSUInteger length = 1 + clockMgr.clocks.count * 3;
    //    Byte command[length];
    //    command[0] = BLESetClocksCommand;
    //
    //    NSInteger index = 1;
    //    for (ClockData *clock in clockMgr.clocks) {
    //        if (clock.enabled) {
    //            command[index] = [self convertClockRepeatDay:clock.repeatDay];
    //            index++;
    //
    //            NSArray *times = [clock.time componentsSeparatedByString:@":"];
    //            if (times.count == 2) {
    //                command[index] = [times[0] integerValue];
    //                index++;
    //
    //                command[index] = [times[1] integerValue];
    //                index++;
    //            } else {
    //                command[index-1] = 0;
    //
    //                command[index] = 0;
    //                index++;
    //
    //                command[index] = 0;
    //                index++;
    //            }
    //        } else {
    //            command[index] = 0;
    //            index++;
    //
    //            command[index] = 0;
    //            index++;
    //
    //            command[index] = 0;
    //            index++;
    //        }
    //    }
    //
    //    NSData *data = [NSData dataWithBytes:command length:length];
    //    [self writeDataToConnectedPeripheral:data withCompletion:nil];
}

- (void)changeBLEDeviceMode:(Byte)mode {
    Byte command[] = {BLEChangeModeCommand, mode}; //0x00: 普通， 0x01: 睡眠
    NSData *data = [NSData dataWithBytes:command length:2];
    [self writeDataToConnectedPeripheral:data withCompletion:nil];
}

- (BOOL)isMuseSettingEnable:(BLESettings)setting {
    BOOL enable = NO;
    switch (setting) {
        case BLESettingsDisconnect:
            enable = _settings & setting;
            break;
        case BLESettingsAutoHeartRate:
            enable = _settings & setting;
            break;
        case BLESettingsAutoSleep:
            enable = _settings & setting;
            break;
        case BLESettingsEnableClock:
            enable = _settings & setting;
            break;
        case BLESettingsOverHeartRate:
            enable = _settings & setting;
            break;
        case BLESettingsBeCared:
            enable = _settings & setting;
            break;
        default:
            break;
    }
    
    return enable;
}

- (void)setMuse:(BLESettings)setting enable:(BOOL)enable {
    if (enable) {
        _settings |= setting;
    } else {
        NSUInteger value = 0b11111111;
        
        switch (setting) {
            case BLESettingsDisconnect:
                value = 0b11111110;
                break;
            case BLESettingsAutoHeartRate:
                value = 0b11111101;
                break;
            case BLESettingsAutoSleep:
                value = 0b11111011;
                break;
            case BLESettingsEnableClock:
                value = 0b11110111;
                break;
            case BLESettingsOverHeartRate:
                value = 0b11101111;
                break;
            case BLESettingsBeCared:
                value = 0b11011111;
                break;
                
            default:
                break;
        }
        
        _settings &= value;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@(_settings) forKey:MuseSettings];
    [self syncSettings];
}

- (void)syncSettings {
    
    Byte command[5];
    command[0] = BLESettingsCommand;
    command[1] = _settings & BLESettingsDisconnect;
    command[2] = _settings & BLESettingsAutoHeartRate;
    command[3] = _settings & BLESettingsAutoSleep;
    command[4] = _settings & BLESettingsEnableClock;
    
    NSData *data = [NSData dataWithBytes:command length:5];
    [self writeDataToConnectedPeripheral:data withCompletion:nil];
}

- (void)readPower {
    if (self.isBackGround == YES) {
        return;
    }
    [self writeByteValueToConnectedPeripheral:BLEPowerLevelCommand withCompletion:nil];
}
  
- (void)sendMorseCode:(MorseCodeType)morse withCompletion:(void (^ _Nullable)())completion {
    
    if (self.connectedPeripheral.state != CBPeripheralStateConnected) {
        return;
    }
    
    
    if (_sendingMorseCode) {
        if (completion) {
            completion();
        }
        return;
    }
    
    _sendingMorseCode = YES;
    
    NSData *data;
    
    switch (morse) {
        case MorseCodeTypeLove:{
            Byte code[7] = {0x5e, 0x03, 0x04, 0x13, 0x8a, 0xf9, 0x00};
            data = [NSData dataWithBytes:code length:6];
        }
            break;
        case MorseCodeTypeSingle:{
            Byte code[6] = {0x5e, 0x02, 0x08, 0x05, 0x90, 0x00};
            data = [NSData dataWithBytes:code length:6];
        }
            break;
        case MorseCodeTypeDate:{
            Byte code[6] = {0x5e, 0x02, 0x05, 0x8c, 0xb0, 0x00};
            data = [NSData dataWithBytes:code length:6];
        }
            break;
        case MorseCodeTypeHigh:{
            Byte code[7] = {0x5e, 0x02, 0x05, 0x6f, 0xec, 0xb0, 0x00};
            data = [NSData dataWithBytes:code length:6];
        }
            break;
            
        default:
            break;
    }
   
   
    
    if (data) {
        [self writeDataToConnectedPeripheral:data withCompletion:^(CBCharacteristic *characteristic, NSError *error) {
            _sendingMorseCode = NO;
            if (completion) {
                completion();
            }
        }];
    }
}
#pragma mark --- <发送sos>
- (void)judgeWhetherFriendXMl:(NSMutableArray *)friendListArray withAddressBook:(NSMutableArray *)addressBookArray address:(NSString *)address//0672
{
  //  NSString *message = [[NSUserDefaults standardUserDefaults] objectForKey:MiNiMessageKey];
    
      NSString *message = [[NSUserDefaults standardUserDefaults] objectForKey:SOSMessageKey];
    
    if (message.length == 0) {
        message = NSLocalizedString(@"I Need Help", nil);
    }
   
        if (addressBookArray.count == 0) {
            MSLog(@"没有需要发送的对象");
            [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"sosnouser", nil)];

        }else {
            NSMutableString *phones = [[NSMutableString alloc] init];
            
            if (addressBookArray.count == 1) {
                AddressPerson *person = [addressBookArray firstObject];
                phones = [[phones stringByAppendingString:[NSString stringWithFormat:@"%@", person.phone]] mutableCopy];
            } else {
            for (AddressPerson *person in addressBookArray) {
                
                phones = [[phones stringByAppendingString:[NSString stringWithFormat:@"%@,", person.phone]] mutableCopy];
                
            }
                NSString *str = [phones substringToIndex:phones.length - 1];
                [phones setString:str];
            }
            
            NSLog(@"求救是联系人是: %@", phones);
            [self sendMessageSMSToAddressBook:phones message:message address:address];

        }
}


- (void)sendMessageSMSToAddressBook:(NSString *)phones message:(NSString *)message address:(NSString *)address
{
    __weak typeof(self) weakSelf = self;

//    LRLog(@"%@",phones);
    //调用求救接口
    SOSRequest *req = [[SOSRequest alloc] initWithPhones:phones];
    req.area = address;
 //   req.message = [[NSUserDefaults standardUserDefaults] objectForKey:FriendSOSHelpSendMessageKey];

    req.message = message;
    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if (MSRequestIsSuccess(responseData)) {

            //接口调用成功后调用 replySOSSuccses
//            [strongSelf replySOSSuccses];
            
            [[BlueToothHelper sharedInstance] vibrateWithDuration:1 interval:1 times:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[BlueToothHelper sharedInstance] lightingWithColor:LightColorRed duration:2];

            });
        }
        
        [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"sosyifasong", nil)];


        strongSelf->_sendingSOSReq = NO;
    } failure:^(__kindof YTKBaseRequest *request) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_sendingSOSReq = NO;
    }];
}


@end
