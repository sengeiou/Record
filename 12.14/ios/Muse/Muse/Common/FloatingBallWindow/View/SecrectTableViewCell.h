//
//  SecrectTableViewCell.h
//  Muse
//
//  Created by paycloud110 on 16/7/15.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecrectTableViewCell : UITableViewCell

/**  */
@property (nonatomic, weak) UIButton *button;

- (void)setSecrect:(NSString *)string;

@end
