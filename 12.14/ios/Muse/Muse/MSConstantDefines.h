//
//  MSConstantDefines.h
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#ifndef MSConstantDefines_h
#define MSConstantDefines_h

//-------- APP KEY --------

#define SMSKEY @"19204a7cc0a6b"
#define SMSSECRECT @"fe8ef3ef228ee0e121d3c103435b84c3"
#define USERAREACODE @"userAreaCode" // 存储 UserAreaCode UserDefault 存 区域码
#define USERMILOCATIONSTATE @"userMiLocationState" // 存储 mi你位置信息发送 UserDefault 存 BOOL

//-------- 配置 --------

#define Development 1

//-------- Macros --------

#if Development

/** 老地址 */
//#define OldNetwork @"120.76.221.254"
/** 新地址 */
#define newNetwork @"114.215.158.238" // 测试
//#define newNetwork @"120.76.221.254" // 线上
#define newNetwork_HK @"119.28.17.156"
//http://114.215.158.238/muse/index.php
/** 基础URL */
#define MuseBaseURL  [NSString stringWithFormat:@"http://%@/muse/index.php", newNetwork]
#define MuseBaseURL_HK  [NSString stringWithFormat:@"http://%@/muse/index.php", newNetwork_HK]

//新MQTT地址
//参考 MQT CLASS IP



#else

#endif


#define ALIPUSH_KEY @"23543432"
#define ALIPUSH_SECRET @"8b494e3567b47a511590efcc0d042470"

//
#define CURRENTLANGUAGE [[NSLocale preferredLanguages] objectAtIndex:0]


#define UserDefaultKey_LastUserPhone @"UserDefaultKey_LastUserPhone"
#define UserDefaultKey_LastUserID @"UserDefaultKey_LastUserID"
#define MonitorCallEvent        @"MonitorCallEvent"
#define USERLOSTSTATE @"UserLostState"
#define UserDefaultKey_LastCareFriend @"UserDefaultKey_LastCareFriend"

#define Notify_AddCantactShow @"Notify_AddCantactShow"
#define Notify_AddCantactHide @"Notify_AddCantactHide"

#define UserDefaultKey_DefaultPhone @"UserDefaultKey_DefaultPhone"

#define Notification_MorseReceive @"Notification_MorseReceive"
#define Notification_SyncHeartRate @"Notification_SyncHeartRate"
#define Notify_CareInBgMode @"Notify_CareInBgMode"

#define Notify_AppBecomeActive @"Notify_AppBecomeActive"
#define Notify_AppEnterBg @"Notify_AppEnterBg"
#define Notify_UploadHeartRateSucceed @"Notify_UploadHeartRateSucceed"
#define Notify_ReceiveNewMsg @"Notify_ReceiveNewMsg"

// 文件
#define EmergencyContacts @"EmergencyContacts"
#define SecretTalkContacts @"SecretTalkContacts"
#define MorseContacts @"MorseContacts"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 打印当前方法
#ifdef DEBUG
#define SSNSLogFunc(...) NSLog(@" %s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define SSNSLogFunc(...)
#endif

//#define SSNSLogFunc() MSLog(@"%s", __func__)
// 弱引用
#define SSWeakSelf() __weak typeof(self) weakSelf = self
// 强引用
#define SSStrongSelf() __strong typeof(self) strongSelf = self

// 设置颜色
#define UIColorWithRGBA(r, g, b, a) [[UIColor alloc] initWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorWithRGB(r, g, b) UIColorWithRGBA(r, g, b, 1.0)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

/** 测试描述色 */
#define ColorWithLightTan       UIColorFromRGB(0xd5e55a)
#define ColorWithLightBrown     UIColorFromRGB(0xa2b93c)
#define ColorWithBlackGreen     UIColorFromRGB(0x696943)
#define ColorWithGrassGreen     UIColorFromRGB(0xa69c89)
#define ColorWithRiceColor      UIColorFromRGB(0xd2cdbb)

#define SScreenHeight   ([[UIScreen mainScreen] bounds].size.height)
#define SScreenWidth    ([[UIScreen mainScreen] bounds].size.width)

#ifdef DEBUG
#define MSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define MSLog(format, ...)
#endif


//iOS10
#ifdef DEBUG
#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define ZHLog10(...) printf("时间%f  类名: %s   第%d行  信息:  %s   \n\n",[[NSDate date]timeIntervalSince1970], [LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else

#endif


#ifdef DEBUG

#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent

#define LRLog(...) printf("类名: %s   第%d行  信息:  %s   \n\n", [LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define LRLog(...)
#endif

/** key */
#define FriendListPartishipKey @"FriendListPartishipKey"

/** 文件保存路径 */
#define PATH_IN_DOCUMENTS_DIR(f) ([NSString stringWithFormat:@"%@/Documents/%@",  NSHomeDirectory(), f])


//9.27新增
#import "MSConst.h"
//获取设备
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#import <HYBHelperKit/HYBHelperKit.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

#define postNotification(name,ower,info) [[NSNotificationCenter defaultCenter] postNotificationName:name object:ower userInfo:(info)]

#define isIOS9 ([[UIDevice currentDevice].systemVersion intValue]>=9?YES:NO)

#define isIOS10 ([[UIDevice currentDevice].systemVersion intValue]>=10?YES:NO)

#define localizedString(string) NSLocalizedString((string), nil)



#endif /* MSConstantDefines_h */