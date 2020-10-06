//
//  ClockSettingTableHeader.h
//  Muse
//
//  Created by Ken.Jiang on 23/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClockSettingTableHeaderDelegate <NSObject>

- (void)expandClockSettingAtSection:(NSInteger)section;
- (void)enableClockAtSection:(NSInteger)section;
- (void)deleteClockAtSection:(NSInteger)section;
- (void)saveClockAtSection:(NSInteger)section;

@end

@interface ClockSettingTableHeader : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatDayLabel;
@property (weak, nonatomic) IBOutlet UISwitch *enableSwitch;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (assign, nonatomic) NSInteger section;

@property (assign, nonatomic) BOOL clockEnabled;

@property (assign, nonatomic) BOOL editing;

@property (weak, nonatomic) id<ClockSettingTableHeaderDelegate> delegate;

@end
