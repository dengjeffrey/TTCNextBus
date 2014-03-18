//
//  NBLocationManager.m
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-20.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import "NBLocationManager.h"

@interface NBLocationManager()

@property (strong,nonatomic) NSArray *currentLocations;
@property (strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation NBLocationManager 

@synthesize currentLocations;
@synthesize locationManager;

static NBLocationManager *sharedManager;

#pragma mark - Shared manager
+ (NBLocationManager *)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NBLocationManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Initialization methods
- (id)init {
    
    if (self = [super init]){
        
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager startUpdatingLocation];
        
        return self;
    }
    
    return nil;
}

#pragma mark - Fetching location data
- (CLLocationCoordinate2D )currentLocation{
    
    // Retrieve last location recorded
    CLLocation *location =  [locationManager location];;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    return coordinate;
}

#pragma mark - CLLocation delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocations = locations;
}

@end
