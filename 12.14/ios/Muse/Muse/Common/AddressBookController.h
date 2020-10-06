//
//  AddressBookController.h
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSViewController.h"

#import "AddressBookManager.h"


@interface AddressBookController : MSViewController

@property (strong, nonatomic) NSMutableArray<AddressPerson *> *persons;

/**
 *  设置选择的人的上限，默认－1即无上限
 */
@property (assign, nonatomic) NSInteger limitedCount;

/**
 *  隐藏muse用户
 */
@property (assign, nonatomic) BOOL onlySelectMuseUser;

/**
 *  返回的selectedPersons，AddressPerson的name属性一定不为空
 */
@property (nonatomic,copy) void (^completionBlock)(NSMutableArray<AddressPerson *> *selectedPersons);

// 是否只显示 Muse 用户
@property BOOL isShowMuseUser;





@end
