//
//  LocationServer.h
//  Muse
//
//  Created by Ken.Jiang on 16/7/31.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

#import <CoreLocation/CoreLocation.h>

typedef void (^LocationCompletion)(BMKReverseGeoCodeResult *locationResult);
typedef void (^Location_CL_Completion)(CLPlacemark *locationResult);

//typedef void (^LocationCompletion)(BMKPoiResult *locationResult);



@interface LocationServer : NSObject

+ (instancetype)sharedServer;

- (void)locateWithCompletion:(LocationCompletion)completion;

- (void)locate_CL_WithCompletion:(Location_CL_Completion)completion;





@end
