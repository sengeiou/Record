//
//  AboutTableViewCell.h
//  Muse
//
//  Created by songbaoqiang on 16/8/19.
//  Copyright © 2016年 Muse. All rights reserved.
//
;
#import <UIKit/UIKit.h>
@class AboutTableViewCell;
@protocol AboutTableViewCellDelegate <NSObject>

-(void)aboutTableViewCell:(AboutTableViewCell *)cell btn:(UIButton *)btn;
@end
@interface AboutTableViewCell : UITableViewCell
@property (nonatomic, weak) id<AboutTableViewCellDelegate> delegate;

- (void)setupChildView;
@end
