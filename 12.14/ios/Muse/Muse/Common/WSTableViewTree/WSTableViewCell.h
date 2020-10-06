//
//  WSTableViewCell.h
//  WSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  WSTableViewCell is a custom table view cell class extended from UITableViewCell class. This class is used to represent the
 *  expandable rows of the WSTableView object.
 */

@interface WSTableViewCell :UITableViewCell

/**
 * The boolean value showing the receiver is expandable or not. The default value of this property is NO.
 */
@property (nonatomic, assign, getter = isExpandable) BOOL expandable;

/**
 * The boolean value showing the receiver is expanded or not. The default value of this property is NO.
 */
@property (nonatomic, assign, getter = isExpanded) BOOL expanded;

@end
