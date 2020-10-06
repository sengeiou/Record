//
//  ControllerHeaderView.m
//  Muse
//
//  Created by jiangqin on 16/4/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "ControllerHeaderView.h"
#import <Masonry/Masonry.h>
#import "UIColor+FastKit.h"
#import "ClockManager.h"
#import "BlueToothHelper.h"

@implementation ControllerHeaderView {
    ControllerHeaderType _currentType;
}

+ (CGFloat)headViewHeight {
    return 120;
}

+ (instancetype)controllerHeaderView {
    ControllerHeaderView *topView = [[[NSBundle mainBundle] loadNibNamed:@"ControllerHeaderView" owner:self options:nil] lastObject];
    topView.typeImageView.hidden = YES;
    topView.typeLabel.hidden = YES;
    return topView;
}

+ (instancetype)controllerHeaderViewType:(ControllerHeaderType)type {
    ControllerHeaderView *topView = [[[NSBundle mainBundle] loadNibNamed:@"ControllerHeaderView" owner:self options:nil] firstObject];
    [topView resetType:type];
    
    return topView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _currentType = -1;
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self
                   selector:@selector(updatePowerImage)
                       name:ReadBLEPowerLevelNotification
                     object:nil];
    
    [notiCenter addObserver:self
                   selector:@selector(deviceConnected)
                       name:PeripheralConnectedNotification
                     object:nil];
    
    [notiCenter addObserver:self
                   selector:@selector(deviceDisconnected)
                       name:PeripheralDisconnectedNotification
                     object:nil];
    [notiCenter addObserver:self
                   selector:@selector(deviceBeginConnected)
                       name:PeripheralBeginConnectNotification
                     object:nil];
    
    
}

#pragma mark - Private

- (UIImage *)powerImage {
    Byte powerLevel = [BlueToothHelper sharedInstance].powerLevel;
    UIImage *image = nil;
    
    if (powerLevel <= 100 && powerLevel >= 75) {
        image = [UIImage imageNamed:@"icon_title_battery_0"];
    } else if (powerLevel < 75 && powerLevel >= 50) {
        image = [UIImage imageNamed:@"icon_title_battery_1"];
    } else if (powerLevel < 50 && powerLevel >= 25) {
        image = [UIImage imageNamed:@"icon_title_battery_2"];
    } else if (powerLevel < 20 && powerLevel >= 0) {
        image = [UIImage imageNamed:@"icon_title_battery_3"];
    }
    
    return image;
}

- (void)updatePowerImage {
    _batteryImageView.image = [self powerImage];
}

- (void)cleanView:(UIView *)view {
    [view removeFromSuperview];
    view = nil;
}

- (void)rebuildCenterImageView {
    if (_centerImageView) {
        return;
    }
    
    _centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"word_title_museheart"]];
    [self addSubview:_centerImageView];
    [_centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(_lineView.mas_top).with.offset(-16);
    }];
}

- (void)cleanAccessoryViews {
    [self cleanView:_batteryImageView];
    [self cleanView:_clockImageView];
    [self cleanView:_rightButton];
}

- (void)rebuildAccessoryViews {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setImage:[UIImage imageNamed:@"btn_title_set"] forState:UIControlStateNormal];
        [self addSubview:_rightButton];
        
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backButton);
            make.trailing.equalTo(@-10);
            make.width.equalTo(@36);
            make.height.equalTo(@36);
        }];
    }
    
    if (!_batteryImageView) {
        _batteryImageView = [[UIImageView alloc] initWithImage:[self powerImage]];
        [self addSubview:_batteryImageView];
        [_batteryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_rightButton);
            make.trailing.equalTo(_rightButton.mas_leading).with.offset(-9);
        }];
    }
    
    if (!_clockImageView) {
        _clockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_title_clock"]];
        [self addSubview:_clockImageView];
        [_clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_batteryImageView);
            make.trailing.equalTo(_batteryImageView.mas_leading).with.offset(-9);
        }];
    }
}

- (void)cleanTypeViews {
    [self cleanView:_typeImageView];
    [self cleanView:_typeLabel];
    [self cleanView:_bottomTypeView];
    [self cleanView:_segmentLineView];
}

- (void)rebuildTypeViews {
    if (!_segmentLineView) {
        _segmentLineView = [[UIView alloc] init];
        [self addSubview:_segmentLineView];
        
        [_segmentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@3);
        }];
        
        UIImageView *leadingLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_title_1"]];
        [_segmentLineView addSubview:leadingLine];
        [leadingLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo(_segmentLineView.mas_width).with.multipliedBy(0.5f).offset(-30);
        }];
        
        UIImageView *trailingLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_title_1"]];
        [_segmentLineView addSubview:trailingLine];
        [trailingLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.trailing.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo(leadingLine.mas_width);
        }];
    }
    
    if (!_bottomTypeView || !_bottomTypeView.superview) {
        if (_bottomTypeView) {
            [self cleanView:_bottomTypeView];
        }
        
        _bottomTypeView = [[UIView alloc] init];
        [self addSubview:_bottomTypeView];
        
        [_bottomTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).with.offset(32);
            make.width.equalTo(@80);
            make.height.equalTo(@49);
        }];
    }
    
    if (!_typeImageView || !_typeImageView.superview) {
        if (_typeImageView) {
            [self cleanView:_typeImageView];
        }
        
        _typeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_homepage_heartrate"]];
        [_bottomTypeView addSubview:_typeImageView];
        [_typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomTypeView);
            make.top.equalTo(_bottomTypeView);
        }];
    }
    
    if (!_typeLabel || !_typeLabel.superview) {
        if (_typeLabel) {
            [self cleanView:_typeLabel];
        }
        
        _typeLabel = [[UILabel alloc] init];
        [_bottomTypeView addSubview:_typeLabel];
        _typeLabel.font = [UIFont boldSystemFontOfSize:12];
        _typeLabel.textColor = [UIColor colorWithHex:0xC6B084];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomTypeView);
            make.top.equalTo(_typeImageView.mas_bottom);
        }];
    }
}
#pragma mark --<蓝牙状态连接>
- (void)deviceConnected
{
    _noConnectionImageView.hidden = YES;
    _animatConnectionImageView.hidden = YES;
    [_animatConnectionImageView stopAnimating];
    
    if (_currentType == ControllerHeaderTypeDefault ||
        _currentType == ControllerHeaderTypeHeart ||
        _currentType == ControllerHeaderTypeWalk ||
        _currentType == ControllerHeaderTypeSleep) {
        _clockImageView.hidden = [ClockManager sharedManager].clocks.count == 0;
        _batteryImageView.hidden = NO;
    }
}

- (void)deviceDisconnected
{
//    _noConnectionImageView.hidden = NO;
    _animatConnectionImageView.hidden = YES;
    _clockImageView.hidden = YES;
    _batteryImageView.hidden = YES;
    [_animatConnectionImageView stopAnimating];
}
- (void)deviceBeginConnected
{
    if ([BlueToothHelper sharedInstance].connectedPeripheral.state == CBPeripheralStateConnected) {
        return;
    }
    
    
    _noConnectionImageView.hidden = YES;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:EnterAddressBookKey]) {
        _animatConnectionImageView.hidden = YES;
    }else {
        _animatConnectionImageView.hidden = NO;
    }
    _clockImageView.hidden = YES;
    _batteryImageView.hidden = YES;
    
    if (_animatConnectionImageView.animationImages.count == 0) {
        NSMutableArray *anima = [[NSMutableArray alloc] init];

        for (int i = 0; i < 8; i++) {
            NSString *name = [NSString stringWithFormat:@"%@_%d", NSLocalizedString(@"cartoon_homepage_bluetooth_", nil), (int)(i + 1)];
            [anima addObject:[UIImage imageNamed:name]];
        }
        _animatConnectionImageView.animationImages = anima;
        _animatConnectionImageView.animationDuration = 1;
        [_animatConnectionImageView startAnimating];
    }else {
        [_animatConnectionImageView startAnimating];
    }
}
#pragma mark - Public

- (void)resetType:(ControllerHeaderType)type {
    if (_currentType == type) {
        return;
    }
    _currentType = type;
    
    self.titleBottomCon.constant = 23;
    switch (type) {
        case ControllerHeaderTypeBluetooth:
        {
            self.titleBottomCon.constant = 13;
            _backButton.hidden = YES;
            [self cleanAccessoryViews];
            [self cleanTypeViews];
            
            _lineView.hidden = NO;
            [self rebuildCenterImageView];
            self.centerImageView.image = [UIImage imageNamed:@"icon_loading_bluetooth"];
        }
            break;
        case ControllerHeaderTypeAddress:
        {
            [self cleanAccessoryViews];
            [self cleanTypeViews];
            _lineView.hidden = YES;
            
            _backButton.hidden = NO;
            [self rebuildCenterImageView];
            self.centerImageView.image = [UIImage imageNamed:NSLocalizedString(@"word_loading_people", nil)];
        }
            break;
        case ControllerHeaderTypeHeart:
        {
            [self cleanView:_centerImageView];
            _lineView.hidden = YES;
            
            _backButton.hidden = NO;
            [self rebuildAccessoryViews];
            [self rebuildTypeViews];
            self.typeImageView.image = [UIImage imageNamed:@"icon_homepage_heartrate"];
            self.typeLabel.text = NSLocalizedString(@"Heart rate", nil);
        }
            break;
        case ControllerHeaderTypeWalk:
        {
            [self cleanView:_centerImageView];
            _lineView.hidden = YES;
            
            _backButton.hidden = NO;
            [self rebuildAccessoryViews];
            [self rebuildTypeViews];
            self.typeImageView.image = [UIImage imageNamed:@"icon_homepage_steps"];
            self.typeLabel.text = NSLocalizedString(@"行走", nil);
        }
            break;
        case ControllerHeaderTypeSleep:
        {
            [self cleanView:_centerImageView];
            _lineView.hidden = YES;
            
            _backButton.hidden = NO;
            [self rebuildAccessoryViews];
            [self rebuildTypeViews];
            self.typeImageView.image = [UIImage imageNamed:@"icon_homepage_sleep"];
            self.typeLabel.text = NSLocalizedString(@"睡眠", nil);
        }
            break;
            
        default: //ControllerHeaderTypeDefault
        {
            self.typeImageView.hidden = YES;
            self.typeLabel.hidden = YES;
            self.segmentLineView.hidden = YES;
        }
            break;
    }
    
    if ([BlueToothHelper sharedInstance].connectedPeripheral) {
        [self deviceConnected];
    } else {
        [self deviceDisconnected];
    }
}

- (void)updateView {
    BOOL hidden = ([ClockManager sharedManager].clocks.count == 0)
    || ![BlueToothHelper sharedInstance].connectedPeripheral;
    
    self.clockImageView.hidden = hidden;
}
@end
