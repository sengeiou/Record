//
//  NewsNoticeCell.h
//  Muse
//
//  Created by songbaoqiang on 16/8/14.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsNoticeCell : UITableViewCell

@property (nonatomic, weak) UIView *bottomLineView;
@property (nonatomic, weak) UIView *topLineView;
/**  */
@property (nonatomic, strong) UILabel *rightTimeLabel;
/**  */
@property (nonatomic, assign) CGFloat rightLabelHeight;

- (void)setupChildView:(NSString *)time content:(NSString *)content height:(CGFloat)height;

@end
