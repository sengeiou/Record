//
//  FloatingView.h
//  Muse
//
//  Created by jiangqin on 16/4/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RippleView.h"

@protocol FloatingViewFriendsDataRefreshDelegate <NSObject>

@optional
- (void)didRefreshFriendsData:(NSDictionary *)friendsData friendList:(NSArray *)friendList;

@end

@interface FloatingView : UIView

@property (weak, nonatomic) IBOutlet UIButton *centerButton;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UIImageView *redDot;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet RippleView *rippleView;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;

@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sleepLabel;

@property (readonly, nonatomic) NSDictionary *friendsData;
@property (copy, nonatomic) NSArray *friendListArray;


@property NSString *currentCareID; // 当前关爱的 id


@property (weak, nonatomic) id<FloatingViewFriendsDataRefreshDelegate> delegate;

+ (instancetype)sharedView;

/**
 *  显示亲友数据
 *
 *  @param userID 用户id
 */
- (void)showPersonDataWithUserID:(NSString *)userID;


- (void)updateDataWithUserID:(NSString *)userID;
/**
 *  显示下一条 亲友 状态
 */
- (void)showNextPersonData;

// 刷新亲友列表
- (void)refreshFriendList;

@end
