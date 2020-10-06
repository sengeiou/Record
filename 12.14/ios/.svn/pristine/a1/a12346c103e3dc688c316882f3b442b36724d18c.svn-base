//
//  ContactManager.m
//  Muse
//
//  Created by HaiQuan on 2016/11/20.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "ContactManager.h"
#import "AddressBookManager.h"

static ContactManager *manager;

@implementation ContactManager

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ContactManager alloc] init];
        [manager initData];
    });
    
    return manager;
}

- (void)initData {
    _initials = [[NSMutableArray alloc] init];
    _contacts = [[NSMutableDictionary alloc] init];
    _allContacts = [[NSMutableArray alloc] init];
}

- (void)getAllContact {
    
    [_initials removeAllObjects];
    [_contacts removeAllObjects];
    [_allContacts removeAllObjects];
    
    AddressBookManager *manager = [AddressBookManager sharedInstance];
    [manager loadPersonWithCompletion:^(NSString *err) {
        
    if (err) {

        } else {
            self.contacts = manager.addressBook;
            [self.initials setArray:[self.contacts allKeys]];

            for (NSString *initial in _initials) {
                NSArray *persons = _contacts[initial];
                
                for (AddressPerson *person in persons) {
                    [_allContacts addObject:person];
                }
       
            }
            
        }
    }];

}

- (void)getMuseContact {
    
}

@end
