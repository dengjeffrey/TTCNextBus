//
//  NBDataManager.m
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-04.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import <FMDatabase.h>
#import "NBDataManager.h"

@interface NBDataManager()

// XML Parsers
@property (strong, nonatomic) NSXMLParser *xmlParser;

@property (strong, nonatomic) NSString *currentElement;
@property (strong, nonatomic) NSMutableString *elementValue;
@property (strong, nonatomic) NSMutableArray *busTimes;
@property (strong, nonatomic) NSMutableDictionary *parsedItems;

// Databases
@property (strong, nonatomic) FMDatabase *database;

@end


@implementation NBDataManager

static NBDataManager *sharedManager;

@synthesize xmlParser;
@synthesize currentElement;
@synthesize elementValue;
@synthesize busTimes;
@synthesize parsedItems;
@synthesize database;

#pragma mark - Static methods
+(NBDataManager *)sharedManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NBDataManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Initialization methods
- (id)init {
    
    if (self = [super init]){
        
        // Variable initializations
        busTimes = [[NSMutableArray alloc] init];
        parsedItems = [[NSMutableDictionary alloc] init];
        
        database = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"gtfs" ofType:@"db"]];
        
        // Database initialization
        if (![database open]){
            NSLog(@"database unable to open");
        }
        
        return self;
    }
    return nil;
}

#pragma mark - XML requests
- (NSDictionary *)predictionForStopID:(int) stopID {
    
    NSString *stopIDString = [NSString stringWithFormat:@"%d",stopID];
    
    // reset data
    parsedItems = [[NSMutableDictionary alloc] init];
    busTimes = [[NSMutableArray alloc] init];
    
    // UserAgentString
    NSString *agentString = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-us) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/3.2.1 Safari/525.27.1";
    
    // Prediction URL from NextBus: http://www.nextbus.com/xmlFeedDocs/NextBusXMLFeed.pdf
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=ttc&stopId=%@",
                                       stopIDString]];
    
    NSMutableURLRequest *urlReq = [NSMutableURLRequest requestWithURL:url];
    [urlReq setValue:agentString forHTTPHeaderField:@"User-Agent"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlReq returningResponse:nil error:nil];
    
    // Start parsing
    xmlParser = [[NSXMLParser alloc] initWithData:data];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    
    return parsedItems;
}

#pragma mark - Database methods
// Returns the stopID of the closest stop, if one is not found -1 is returned.
- (int) stopIDForClosestStopAtLocation:(CLLocationCoordinate2D) location{
    
    double radius = 0.001;
    FMResultSet *results = [database executeQuery:@"SELECT * FROM stops WHERE stop_lat >= ? AND stop_lat <= ? AND stop_lon >=? AND stop_lon <= ?",
                            [NSNumber numberWithDouble:location.latitude - radius], [NSNumber numberWithDouble:location.latitude + radius], [NSNumber numberWithDouble:location.longitude - radius], [NSNumber numberWithDouble:location.longitude + radius]];
    
    double shortestDistanceBetweenPoints = 1000.0;
    NSString *closestStopId;
    int tries = 0;
    
    // Decrement radius until it finds a stop or until it has tried 10 times
    while (![results next] && tries < 10) {
        tries ++;
        radius += 0.0005;
        results = [database executeQuery:@"SELECT * FROM stops WHERE stop_lat >= ? AND stop_lat <= ? AND stop_lon >=? AND stop_lon <= ?",
                   [NSNumber numberWithDouble:location.latitude - radius], [NSNumber numberWithDouble:location.latitude + radius], [NSNumber numberWithDouble:location.longitude - radius], [NSNumber numberWithDouble:location.longitude + radius]];
    }
    
    // Calculate distances between lat and lon points
    do {
        double lat = [results doubleForColumn:@"stop_lat"];
        double lon = [results doubleForColumn:@"stop_lon"];
        
        // a^2 + b^2 = c^2
        double aSquared = pow(lat - location.latitude, 2);
        double bSquared = pow(lon - location.longitude, 2);
        double distance = pow(aSquared + bSquared, 0.5);
        
        // Find shortest distance
        if (distance < shortestDistanceBetweenPoints) {
            shortestDistanceBetweenPoints = distance;
            closestStopId = [results stringForColumn:@"stop_id"];
        }
    } while ([results next]);
    
    if (closestStopId){
        return [closestStopId intValue];
    }else {
        return -1;
    }
}

#pragma mark - NSXMLParser delegate methods
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog (@"Error did occur when parsing: %@", parseError);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    currentElement = [elementName copy];
    elementValue = [[NSMutableString alloc] init];
    
    if ([elementName isEqualToString:@"prediction"]){
        // Filter data
        [busTimes addObject:[attributeDict objectForKey:@"minutes"]];
    }else if ([elementName isEqualToString:@"predictions"]){
        // Add data to result dictionary
        [parsedItems setObject:attributeDict forKey:@"info"];
    }else if ([elementName isEqualToString:@"direction"]){
        [parsedItems setObject:[attributeDict objectForKey:@"title"] forKey:@"title"];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    // Update result dictionary
    [parsedItems setObject:busTimes forKey:@"times"];
}

@end
