//
//  TimePicker.h
//  Muse
//
//  Created by Ken.Jiang on 24/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimePickerDelegate <NSObject>

- (void)timerPickerDidChangeHour:(NSUInteger)hour minute:(NSUInteger)minute;

@end

@interface TimePicker : UIView

@property (assign, nonatomic) NSUInteger hour;
@property (assign, nonatomic) NSUInteger minute;

@property (weak, nonatomic) IBOutlet __nullable id<TimePickerDelegate> delegate;

- (void)reloadData;

@end
