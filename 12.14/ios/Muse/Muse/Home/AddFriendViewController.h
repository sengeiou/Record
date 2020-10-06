//
//  AddFriendViewController.h
//  Muse
//
//  Created by songbaoqiang on 16/8/21.
//  Copyright © 2016年 Muse. All rights reserved.
//


#import "MSViewController.h"
#import "FriendList.h"
@protocol AddFriendViewControllerDelegate <NSObject>

-(void)AddFriendViewController:(UIViewController *)vc friendModelArray:(NSMutableArray *)friendModelArray;

@end
typedef void(^FriendListBlock)(FriendList *);

@interface AddFriendViewController : MSViewController

@property (nonatomic, weak) id<AddFriendViewControllerDelegate> delegate;
/**  */
@property (nonatomic, strong) NSMutableArray *friendListArray;

@property (nonatomic, strong) NSMutableArray *friendModelArray;

@end