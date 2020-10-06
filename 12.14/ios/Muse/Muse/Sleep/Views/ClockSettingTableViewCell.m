//
//  ClockSettingTableViewCell.m
//  Muse
//
//  Created by Ken.Jiang on 23/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "ClockSettingTableViewCell.h"
#import "TimePicker.h"
#import "NSDate+FastKit.h"

@interface ClockSettingTableViewCell () {
    NSArray *_buttons;
}

@property (weak, nonatomic) IBOutlet TimePicker *timePicker;

@property (weak, nonatomic) IBOutlet UIButton *everyDayButton;
@property (weak, nonatomic) IBOutlet UIButton *mondayButton;
@property (weak, nonatomic) IBOutlet UIButton *tuesdayButton;
@property (weak, nonatomic) IBOutlet UIButton *wednesdayButton;
@property (weak, nonatomic) IBOutlet UIButton *thursdayButton;
@property (weak, nonatomic) IBOutlet UIButton *fridayButton;
@property (weak, nonatomic) IBOutlet UIButton *saturdayButton;
@property (weak, nonatomic) IBOutlet UIButton *sundayButton;
@property (weak, nonatomic) IBOutlet UIButton *onceButton;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;

@end

@implementation ClockSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _everyDayButton.tag = ClockRepeatEveryday;
    _mondayButton.tag = ClockRepeatMonday;
    _tuesdayButton.tag = ClockRepeatTuesday;
    _wednesdayButton.tag = ClockRepeatWednesday;
    _thursdayButton.tag = ClockRepeatThursday;
    _fridayButton.tag = ClockRepeatFriday;
    _saturdayButton.tag = ClockRepeatSaturday;
    _sundayButton.tag = ClockRepeatSunday;
    _onceButton.tag = ClockRepeatOnce;
    _repeatButton.tag = -1;
    
    _buttons = @[_everyDayButton, _mondayButton, _tuesdayButton,
                 _wednesdayButton, _thursdayButton, _fridayButton,
                 _saturdayButton, _sundayButton, _onceButton,
                 _repeatButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public

- (void)updateTimePicker {
    [_timePicker reloadData];
}

#pragma mark - Setter

- (void)setTime:(NSString *)time {
    if ([_time isEqualToString:time]) {
        return;
    }
    
    _time = time;
    NSArray *strs = [time componentsSeparatedByString:@":"];
    _timePicker.hour = [strs[0] integerValue];
    _timePicker.minute = [strs[1] integerValue];
}

- (void)setRepeatDay:(ClockRepeatDay)repeatDay {
    _repeatDay = repeatDay;
    if (repeatDay == ClockRepeatOnce) {
        for (UIButton *button in _buttons) {
            if (button.tag == ClockRepeatOnce) {
                button.selected = YES;
            } else {
                button.selected = NO;
            }
        }
    } else if (repeatDay == ClockRepeatEveryday) {
        for (UIButton *button in _buttons) {
            if (button.tag == ClockRepeatOnce) {
                button.selected = NO;
            } else {
                button.selected = YES;
            }
        }
    } else {
        for (UIButton *button in _buttons) {
            if (button.tag & repeatDay || button.tag == -1){
                button.selected = YES;
            } else {
                button.selected = NO;
            }
        }
        _everyDayButton.selected = NO;
    }
}

#pragma mark - TimePickerDelegate

- (void)timerPickerDidChangeHour:(NSUInteger)hour minute:(NSUInteger)minute {
    _time = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)hour, (unsigned long)minute];
    [self.delegate didChangeTime:_time inSection:_section];
}

#pragma mark - Actions

- (IBAction)updateRepeatDay:(UIButton *)sender {
    sender.selected = !sender.selected;
    BOOL append = sender.selected;
    
    NSInteger day = sender.tag;
    if (day == -1) {
        day = ClockRepeatOnce;
        append = YES;
        
        sender.selected = NO;
    } else if (day == ClockRepeatOnce) {
        append = YES;
        sender.selected = YES;
    }
    
    [self.delegate updateRepeatDay:day append:append inSection:_section];
}

@end
