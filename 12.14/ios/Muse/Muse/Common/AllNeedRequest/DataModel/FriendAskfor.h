//
//  FriendAskfor.h
//  Muse
//
//  Created by paycloud110 on 16/7/24.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendAskfor : NSObject

/**  */
@property (nonatomic, copy) NSString *form_id;
/**  */
@property (nonatomic, copy) NSString *to_id;
/**  */
@property (nonatomic, assign) NSInteger time;
/**  */
@property (nonatomic, assign) NSInteger type;
/**  */
@property (nonatomic, copy) NSString *message;

@end
