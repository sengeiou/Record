//
//  DBManager+Contacts.h
//  Muse
//
//  Created by Ken.Jiang on 16/7/25.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "DBManager.h"

@class AddressPerson;
@interface DBManager (Contacts)

+ (NSString *)contactsTableName;

- (void)setupContactsTable;

- (void)addPerson:(AddressPerson *)person;
//- (void)addPersons:(NSArray<AddressPerson *> *)persons;

- (NSString *)nameForPhone:(NSString *)phone;

@end
