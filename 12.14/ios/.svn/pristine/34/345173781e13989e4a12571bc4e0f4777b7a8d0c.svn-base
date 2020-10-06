//
//  AddressBookManager.m
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "AddressBookManager.h"
#import "NSString+FastKit.h"
#import "DBManager+Contacts.h"
#import "MuseUser.h"

@implementation AddressPerson

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.initial = [aDecoder decodeObjectForKey:@"initial"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.isMuseUser = [aDecoder decodeBoolForKey:@"isMuseUser"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if (_initial) {
        [aCoder encodeObject:_initial forKey:@"initial"];
        [aCoder encodeObject:_name forKey:@"name"];
        [aCoder encodeObject:_phone forKey:@"phone"];
        [aCoder encodeBool:_isMuseUser forKey:@"isMuseUser"];
    }
}

@end

@implementation AddressBookManager

static AddressBookManager *manager;

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AddressBookManager alloc] init];
    });
    
    return manager;
}

- (void)loadPersonWithCompletion:(void (^)(NSString *err))completion {
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            if (completion) {
                if (error) {
                    completion(@"获取通讯录失败");
                } else {
                    CFErrorRef fecthError = NULL;
                    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &fecthError);
                    [self copyAddressBook:addressBook];
                    CFRelease(addressBook);
                    if (fecthError) {
                        completion(@"获取通讯录失败");
                    } else {
                        completion(nil);
                    }
                }
            }
            
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        CFErrorRef error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        [self copyAddressBook:addressBook];
        CFRelease(addressBook);
        
        if (completion) {
            if (error) {
                completion(@"获取通讯录失败");
            } else {
                completion(nil);
            }
        }
    } else {
        if (completion) {
            completion(@"没有获取通讯录权限");
        }
    }
    
    CFRelease(addressBookRef);
}

- (void)copyAddressBook:(ABAddressBookRef)addressBook {
    if (!_addressBook) {
        _addressBook = [NSMutableDictionary dictionary];
    } else {
        return;
    }
    

    
    DBManager *manager = [DBManager sharedManager];

    
    
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for (int i = 0; i < numberOfPeople; i++){
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        if (!firstName && !lastName) {
            continue;
        }
        
        NSString *name;
        if (lastName) {
            if (firstName) {
                name = [lastName stringByAppendingString:firstName];
            } else {
                name = lastName;
            }
        } else {
            name = firstName;
        }
        
        NSString *initial = [name initailPinyin];
        //读取照片
        NSData *image = (__bridge NSData*)ABPersonCopyImageData(person);
        UIImage *avatar = [UIImage imageWithData:image];
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++) {
            //获取該Label下的电话值
            NSString *personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);

            NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
                                           invertedSet];
            personPhone = [[personPhone componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
            
            
            if (![personPhone isEqualToString:[MuseUser currentUser].phone]) { //移除自己的号码
                AddressPerson *person = [[AddressPerson alloc] init];
                person.initial = initial;
                person.name = name;
                person.phone = personPhone;
                person.avatar = avatar;
                [manager addPerson:person];
                
                NSMutableArray *group = [_addressBook objectForKey:initial];
                if (!group) {
                    group = [NSMutableArray array];
                }
                [group addObject:person];
                
                [_addressBook setObject:group forKey:initial];
            }
        }
    }
    
}


- (void)refreshPersonWithCompletion:(void (^)(NSString *))completion {
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            if (completion) {
                if (error) {
                    completion(@"获取通讯录失败");
                } else {
                    CFErrorRef fecthError = NULL;
                    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &fecthError);
                    [self copyAddressBook:addressBook];
                    CFRelease(addressBook);
                    if (fecthError) {
                        completion(@"获取通讯录失败");
                    } else {
                        completion(nil);
                    }
                }
            }
            
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        CFErrorRef error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        
        if (error) {
            completion(nil);
            return;
        }
        
        
        [_addressBook removeAllObjects];
        
        DBManager *manager = [DBManager sharedManager];
        
        
        
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        for (int i = 0; i < numberOfPeople; i++){
            ABRecordRef person = CFArrayGetValueAtIndex(people, i);
            
            NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            if (!firstName && !lastName) {
                continue;
            }
            
            NSString *name;
            if (lastName) {
                if (firstName) {
                    name = [lastName stringByAppendingString:firstName];
                } else {
                    name = lastName;
                }
            } else {
                name = firstName;
            }
            
            NSString *initial = [name initailPinyin];
            //读取照片
            NSData *image = (__bridge NSData*)ABPersonCopyImageData(person);
            UIImage *avatar = [UIImage imageWithData:image];
            
            //读取电话多值
            ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for (int k = 0; k<ABMultiValueGetCount(phone); k++) {
                //获取該Label下的电话值
                NSString *personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
//                personPhone = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
                                               invertedSet];
                personPhone = [[personPhone componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
                
                if (![personPhone isEqualToString:[MuseUser currentUser].phone]) { //移除自己的号码
                    AddressPerson *person = [[AddressPerson alloc] init];
                    person.initial = initial;
                    person.name = name;
                    person.phone = personPhone;
                    person.avatar = avatar;
                    [manager addPerson:person];
                    
                    NSMutableArray *group = [_addressBook objectForKey:initial];
                    if (!group) {
                        group = [NSMutableArray array];
                    }
                    [group addObject:person];
                    
                    [_addressBook setObject:group forKey:initial];
                }
            }
            
            
        }
        
        if (completion) {
            completion(@"获取成功");
        }
        
        CFRelease(addressBook);
        
       
    } else {
        if (completion) {
            completion(@"获取失败");
        }
    }

    CFRelease(addressBookRef);
    
  }

@end
