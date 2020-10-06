//
//  FriendSubsTableViewCell.m
//  Muse
//
//  Created by paycloud110 on 16/7/8.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "FriendSubSignalTableCell.h"

@interface FriendSubSignalTableCell () {
    BOOL _setuped;
}

/**  */
@property (nonatomic, weak) UIView *backView;

@property (nonatomic, weak) UILabel *dateLabel;

/**  */
@property (nonatomic, weak) UILabel *heartNumLabel;
/**  */
@property (nonatomic, weak) UILabel *heartNumUnitLabel;
/**  */






@end

@implementation FriendSubSignalTableCell

- (void)setupChildViews {
    if (_setuped) {
        return;
    }
    
    _setuped = YES;
    
    UIView *backView = [[UIView alloc] init];
    self.backView = backView;
    backView.backgroundColor = UIColorFromRGB(0xc5cccf);
    [self.contentView addSubview:backView];
    
    UIFont *font = [UIFont systemFontOfSize:13];
    UIFont *fontOne = [UIFont systemFontOfSize:8];
    UIColor *color = UIColorFromRGB(0x505050);
    UIColor *colorOne = UIColorFromRGBA(0x505050, 0.5);
    
    UILabel *dateLabel = [[UILabel alloc] init];
    self.dateLabel = dateLabel;
    dateLabel.text = @"11-29 20:09";
    dateLabel.font = font;
    dateLabel.textColor = color;
    [backView addSubview:dateLabel];

    
    UILabel *heartNumLabel = [[UILabel alloc] init];
    self.heartNumLabel = heartNumLabel;
    heartNumLabel.text = @"0";
    heartNumLabel.font = font;
    heartNumLabel.textColor = color;
    [backView addSubview:heartNumLabel];
    
    UILabel *heartNumUnitLabel = [[UILabel alloc] init];
    self.heartNumUnitLabel = heartNumUnitLabel;
    heartNumUnitLabel.text = NSLocalizedString(@"Time/Min", nil);
    heartNumUnitLabel.font = fontOne;
    heartNumUnitLabel.textColor = colorOne;
    [backView addSubview:heartNumUnitLabel];
    
    
}
- (void)setupConstant
{
   kWeakObject(self)
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(weakObject);
        
        make.left.equalTo(@(1));
       
    }];
    
    
    [self.heartNumUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(weakObject);
        
        make.right.equalTo(@(-1));
    }];
    
    [self.heartNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakObject.heartNumUnitLabel.mas_left).offset(-5);
        
        make.left.equalTo(@(1));
        
    }];
}
/** 添加数据 */
- (void)setHeartRates:(NSArray *)heartRates
           sleepTimes:(NSArray *)sleepTimes
         currentHeart:(NSString *)currentHeart
            deepSleep:(NSString *)deepSleep
           totalSleep:(NSString *)totalSleep {
    [self setupChildViews];
    
    if (![heartRates isKindOfClass:[NSArray class]]) {
        heartRates = nil;
    }
    
    if (![sleepTimes isKindOfClass:[NSArray class]]) {
        sleepTimes = nil;
    }
    
    if (currentHeart == nil || currentHeart.length == 0) {
        currentHeart = @"0";
    }
    
    if (totalSleep == nil || totalSleep.length == 0) {
        totalSleep = @"0";
    }
    
    if (deepSleep == nil || deepSleep.length == 0) {
        deepSleep = @"0";
    }
    
    self.heartNumLabel.text = currentHeart;
   
    
    //    //返回的每个记录的时间为10分钟，转化成小时
    //    self.sleepAllNumLabel.text = [NSString stringWithFormat:@"%.1f", [totalSleep floatValue]/6];
    //    self.sleepInNumLabel.text = [NSString stringWithFormat:@"%.1f", [deepSleep floatValue]/6];
    //    [self.sleepContentView setupChildView:sleepTimes];
    //    
    //    [self.sleepAllNumLabel sizeToFit];
    //    [self.sleepInNumLabel sizeToFit];
    
    [self setupConstant];
}

@end
