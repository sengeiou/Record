//
//  ShareManager.m
//  Muse
//
//  Created by Ken.Jiang on 16/7/13.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "ShareManager.h"

#import <TencentOpenAPI/TencentOAuth.h> 
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeChat/WXApi.h"
#import <WeiboSDK/WeiboSDK.h>

#import "MBProgressHUD+Simple.h"


//腾讯开放平台（open.qq.com）App Key:   50Od12d1Z7o7p4yt
#define QQAPPID  @"1105523342"

//微信开放平台（open.weixin.qq.com） AppSecret：0f07647e846bb9c3a32fc99560a412e7
#define WeChatAPPID @"wxccb3f1cfa66cdc59"


//新浪微博开放平台（open.weibo.com）App Secret：4111c500ac5403b684b8e99b47321118
#define WeiBoAppKey @"4235906808"

@interface ShareManager () <TencentSessionDelegate, WXApiDelegate, WeiboSDKDelegate> {
    TencentOAuth *_tencentOAuth;
}

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

@end

@implementation ShareManager

+ (instancetype)sharedManager {
    static ShareManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ShareManager alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self registerPlatform];
    }
    
    return self;
}

#pragma mark - Register 

- (void)registerPlatform {
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:self];
    [WXApi registerApp:WeChatAPPID];
    [WeiboSDK registerApp:WeiBoAppKey];
}

#pragma mark - Utilities

- (NSData *)dataFromImage:(UIImage *)image {
    return UIImageJPEGRepresentation(image, 0.8);
}

#pragma mark - QQ TencentSessionDelegate

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
    
}

- (BOOL)handleQQSendResult:(QQApiSendResultCode)sendResult {
    BOOL successed = NO;
    MSLog(@"%d",sendResult);
    switch (sendResult){
        case EQQAPIAPPNOTREGISTED: //App未注册
            break;
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
            [MBProgressHUD showHUDWithMessageOnly:@"发送参数错误"];
            break;
        case EQQAPIQQNOTINSTALLED:
            [MBProgressHUD showHUDWithMessageOnly:@"未安装手Q"];
            break;
        case EQQAPIQQNOTSUPPORTAPI: //API接口不支持
           // [MBProgressHUD showHUDWithMessageOnly:@"不支持此类分享"];
            [MBProgressHUD showHUDWithMessageOnly:localizedString(@"youDeveiceNotInstallQQ")];
            break;
        case EQQAPISENDFAILD:
            [MBProgressHUD showHUDWithMessageOnly:@"发送失败"];
            break;
        case EQQAPIQZONENOTSUPPORTTEXT://空间分享不支持QQApiTextObject，请使用QQApiImageArrayForQZoneObject分享
            //[MBProgressHUD showHUDWithMessageOnly:@"不支持此类分享"];
            break;
        case EQQAPIQZONENOTSUPPORTIMAGE://空间分享不支持QQApiImageObject，请使用QQApiImageArrayForQZoneObject分享
          //  [MBProgressHUD showHUDWithMessageOnly:@"不支持此类分享"];
            break;
        case EQQAPIVERSIONNEEDUPDATE:
            [MBProgressHUD showHUDWithMessageOnly:@"当前QQ版本太低，需要更新"];
            break;
        default:
            successed = YES;
            break;
    }
    
    return successed;
}

#pragma mark - WeiXin WXApiDelegate

- (void)onReq:(BaseReq*)req {
    MSLog(@"%@", req);
}
//QQ空间
- (BOOL)shareImageToQZone:(UIImage *)image {
    
    QQApiImageArrayForQZoneObject *img = [QQApiImageArrayForQZoneObject objectWithimageDataArray:@[[self dataFromImage:image]] title:nil];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:img];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    return [self handleQQSendResult:sent];
}
- (BOOL)shareImageToQQ:(UIImage *)image {
    
    NSData *data = [self dataFromImage:image];
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:data
                                
                                               previewImageData:data
                                
                                                          title:nil
                                
                                                    description:nil];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    

    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
     return [self handleQQSendResult:sent];
    
}
//微信
- (BOOL)shareImageToWeChat:(UIImage *)image {
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = [self dataFromImage:image];

    WXMediaMessage *message = [WXMediaMessage message];
    
    message.mediaObject = ext;
    

    
    [message setThumbImage:image];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    
    
    req.scene = WXSceneSession;
    
    
   
    if (![WXApi isWXAppInstalled]) {
        
        [MBProgressHUD showHUDWithMessageOnly:localizedString(@"youDeveiceNotInstallWechat")];
        
        return NO;
    }

    
    
    return [WXApi sendReq:req];
}
//盆友圈
- (BOOL)shareImageToWeChatFriendCircle:(UIImage *)image {
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = [self dataFromImage:image];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.scene = WXSceneTimeline;
     MSLog(@"%d",[WXApi sendReq:req]);
    
    if (![WXApi isWXAppInstalled]) {
        
         [MBProgressHUD showHUDWithMessageOnly:localizedString(@"youDeveiceNotInstallWechat")];
        
        return NO;
    }
    
    return [WXApi sendReq:req];

}
#pragma mark - Weibo WeiboSDKDelegate


/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        if ((int)response.statusCode == 0) {
            [MBProgressHUD showHUDWithMessageOnly:@"分享成功"];
        } else {
            [MBProgressHUD showHUDWithMessageOnly:@"分享失败"];
        }

    } else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        if ((int)response.statusCode == 0) {
            self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
            self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
            self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
            
            [MBProgressHUD showHUDWithMessageOnly:@"授权成功"];
        } else {
            [MBProgressHUD showHUDWithMessageOnly:@"授权失败"];
        }
    }
}

#pragma mark - Public

- (InstalledSharePlatform)installedSharePlatforms {
    
    InstalledSharePlatform installed = [TencentOAuth iphoneQQInstalled] || [TencentOAuth iphoneQZoneInstalled] ? InstalledSharePlatformQQ : InstalledSharePlatformNone;
    
    if ([WXApi isWXAppInstalled]) {
        installed |= InstalledSharePlatformWeChat;
    }
    
    if ([WeiboSDK isWeiboAppInstalled]) {
        installed |= InstalledSharePlatformWeiBo;
    }
    
    return installed;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    
    if ([[url host] isEqualToString:QQAPPID] || [[url host] containsString:@"tencent"]
        || [[url host] containsString:@"qzone"] || [[url host] containsString:@"qq"]) {
        return [TencentOAuth HandleOpenURL:url];
    } else if ([[url host] isEqualToString:WeChatAPPID]){
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([[url host] isEqualToString:WeiBoAppKey]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return NO;
}

- (BOOL)shareImage:(UIImage *)image toPlatform:(ShareType)type {
    BOOL send = NO;
  
    switch (type) {
        case ShareTypeQZone:
            send = [self shareImageToQQ:image];
            break;
        case ShareTypeWeChatTimeline:
          send = [self shareImageToWeChat:image];
            break;
        case ShareTypeWeiBo:
            send = [self shareImageToWeChatFriendCircle:image];
            break;

        case ShareTypePengYou:
            send = [self shareImageToQZone:image];
            break;

            
        default:
            break;
    }
    
    return send;
}

@end
