//
//  FeedBackIdeaTableViewCell.h
//  Muse
//
//  Created by paycloud110 on 16/7/19.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "WSTableViewCell.h"
@class FeedBackIdeaTableViewCell;

@protocol FeedBackIdeaTableViewCellDelegate <NSObject>

- (void)feedBackIdeaTableViewCell:(FeedBackIdeaTableViewCell *)feedBackIdeaTableViewCell
                     withFeedback:(NSString *)content
                          contact:(NSString *)contact;

@end

@interface FeedBackIdeaTableViewCell : WSTableViewCell

@property (nonatomic, weak) id<FeedBackIdeaTableViewCellDelegate> delegate;

- (void)setupChildView;

@end
