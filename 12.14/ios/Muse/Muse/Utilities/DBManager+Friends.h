//
//  DBManager+Friends.h
//  Muse
//
//  Created by Ken.Jiang on 16/8/1.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "DBManager.h"

@interface DBManager (Friends)

+ (NSString *)friendsTableName;

- (void)setupFriendsTable;

/**
 *  更新用户亲友列表（从服务器获取）
 *
 *  @param userDics 亲友列表字典（从服务器获取）
 */
- (void)updateUsers:(NSArray<NSDictionary *> *)userDics;

- (NSString *)nicknameForUserID:(NSString *)userID;
/** 获取亲友列表 */
- (NSMutableArray *)getUserFriendListfromDB;

@end
