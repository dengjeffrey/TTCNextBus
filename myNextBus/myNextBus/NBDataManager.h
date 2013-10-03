//
//  NBDataManager.h
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-04.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"

@interface NBDataManager : NSObject <NSXMLParserDelegate>

+(NBDataManager *)sharedManager;

- (NSDictionary *)predictionForStopID:(int) stopID;
- (int) stopIDForClosestStopAtLocation:(CLLocationCoordinate2D) location;

@end
