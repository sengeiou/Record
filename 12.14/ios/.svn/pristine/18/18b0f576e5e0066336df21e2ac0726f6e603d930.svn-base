//
//  FriendTableViewSubsCell.m
//  Muse
//
//  Created by HaiQuan on 2016/12/4.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "FriendTableViewSubsCell.h"

@implementation FriendTableViewSubsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textLbl.text = NSLocalizedString(@"Time/Min", nil);
    [self.otherImageView setImage:[UIImage imageNamed:@"img_secondarypage_friend"]];
}

- (void)setCellDataWithTimeStr:(NSString *)timeStr rateStr:(NSString *)rateStr isOther:(BOOL)isOther {
    self.timeLbl.text = timeStr;
    self.rateLbl.text = rateStr;
    self.otherImageView.hidden = !isOther;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
