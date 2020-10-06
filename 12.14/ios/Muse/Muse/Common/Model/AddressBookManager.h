//
//  AddressBookManager.h
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <UIKit/UIImage.h>

@interface AddressPerson : NSObject <NSCoding>

@property (strong, nonatomic) NSString *initial; //姓名拼音首字母
@property (strong, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *phone;
@property (strong, nonatomic) UIImage *avatar;
@property (assign, nonatomic) BOOL isMuseUser;

@end

@interface AddressBookManager : NSObject

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray<AddressPerson *> *> *addressBook;


- (void)loadPersonWithCompletion:(void (^)(NSString *err))completion;

+ (id)sharedInstance;


- (void)refreshPersonWithCompletion:(void (^)(NSString *err))completion;


@end
