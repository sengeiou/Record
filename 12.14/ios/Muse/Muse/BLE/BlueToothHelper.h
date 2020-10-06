//
//  BlueToothHelper.h
//  Muse
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <BabyBluetooth/BabyBluetooth.h>

NS_ASSUME_NONNULL_BEGIN
 //assume_nonnull _begin
extern Byte const BLECalibrationTimeCommand; //校准时间
extern Byte const BLEFetchHeartRateDataCommand; //同步心率数据
extern Byte const BLEHeartRateCommand; //获取心率
extern Byte const BLESOSCommand; //一键呼救
extern Byte const BLEVibrateCommand; //震动
extern Byte const BLESetClocksCommand; //设置闹钟时间
extern Byte const BLEChangeModeCommand; //切换模式
extern Byte const BLESleepCommand; //睡眠监测
extern Byte const BLEBandingCommand; //连接成功后绑定指令
extern Byte const BLETakePictureCommand; //拍照or密语
extern Byte const BLELightingCommand; //亮灯指令
extern Byte const BLESettingsCommand; //各种开关设置
extern Byte const BLEPowerLevelCommand; //读取电量

extern NSString *const PeripheralBeginConnectNotification;
extern NSString *const PeripheralConnectedNotification;
extern NSString *const PeripheralDisconnectedNotification;

extern NSString *const ReadBLEPowerLevelNotification;
extern NSString *const ReceivedSOSNotification;
extern NSString *const ReceivedTakePictureNotification;
extern NSString *const SendSecretNotification;

typedef NS_ENUM(NSUInteger, BLEValueType) {
    BLEValueTypeHeartRate,
};



typedef NS_OPTIONS(NSUInteger, BLESettings) {
    //以下设置同步保存到手机和戒指
    BLESettingsDisconnect = 1 << 0, //丢失连接震动
    BLESettingsAutoHeartRate = 1 << 1, //自动检测心率
    BLESettingsAutoSleep = 1 << 2, //自动检测睡眠
    BLESettingsEnableClock = 1 << 3, //闹铃开关
    
    //以下设置只保存到手机
    BLESettingsOverHeartRate = 1 << 4, //健康值超标震动
    BLESettingsBeCared = 1 << 5, //被关爱提醒震动
};

typedef NS_ENUM(NSUInteger, LightColor) {
    LightColorGreen = 1,
    LightColorRed,
    LightColorBlue,
    
//    LightColorRed = 1,
//    LightColorGreen,
//    LightColorBlue,

};

/**
 *  蓝牙发送摩斯密码的类型
 */
typedef NS_ENUM(NSUInteger, MorseCodeType) {
    /**
     *  我爱你
     */
    MorseCodeTypeLove,
    /**
     *  单身中
     */
    MorseCodeTypeSingle,
    /**
     *  约个会吧
     */
    MorseCodeTypeDate,
    /**
     *  嗨起来
     */
    MorseCodeTypeHigh
};

@interface BlueToothHelper : NSObject


@property (strong, readonly, nonatomic, nullable) NSMutableArray<CBPeripheral *> *scanedPeripherals;
@property (strong, readonly, nonatomic, nullable) CBPeripheral *connectedPeripheral;

@property (assign, readonly, nonatomic) Byte heartRate;

/**
 *  蓝牙电量信息0～100.
 */
@property (assign, readonly, nonatomic) Byte powerLevel;


@property (nonatomic, assign) NSUInteger tryConnectTimes; // 重连次数


/**
 *  收到BLETakePictureCommand指令后，是否发送密语还是响应拍照功能
 */
@property (assign, nonatomic) BOOL secretMode;
//弹框还是不弹框
@property (assign, nonatomic) BOOL needPop;


// 戒指忙碌状态
@property (assign, nonatomic) BOOL isRingBusy;

// 是否在后台运行
@property (assign, nonatomic) BOOL isBackGround;

// 是否在发送 摩斯码
@property (assign, nonatomic) BOOL sendingMorseCode;

// 是否自动登录
@property (assign, nonatomic) BOOL isSaveAutoConnect;

- (void)_setupBabyDelegate;

+ (instancetype)sharedInstance;

+ (void)killBlueToothHelper;

- (void)startScanWithCompletion:(void (^ _Nullable)(NSArray<CBPeripheral *> *scanedPeripherals))completion;

- (void)cancelScan;

- (void)cancelAllConnected;



/**
 *  连接蓝牙指令
 *
 *  @param peripheral  待连接的蓝牙
 *  @param deviceQurey 只做连接测试，不发送同步指令等
 *  @param completion  连接成功后的callback
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral
              deviceQurey:(BOOL)isDeviceQurey
               completion:(void (^ _Nullable)(BOOL successed))completion;

/**
 *  尝试连接上次的设备。尝试5次，如果失败则连接搜索到的第一个
 */
- (void)tryToConnectLastConnectedDevice2;

- (void)tryToConnectLastConnectedDevice;

- (void)writeByteValueToConnectedPeripheral:(Byte)value
                             withCompletion:(_Nullable BBDidWriteValueForCharacteristicBlock)completion;
- (void)writeDataToConnectedPeripheral:(NSData *)data
                        withCompletion:(_Nullable BBDidWriteValueForCharacteristicBlock)completion;
- (void)notifiyConnectedPeripheral:(BOOL)notify withCallback:(void (^ _Nullable)(BLEValueType type, Byte value, NSError *error))callback;

#pragma mark - Muse Functions

- (void)calibrationTime;

- (void)vibrateWithDuration:(Byte)duration interval:(Byte)interval times:(Byte)times;
- (void)lightingWithColor:(LightColor)color duration:(Byte)duration;

- (BOOL)isMonitorPhoneCall;
- (void)monitorPhoneCall;

- (void)replySOSSuccses;

- (void)syncClocks;

/**
 *  切换模式: 0为普通模式 1为睡眠模式
 *
 *  @param mode 0为普通模式 1为睡眠模式
 */
- (void)changeBLEDeviceMode:(Byte)mode;

/**
 *  戒指功能是否开启
 *
 *  @param setting 戒指功能
 *
 *  @return 是否开启
 */
- (BOOL)isMuseSettingEnable:(BLESettings)setting;

/**
 *  设置开启/关闭戒指功能：包括防丢开关，自动测试心率开关，自动检测睡眠开关，闹钟开关
 *
 *  @param setting 具体的设置
 *  @param enable  是否开启功能
 */
- (void)setMuse:(BLESettings)setting enable:(BOOL)enable;

/**
 *  发送摩斯密语
 *
 *  @param morse        密语类型
 *  @param completion   发送完的回调
 */
- (void)sendMorseCode:(MorseCodeType)morse withCompletion:(void (^ _Nullable)())completion;

@end

NS_ASSUME_NONNULL_END
