//
//  AppDelegate.m
//  Muse
//
//  Created by jiangqin on 16/4/12.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "FloatingRootController.h"
#import "MessageBoxViewController.h"

#import "MSConstantDefines.h"
#import <YTKNetwork/YTKNetworkConfig.h>

#import "CommonCrypto/CommonDigest.h"
#import "MuseUser.h"
#import "MSRequest.h"

#import "ShareManager.h"
#import "ClockManager.h"

#import "BlueToothHelper.h"

#import "ContactManager.h"

#import "AddressBookManager.h"

#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () {
    
    NSInteger loginTryTime;
    
}

@end

@implementation AppDelegate

+ (instancetype)appDelegate {
    
    return [UIApplication sharedApplication].delegate;
   
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置App的BaseUrl
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:USERAREACODE]) {
        if ([[[[[NSUserDefaults standardUserDefaults] valueForKey:USERAREACODE] componentsSeparatedByString:@"+"] lastObject] isEqualToString:@"86"]) {
            [YTKNetworkConfig sharedInstance].baseUrl = MuseBaseURL;
        } else {
            [YTKNetworkConfig sharedInstance].baseUrl = MuseBaseURL_HK;
        }
    }
    
   
   // MSLog(@"%@", MuseBaseURL);

    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    loginTryTime = 3;
    
    
    // 正式上线建议关闭
    [CloudPushSDK turnOnDebug];
    // SDK初始化
    [CloudPushSDK asyncInit:ALIPUSH_KEY appSecret:ALIPUSH_SECRET callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
    // 监听推送通道打开动作
    [self listenerOnChannelOpened];
    // 监听推送消息到达
    [self registerMessageReceive];
    [CloudPushSDK sendNotificationAck:launchOptions];

    
    // 需要上传 推送内容

    if ([MuseUser currentUser].phone.length) {
        //刷新token
        [self gotoHomePage];
    
        
    } else {
        [self gotoLoginPage];
    }
    
    [self registerNotification];
    
    // 注册 SMS SDK
    [SMSSDK registerApp:SMSKEY
             withSecret:SMSSECRECT];
    [SMSSDK enableAppContactFriends:NO];
    
    
    // 推送
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
   
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  if (granted) {
                                      [application registerForRemoteNotifications];
                                  }
                              }];
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    

    // content-available 1  后台推送必须
    
    return YES;
}

- (void)gotoLoginPage {
    LoginViewController *rootController = [[LoginViewController alloc] init];
    //       rootController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootController];
    [nav setNavigationBarHidden:YES];
    _window.rootViewController = nav;
    
    [_window makeKeyAndVisible];
}

- (void)gotoHomePage {
    if (loginTryTime == 0) {
        LoginViewController *rootController = [[LoginViewController alloc] init];
        //       rootController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        rootController.isLoginFailed = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootController];
        [nav setNavigationBarHidden:YES];
        _window.rootViewController = nav;
        
        [_window makeKeyAndVisible];
        
    }
    
    
    [MSRequest refreshTokenCompleteBlock:^{
        HomeViewController *rootController;
        rootController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootController];
        [nav setNavigationBarHidden:YES];
        _window.rootViewController = nav;
        
        [_window makeKeyAndVisible];
        
        [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"Login Succeed", nil)];
        
        [CloudPushSDK bindAccount:[kUserDefaults valueForKey:UserDefaultKey_LastUserID] withCallback:^(CloudPushCallbackResult *res) {
            MSLog(@"阿里云推送账号绑定成功!");
        }];
        
        return ;
    } failedBlock:^{
        loginTryTime --;
        [self gotoHomePage];
        return ;
    }];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
    MSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [MuseUser currentUser].device_token = [[[[deviceToken description]
                                             stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                                           stringByReplacingOccurrencesOfString: @" " withString:@""];
    
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success, deviceToken: %@", [CloudPushSDK getApnsDeviceToken]);
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[ClockManager sharedManager] saveSettings];
}

#pragma mark - Accessories

- (UIWindow *)floatingWindow {
    if (!_floatingWindow) {
        _floatingWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _floatingWindow.windowLevel = UIWindowLevelStatusBar - 1;
        
        FloatingRootController *root = [[FloatingRootController alloc] init];
        //root.view.frame = CGRectMake(0, 0, 306, 81);
      //  root.view.backgroundColor = [UIColor yellowColor];
        _floatingWindow.rootViewController = root;
        [_floatingWindow makeKeyAndVisible];
    }
    
    return _floatingWindow;
}

- (UIWindow *)messageFloatingWindow {
    if (_messageFloatingWindow == nil) {
        _messageFloatingWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _messageFloatingWindow.windowLevel = UIWindowLevelStatusBar - 2;
        [_messageFloatingWindow makeKeyAndVisible];
        
        MessageBoxViewController *box = [[MessageBoxViewController alloc] init];
    //    box.view.backgroundColor = [UIColor orangeColor];
        _messageFloatingWindow.rootViewController = box;
    }
    return _messageFloatingWindow;
}

- (UIWindow *)popoverWindow {
    if (!_popoverWindow) {
        _popoverWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _popoverWindow.windowLevel = UIWindowLevelStatusBar;
        [_popoverWindow makeKeyAndVisible];
    }
    
    return _popoverWindow;
}

#pragma mark - Public

- (void)relogin {
    self.window.rootViewController = nil;
    
    UIViewController *rootController = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootController];
    [nav setNavigationBarHidden:YES];
    self.window.rootViewController = nav;
    self.floatingWindow.hidden = YES;
    self.messageFloatingWindow.hidden = YES;
}

#pragma mark - Applications URL

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [[ShareManager sharedManager] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[ShareManager sharedManager] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    return [[ShareManager sharedManager] handleOpenURL:url];
}

#pragma mark --<注册通知>
- (void)registerNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNot:) name:FriendAskforMessageunagreeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNot:) name:FriendAskforMessageAgreeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNot:) name:DeletedFriendAskforNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNot:) name:MiYuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNot:) name:SOSToDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNot:) name:MiYuToDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNot:) name:HeartOverTakeToDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNot:) name:LoveOtherNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNot:) name:Notification_MorseReceive object:nil];

}

- (void)registerNot:(NSNotification *)notifi {
    
    
    
    NSDictionary *dict = notifi.userInfo[@"message"];
    
    NSInteger type = [dict[@"type"] integerValue];
    
    [self sendCommandToDevice:type];

    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[@"time"] integerValue]];
    NSString *timeString = [date stringWithFormat:@"yyyy-MM-dd/HH:mm:ss"];
    
    [dict setValue:timeString forKey:@"time"];
    [dict setValue:[NSString stringWithFormat:@"%d", (int)type] forKey:@"type"];
    
    ContactManager *_manager = [ContactManager sharedInstance];
    if (_manager.allContacts.count > 0) {
        
        for (AddressPerson *person in _manager.allContacts) {
            if ([person.phone hasSuffix:dict[@"from_phone"]]) {
                NSMutableString *tempStr = [[NSMutableString alloc] initWithCapacity:0];
                tempStr = dict[@"message"];
                NSString *phoneNameMsg = [tempStr stringByReplacingOccurrencesOfString:person.phone withString:person.name];
                [dict setValue:phoneNameMsg forKey:@"message"];
                NSLog(@"%@", phoneNameMsg);
                break;
            }
        }
    }
    
    if (!_isBackgroundMode) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:dict[@"message"] toView:self.window hideAfterDelay:2];
        });
    }
    
    [[DBManager sharedManager] addOneMessageBoxContent:dict];

    
    [kNotificationCenter postNotificationName:Notify_ReceiveNewMsg object:nil];

}

// 接受到MQT消息的处理
- (void)sendCommandToDevice:(NSInteger)type
{
    LRLog(@"%ld",(long)type);
    
    if (type == 1) { //关爱
            
    }else if (type == 2) { // 收到亲友请求
        
        [[BlueToothHelper sharedInstance] lightingWithColor:LightColorGreen duration:1];
        
    }else if (type == 100) { // 亲友的sos
        
        [[BlueToothHelper sharedInstance] vibrateWithDuration:1 interval:1 times:3];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[BlueToothHelper sharedInstance] lightingWithColor:LightColorRed duration:8];
        });
        
    }else if (type == 101) { // 收到蜜语
        
        [[BlueToothHelper sharedInstance] vibrateWithDuration:1 interval:0 times:1];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[BlueToothHelper sharedInstance] lightingWithColor:LightColorGreen duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[BlueToothHelper sharedInstance] lightingWithColor:LightColorBlue duration:1];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[BlueToothHelper sharedInstance] lightingWithColor:LightColorGreen duration:1];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [[BlueToothHelper sharedInstance] lightingWithColor:LightColorBlue duration:1];
                    });
                });
            });
        });
        
    }else if (type == 102) { // 收到亲友心率超标
        
        [[BlueToothHelper sharedInstance] vibrateWithDuration:1 interval:0 times:1];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[BlueToothHelper sharedInstance] lightingWithColor:LightColorRed duration:3];
        });
        
        
        
    }
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    [BlueToothHelper sharedInstance].isBackGround = YES;
    [BlueToothHelper sharedInstance].tryConnectTimes = 0;
    
    self.isBackgroundMode = YES;
    
    [kNotificationCenter postNotificationName:Notify_AppEnterBg object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    self.isBackgroundMode = NO;

    
    if (_isFirstEnterApp == NO) {
        return;
    }
    
    [kNotificationCenter postNotificationName:Notify_AppBecomeActive object:nil];
    
    if ([BlueToothHelper sharedInstance].connectedPeripheral.state != CBPeripheralStateConnected && [MuseUser currentUser].phone.length > 0 && [[NSUserDefaults standardUserDefaults] objectForKey:@"LastConnectedDevice"] && (_isFirstEnterApp = NO)) {
        _isFirstEnterApp = YES;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [BlueToothHelper sharedInstance].tryConnectTimes = 0;
            NSLog(@"断开了! 还没有连上");
            [[BlueToothHelper sharedInstance] tryToConnectLastConnectedDevice2];
        });
    }

    [BlueToothHelper sharedInstance].isBackGround = NO;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    NSLog(@"%@", userInfo);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    [MBProgressHUD showHUDWithMessageOnly:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];

    
    if (application.applicationState == UIApplicationStateActive) {
        completionHandler(UIBackgroundFetchResultNewData);

        return;
    }

    
    if (userInfo[@"result"]) {
        
//    NSData *jsonData = [userInfo[@"result"] dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *result = userInfo[@"result"];
        
    if (result) {
        
        
        NSInteger type = [result[@"type"] integerValue];
        switch (type) {
            case 1: //关爱
                [[NSNotificationCenter defaultCenter] postNotificationName:Notify_CareInBgMode object:nil userInfo:nil];
                break;
            case 2: //申请配对（亲友请求类型）： 已废弃使用http请求
            {
                NSMutableArray *partishipArray = [[NSMutableArray alloc] init];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:FriendListPartishipKey]) {
                    partishipArray = [[[NSUserDefaults standardUserDefaults] objectForKey:FriendListPartishipKey] mutableCopy];
                    [partishipArray addObject:result];
                    [[NSUserDefaults standardUserDefaults] setObject:partishipArray forKey:FriendListPartishipKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:partishipArray forKey:FriendListPartishipKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
                break;
            case 3: //同意配对 （亲友请求 同意）： 已废弃使用http请求
                [[NSUserDefaults standardUserDefaults] setObject:result forKey:FriendAskforMessageAgreeKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:FriendAskforMessageAgreeNotification object:nil userInfo:@{@"message":result}];
                break;
            case 4: //不同意配对 （亲友请求 拒绝）： 已废弃使用http请求
                [[NSUserDefaults standardUserDefaults] setObject:result forKey:FriendAskforMessageUnagreeKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:FriendAskforMessageunagreeNotification object:nil userInfo:@{@"message":result}];
                break;
            case 5: // 蜜语
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MiYuAcceptedToCurrentUserKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:MiYuNotification object:nil userInfo:@{@"message":result}];
                break;
            case 6: // 获取亲友删除信息
                [[NSNotificationCenter defaultCenter] postNotificationName:DeletedFriendAskforNotification object:nil userInfo:@{@"message":result}];
                break;
            case 100: // sos to device
                [[NSNotificationCenter defaultCenter] postNotificationName:SOSToDeviceNotification object:nil userInfo:@{@"message":result}];
                break;
            case 101: // 密语 to device
                [[NSNotificationCenter defaultCenter] postNotificationName:MiYuToDeviceNotification object:nil userInfo:@{@"message":result}];
                break;
            case 102: // 超标 to device
                [[NSNotificationCenter defaultCenter] postNotificationName:HeartOverTakeToDeviceNotification object:nil userInfo:@{@"message":result}];
                break;
                
            case 300:
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MorseReceive object:nil userInfo:@{@"message":result}];
                
                [[BlueToothHelper sharedInstance] sendMorseCode:MorseCodeTypeLove withCompletion:nil];
                break;
            case 301:
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MorseReceive object:nil userInfo:@{@"message":result}];
                
                [[BlueToothHelper sharedInstance] sendMorseCode:MorseCodeTypeSingle withCompletion:nil];
                break;
            case 302:
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MorseReceive object:nil userInfo:@{@"message":result}];
                
                [[BlueToothHelper sharedInstance] sendMorseCode:MorseCodeTypeDate withCompletion:nil];
                break;
            case 303:
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MorseReceive object:nil userInfo:@{@"message":result}];
                
                [[BlueToothHelper sharedInstance] sendMorseCode:MorseCodeTypeHigh withCompletion:nil];
                break;
                
            default:
                break;
        }

    }
    }
    
//    [[MqttModel sharedInstance] reconnect];
    
//    [[BlueToothHelper sharedInstance] sendMorseCode:MorseCodeTypeDate withCompletion:^{
//
//    }];
    completionHandler(UIBackgroundFetchResultNewData);

}

#pragma mark Channel Opened
/**
 *	注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelOpened:)
                                                 name:@"CCPDidChannelConnectedSuccess"
                                               object:nil];
}

/**
 *	推送通道打开回调
 *
 *	@param 	notification
 */
- (void)onChannelOpened:(NSNotification *)notification {
    NSLog(@"消息通道建立成功");
}

#pragma mark Receive Message
/**
 *	@brief	注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}

/**
 *	处理到来推送消息
 *
 *	@param 	notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    
    
    if (_isBackgroundMode) {
        return;
    }
    
    
    
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"收到了消息: Receive message title: %@, content: %@.", title, body);
    
    
  
    
    NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (result) {
        
        //            [AppDelegate registerLocalNotification:0 alertContent:result[@"message"]];
        
        NSInteger type = [result[@"type"] integerValue];
        switch (type) {
            case 1: { //关爱
                [[HeartTestManager sharedInstance] setIsCare:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:LoveOtherNotification object:nil userInfo:@{@"message":result}];
            }
                break;
            case 2: { //申请配对（亲友请求类型）： 已废弃使用http请求
                NSMutableArray *partishipArray = [[NSMutableArray alloc] init];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:FriendListPartishipKey]) {
                    partishipArray = [[[NSUserDefaults standardUserDefaults] objectForKey:FriendListPartishipKey] mutableCopy];
                    [partishipArray addObject:result];
                    [[NSUserDefaults standardUserDefaults] setObject:partishipArray forKey:FriendListPartishipKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:partishipArray forKey:FriendListPartishipKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveFriendAskforNotification object:nil userInfo:@{@"message":result}];
            }
                break;
            case 3: //同意配对 （亲友请求 同意）： 已废弃使用http请求
                [[NSUserDefaults standardUserDefaults] setObject:result forKey:FriendAskforMessageAgreeKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:FriendAskforMessageAgreeNotification object:nil userInfo:@{@"message":result}];
                [kNotificationCenter postNotificationName:Refresh_FriendAskforMessageAgreeNotification object:nil];
                break;
            case 4: //不同意配对 （亲友请求 拒绝）： 已废弃使用http请求
                [[NSUserDefaults standardUserDefaults] setObject:result forKey:FriendAskforMessageUnagreeKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:FriendAskforMessageunagreeNotification object:nil userInfo:@{@"message":result}];
                break;
            case 5: // 蜜语
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MiYuAcceptedToCurrentUserKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:MiYuNotification object:nil userInfo:@{@"message":result}];
                break;
            case 6: // 获取亲友删除信息
                [[NSNotificationCenter defaultCenter] postNotificationName:DeletedFriendAskforNotification object:nil userInfo:@{@"message":result}];
                break;
            case 100: // sos to device
                [[NSNotificationCenter defaultCenter] postNotificationName:SOSToDeviceNotification object:nil userInfo:@{@"message":result}];
                break;
            case 101: // 密语 to device
                [[NSNotificationCenter defaultCenter] postNotificationName:MiYuToDeviceNotification object:nil userInfo:@{@"message":result}];
                break;
            case 102: // 超标 to device
                [[NSNotificationCenter defaultCenter] postNotificationName:HeartOverTakeToDeviceNotification object:nil userInfo:@{@"message":result}];
                break;
                
            case 1111: // 刷新亲友状态 1111
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFriendStateNotification object:nil userInfo:nil];
                break;
                
            case 300:
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MorseReceive object:nil userInfo:@{@"message":result}];
                [[BlueToothHelper sharedInstance] sendMorseCode:MorseCodeTypeLove withCompletion:nil];
                
                break;
            case 301:
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MorseReceive object:nil userInfo:@{@"message":result}];
                [[BlueToothHelper sharedInstance] sendMorseCode:MorseCodeTypeSingle withCompletion:nil];
                
                break;
            case 302:
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MorseReceive object:nil userInfo:@{@"message":result}];
                
                [[BlueToothHelper sharedInstance] sendMorseCode:MorseCodeTypeDate withCompletion:nil];
                break;
            case 303:
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MorseReceive object:nil userInfo:@{@"message":result}];
                
                [[BlueToothHelper sharedInstance] sendMorseCode:MorseCodeTypeHigh withCompletion:nil];
                break;
                
            default:
                break;
        }
    }

}




@end