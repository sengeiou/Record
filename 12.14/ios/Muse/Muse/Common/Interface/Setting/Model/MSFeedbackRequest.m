//
//  MSFeedbackRequest.m
//  Muse
//
//  Created by Ken.Jiang on 1/8/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "MSFeedbackRequest.h"

@implementation MSFeedbackRequest

- (instancetype)initWithFeedback:(NSString *)feedback contact:(NSString *)contact {
    if (self = [super init]) {
        _feedback = feedback;
        _contact = contact;
    }
    
    return self;
}

- (NSString *)requestUrl {
    
    return @"/feedback/create";
}

- (id)requestArgument {
    
    return [self addTokenToRequestArgument:[@{@"contact":_contact, @"content":_feedback} mutableCopy]];
}

@end
