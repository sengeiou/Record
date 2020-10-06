//
//  DBManager+Friends.m
//  Muse
//
//  Created by Ken.Jiang on 16/8/1.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "DBManager+Friends.h"

@implementation DBManager (Friends)

+ (NSString *)friendsTableName {
    return @"FriendsTable";
}

+ (NSDictionary<NSString *, NSString *> *)friendsTableInfo {
    return @{@"userid":@"Text Unique",
             @"phone":@"Text",
             @"nickname":@"Text",
             @"avatar":@"Text",
             @"contact_name":@"Text",};
}

#pragma mark - Public

- (void)setupFriendsTable {
    [self setupTable:[DBManager friendsTableName]
       withTableInfo:[DBManager friendsTableInfo]];
}

#pragma mark - Update

- (void)updateUsers:(NSArray<NSDictionary *> *)userDics {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db setShouldCacheStatements:YES];
        NSString *sql = @"REPLACE INTO FriendsTable (userid, phone, nickname, avatar, contact_name) VALUES (?, ?, ?, ?, ?)";
        
        [db beginTransaction];
        for (NSDictionary *userDic in userDics) {
            if (userDic[@"id"]) {
                [db executeUpdate:sql, userDic[@"id"], userDic[@"phone"], userDic[@"nickname"], userDic[@"avatar"], userDic[@"contact_name"]];
            }
        }
        [db commit];
    }];
}

#pragma mark - Query

- (NSString *)nicknameForUserID:(NSString *)userID {
    if (!userID) {
        return nil;
    }
    
    __block NSString *nickname;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT nickname FROM FriendsTable WHERE userid = %@", userID];
        
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            nickname = [rs stringForColumn:@"nickname"];
        }
        [rs close];
    }];
    
    return nickname;
}
/** 获取亲友列表 */
- (NSMutableArray *)getUserFriendListfromDB
{
    NSMutableArray *fiendList = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM FriendsTable"];
        FMResultSet *result = [db executeQuery:sql];
        while (result.next) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         [result stringForColumn:@"userid"], @"userid",
                                         [result stringForColumn:@"phone"], @"phone",
                                         [result stringForColumn:@"nickname"], @"nickname",
                                         [result stringForColumn:@"avatar"], @"avatar",
                                         [result stringForColumn:@"contact_name"], @"contact_name",
                                         nil];
            [fiendList addObject:dict];
        }
        [result close];
    }];
    return fiendList;
}
@end
