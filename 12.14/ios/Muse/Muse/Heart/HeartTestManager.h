//
//  HeartTestManager.h
//  Muse
//
//  Created by HaiQuan on 2016/11/19.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlueToothHelper.h"
#import "NSTimer+FastKit.h"
#import "HeartRateDataManager.h"

@protocol HeartTestManagerDelegate <NSObject>

@optional

- (void)testStart;

- (void)testEnd:(NSUInteger)heartRate;

- (void)testingWithProgress:(float)progress;

@end

@interface HeartTestManager : NSObject {
    HeartRateDataManager *_dataManager;
}

@property id <HeartTestManagerDelegate>delegate;

+ (id)sharedInstance;

- (void)initManager;

@property BOOL isTestHeart;

@property BOOL isCare;

@property BOOL isBgCare;


@property double progressCount;


- (void)startTest;

- (void)startBgTest;

- (void)stopTest;

@property (weak, nonatomic) NSTimer *monitorTimer;


@end
