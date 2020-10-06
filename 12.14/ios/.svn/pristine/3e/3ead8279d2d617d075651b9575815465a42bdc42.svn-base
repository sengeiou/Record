//
//  SOSHandler.m
//  Muse
//
//  Created by Ken.Jiang on 16/7/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SOSHandler.h"
#import "NSFileManager+FastKit.h"

#define EmergencyContacts @"EmergencyContacts"

@implementation SOSHandler

+ (NSArray *)loadEmergencyContacts {
    return [NSFileManager loadArrayFromPath:FSDirectoryTypeDocuments withFilename:EmergencyContacts];
}

+ (void)saveEmergencyContacts:(NSArray<AddressPerson *> *)contacts {
    [NSFileManager saveArrayToPath:FSDirectoryTypeDocuments withFilename:EmergencyContacts array:contacts];
}

@end
