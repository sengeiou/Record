//
//  LCSOSHandler.m
//  Muse
//
//  Created by songbaoqiang on 16/8/22.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "LCSOSHandler.h"
#import "NSFileManager+FastKit.h"



@implementation LCSOSHandler
+ (NSArray *)loadEmergencyContacts {
    return [NSFileManager loadArrayFromPath:FSDirectoryTypeDocuments withFilename:EmergencyContacts];
}

+ (void)saveEmergencyContacts:(NSArray *)contacts {
    [NSFileManager saveArrayToPath:FSDirectoryTypeDocuments withFilename:EmergencyContacts array:contacts];
}

+ (NSArray *)loadSecretTalkContacts {
    return [NSFileManager loadArrayFromPath:FSDirectoryTypeDocuments withFilename:SecretTalkContacts];
}



+ (void)saveSecretTalkContacts:(NSArray *)contacts {
   BOOL b =  [NSFileManager saveArrayToPath:FSDirectoryTypeDocuments withFilename:SecretTalkContacts array:contacts];
    NSLog(@"%d", b);
}


+ (NSArray *)loadMorseContacts {
    return [NSFileManager loadArrayFromPath:FSDirectoryTypeDocuments withFilename:MorseContacts];
}

+ (void)saveMorseContacts:(NSArray *)contacts {
    BOOL b =  [NSFileManager saveArrayToPath:FSDirectoryTypeDocuments withFilename:MorseContacts array:contacts];
    NSLog(@"%d", b);
}

@end
