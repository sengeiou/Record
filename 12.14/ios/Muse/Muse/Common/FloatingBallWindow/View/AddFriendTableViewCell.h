//
//  AddFriendTableViewCell.h
//  Muse
//
//  Created by paycloud110 on 16/7/6.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddFriendTableViewCell;

@protocol AddFriendTableViewCellDelegate <NSObject>

- (void)addFriendTableViewCell:(AddFriendTableViewCell *)addFriendTableViewCell withButton:(UIButton *)button;

@end


@interface AddFriendTableViewCell : UITableViewCell

/**  */
@property (nonatomic, weak) id<AddFriendTableViewCellDelegate> delegate;

/** 加载数据 */
- (void)addChildeViewConstantsNameLabel:(NSString *)name;

@end
