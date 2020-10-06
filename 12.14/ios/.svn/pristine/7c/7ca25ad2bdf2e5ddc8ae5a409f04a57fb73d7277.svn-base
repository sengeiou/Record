//
//  ClockSettingTableHeader.m
//  Muse
//
//  Created by Ken.Jiang on 23/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "ClockSettingTableHeader.h"
#import "UIColor+FastKit.h"

@implementation ClockSettingTableHeader

- (void)awakeFromNib {
    _clockEnabled = YES;
    _editing = NO;
}

#pragma mark - Setter

- (void)setClockEnabled:(BOOL)clockEnabled {
    _clockEnabled = clockEnabled;
    
    UIColor *textColor;
    if (clockEnabled) {
        textColor = [UIColor colorWithHex:0x282828];
    } else {
        textColor = [UIColor colorWithHex:0x282828 alpha:0.5f];
    }
    
    _timeLabel.textColor = textColor;
    _repeatDayLabel.textColor = textColor;
    _enableSwitch.on = clockEnabled;
}

- (void)setEditing:(BOOL)editing {
    if (_editing == editing) {
        return;
    }
    
    _editing = editing;
    
    _enableSwitch.hidden = editing;
    _saveButton.hidden = !editing;
}

#pragma mark - Actions

- (IBAction)expand:(id)sender {
    [self.delegate expandClockSettingAtSection:self.section];
}

- (IBAction)deleteClock:(id)sender {
    [self.delegate deleteClockAtSection:self.section];
}

- (IBAction)enableClock:(id)sender {
    [self.delegate enableClockAtSection:self.section];
}

- (IBAction)saveClock:(id)sender {
    [self setEditing:NO];
    [self.delegate saveClockAtSection:self.section];
}

@end
