//
//  TimePicker.m
//  Muse
//
//  Created by Ken.Jiang on 24/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "TimePicker.h"
#import <iCarousel.h>

#import "UIColor+FastKit.h"

@interface TimePicker () <iCarouselDataSource, iCarouselDelegate> {
    iCarousel *_hourPicker;
    iCarousel *_minPicker;
    
    UIColor *_centerTextColor;
    UIColor *_sideTextColor;
}

@end

@implementation TimePicker

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    _centerTextColor = [UIColor colorWithHex:0x282828];
    _sideTextColor = [UIColor colorWithHex:0x282828 alpha:0.5f];
    
    _hourPicker = [[iCarousel alloc] init];
    [self addSubview:_hourPicker];
    [_hourPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(self.mas_width).multipliedBy(0.5f);
    }];
    _hourPicker.type = iCarouselTypeRotary;
    _hourPicker.vertical = YES;
    _hourPicker.centerItemWhenSelected = YES;
    _hourPicker.tag = 1;
    _hourPicker.dataSource = self;
    _hourPicker.delegate = self;
    
    _minPicker = [[iCarousel alloc] init];
    [self addSubview:_minPicker];
    [_minPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(self.mas_width).multipliedBy(0.5f);
    }];
    _minPicker.type = iCarouselTypeRotary;
    _minPicker.vertical = YES;
    _minPicker.centerItemWhenSelected = YES;
    _minPicker.tag = 2;
    _minPicker.dataSource = self;
    _minPicker.delegate = self;
}

#pragma mark - Public

- (void)reloadData {
    [_hourPicker reloadData];
    [_minPicker reloadData];
}

#pragma mark - Setter

- (void)setHour:(NSUInteger)hour {
    if (_hour == hour || hour > 23) {
        return;
    }
    
    _hour = hour;
    [_hourPicker setCurrentItemIndex:hour];
}

- (void)setMinute:(NSUInteger)minute {
    if (_minute == minute || minute > 59) {
        return;
    }
    
    _minute = minute;
    [_minPicker setCurrentItemIndex:minute];
}

#pragma mark - iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    if (carousel.tag == 1) {
        return 24;
    }
    
    return 60;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        label.textColor = _sideTextColor;
        label.font = [UIFont systemFontOfSize:24];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.layer.borderColor = [UIColor colorWithHex:0x282828].CGColor;
        label.layer.cornerRadius = 56/2;
    }
    
    label.text = [NSString stringWithFormat:@"%02ld", (long)index];
    
    return label;
}

#pragma mark - iCarouselDelegate

- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    UILabel *label = (UILabel *)[carousel currentItemView];
    label.layer.borderWidth = 0;
    label.textColor = _sideTextColor;
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel {
    UILabel *label = (UILabel *)[carousel currentItemView];
    label.layer.borderWidth = 0;
    label.textColor = _sideTextColor;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    UILabel *label = (UILabel *)[carousel currentItemView];
    label.layer.borderWidth = 1;
    label.textColor = _centerTextColor;
    
    if (carousel.tag == 1) {
        _hour = carousel.currentItemIndex;
    } else {
        _minute = carousel.currentItemIndex;
    }
    
    [self.delegate timerPickerDidChangeHour:_hour minute:_minute];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionVisibleItems:
            value = 3;
            break;
            
        default:
            break;
    }
    
    return value;
}

@end
