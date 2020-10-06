//
//  AllRequest.h
//  Muse
//
//  Created by paycloud110 on 16/7/12.
//  Copyright © 2016年 Muse. All rights reserved.
//

#ifndef AllRequest_h
#define AllRequest_h

#import "GetUserFriendListRequest.h"
#import "AskforFriendAttentionRequest.h"
#import "GetFriendListHealthDataRequest.h"
#import "FriendRecentlyNineDayDataRequest.h"
#import "SendSecrectToFriendRequest.h"
#import "SendSecrectToFriendRequest.h"
#import "DisposeFriendPartnershipRequest.h"
#import "DeleteListFriendRequest.h"

//#import "MessageDB.h"

#pragma mark --<通知宏定义>
// 通知
#define ReceiveFriendAskforNotification @"ReceiveFriendAskforNotification"
#define FriendAskforMessageAgreeNotification @"FriendAskforMessageAgreeNotification"
#define FriendAskforMessageunagreeNotification @"FriendAskforMessageunagreeNotification"
#define DeletedFriendAskforNotification @"deletedFriendAskforNotification"
#define MiYuNotification @"MiYuNotification"
#define LoveOtherNotification @"LoveOtherNotification"

#define Refresh_DeletedFriendAskforNotification @"Refresh_DeletedFriendAskforNotification"
#define Refresh_FriendAskforMessageAgreeNotification @"Refresh_FriendAskforMessageAgreeNotification"
#define FriendAskforMessageAgreeNotification2 @"FriendAskforMessageAgreeNotification2"
#define DeletedFriendAskforNotification2 @"deletedFriendAskforNotification2"


#define SOSToDeviceNotification @"SOSToDeviceNotification"
#define MiYuToDeviceNotification @"MiYuToDeviceNotification"
#define HeartOverTakeToDeviceNotification @"HeartOverTakeToDeviceNotification"
#define RefreshFriendStateNotification @"RefreshFriendStateNotification"


#define ReceiveMorseLove @"ReceiveMorseLove"
#define ReceiveMorseSingle @"ReceiveMorseSingle"
#define ReceiveMorseCome @"ReceiveMorseCome"
#define ReceiveMorseHigh @"ReceiveMorseHigh"


// 本地存储
#define FriendAskforMessageKey @"FriendAskforMessageKey"
#define FriendAskforMessageAgreeKey @"FriendAskforMessageAgreeKey"
#define FriendAskforMessageUnagreeKey @"FriendAskforMessageUnagreeKey"
#define FriendSOSHelpSendMessageKey @"FriendSOSHelpSendMessageKey"
#define MiYuAcceptedToCurrentUserKey @"MiYuAcceptedToCurrentUserKey"
#define MiNiMessageKey @"MiNiMessageKey"
#define SOSMessageKey @"SOSMessageKey"

// 标志
#define EnterAddressBookKey @"EnterAddressBookKey"

#endif /* AllRequest_h */










