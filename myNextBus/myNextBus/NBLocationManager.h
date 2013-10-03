//
//  NBLocationManager.h
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-20.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NBLocationManager : NSObject <CLLocationManagerDelegate>

+ (NBLocationManager *)sharedManager;

- (CLLocationCoordinate2D )currentLocation;

@end
