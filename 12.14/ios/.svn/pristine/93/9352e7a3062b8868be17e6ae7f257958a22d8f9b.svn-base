//
//  ShareManager.h
//  Muse
//
//  Created by Ken.Jiang on 16/7/13.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ShareType) {
    
    ShareTypeQZone,
    ShareTypeWeChatTimeline,
    ShareTypeWeiBo,
    ShareTypePengYou
};

typedef NS_OPTIONS(NSUInteger, InstalledSharePlatform) {
    InstalledSharePlatformNone = 0,
    InstalledSharePlatformQQ = 1 << 0,
    InstalledSharePlatformWeChat = 1 << 1,
    InstalledSharePlatformWeiBo = 1 << 2,
};

@interface ShareManager : NSObject

+ (instancetype)sharedManager;

@property (assign, readonly, nonatomic) InstalledSharePlatform installedSharePlatforms;

- (BOOL)handleOpenURL:(NSURL *)url;

- (BOOL)shareImage:(UIImage *)image toPlatform:(ShareType)type;

@end
