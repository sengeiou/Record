//
//  ClockSettingTableViewCell.h
//  Muse
//
//  Created by Ken.Jiang on 23/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockManager.h"

@protocol ClockSettingTableViewCellDelegate <NSObject>

- (void)didChangeTime:(NSString *)time inSection:(NSInteger)section;
- (void)updateRepeatDay:(ClockRepeatDay)repeatDay append:(BOOL)append inSection:(NSInteger)section;

@end

@interface ClockSettingTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *time;
@property (assign, nonatomic) ClockRepeatDay repeatDay;

@property (assign, nonatomic) NSInteger section;
@property (weak, nonatomic) id<ClockSettingTableViewCellDelegate> delegate;

- (void)updateTimePicker;

@end
