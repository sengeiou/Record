//
//  PairPopView.h
//  Muse
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressPerson;
@interface PairPopView : UIView

@property (nonatomic,copy) void (^completionBlock)(NSMutableArray<AddressPerson *> *selectedPersons);

+ (PairPopView *)viewFromNibByVc:(UIViewController *)vc peopleArr:(NSMutableArray<AddressPerson *> *)peopleArr;

- (void)dismiss;
- (void)show;

@end
