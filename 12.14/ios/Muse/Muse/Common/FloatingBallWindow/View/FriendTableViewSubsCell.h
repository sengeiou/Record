//
//  FriendTableViewSubsCell.h
//  Muse
//
//  Created by HaiQuan on 2016/12/4.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewSubsCell : UITableViewCell

@property IBOutlet UILabel *timeLbl;
@property IBOutlet UILabel *rateLbl;
@property IBOutlet UIImageView *otherImageView;
@property IBOutlet UILabel *textLbl;

- (void)setCellDataWithTimeStr:(NSString *)timeStr rateStr:(NSString *)rateStr isOther:(BOOL)isOther;

@end
