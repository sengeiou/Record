//
//  ControllerHeaderView.h
//  Muse
//
//  Created by jiangqin on 16/4/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ControllerHeaderType) {
    
    ControllerHeaderTypeDefault,
    ControllerHeaderTypeBluetooth,
    ControllerHeaderTypeAddress,
    ControllerHeaderTypeHeart,
    ControllerHeaderTypeWalk,
    ControllerHeaderTypeSleep,
    
    ControllerHeaderTypeCount
};

@interface ControllerHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *centerImageView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIImageView *batteryImageView;
@property (strong, nonatomic) IBOutlet UIImageView *clockImageView;
@property (weak, nonatomic) IBOutlet UIImageView *noConnectionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *animatConnectionImageView;

@property (strong, nonatomic) IBOutlet UIView *bottomTypeView;
@property (strong, nonatomic) IBOutlet UIImageView *typeImageView;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *lineView;
@property (strong, nonatomic) IBOutlet UIView *segmentLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBottomCon;

+ (CGFloat)headViewHeight;
+ (instancetype)controllerHeaderView;
+ (instancetype)controllerHeaderViewType:(ControllerHeaderType)type;

- (void)resetType:(ControllerHeaderType)type;
- (void)updateView; //show or hide clock icon

@end
