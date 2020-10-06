//
//  AddSecrectTableViewCell.h
//  Muse
//
//  Created by paycloud110 on 16/7/7.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSecrect.h"
@class AddSecrectTableViewCell;

@protocol AddSecrectTableViewCellDelegate <NSObject>

- (void)addSecrectTableViewCell:(AddSecrectTableViewCell *)addSecrectTableViewCell withButton:(UIButton *)button;

@end

@interface AddSecrectTableViewCell : UITableViewCell

/**  */
@property (nonatomic, weak) id<AddSecrectTableViewCellDelegate> delegate;
/**  */
@property (nonatomic, weak) UILabel *contentLabel;
/**  */
@property (nonatomic, strong) AddSecrect *addSecrect;

/** 布局控件 */
//- (void)setupData:(NSString *)secrectString;

@end
