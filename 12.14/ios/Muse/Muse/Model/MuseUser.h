//
//  MuseUser.h
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MuseUser : NSObject

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *contact_name;

+ (MuseUser *)currentUser;

- (void)updateUser:(MuseUser *)user;
- (void)cleanCurrentUser;

@end
