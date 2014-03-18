//
//  NBPredictionLabel.m
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-20.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import "NBPredictionLabel.h"

@interface NBPredictionLabel()

@end


@implementation NBPredictionLabel

@synthesize directionLabel;
@synthesize stopLabel;
@synthesize timeLabel;
@synthesize viewOrientation;

- (id)init {
    
    if (self = [super init]){
        
        [self setFrame:CGRectMake(0, 0, 160, 110)];
        
        // Label Initializations
        directionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        [directionLabel setTextColor:[UIColor whiteColor]];
        [directionLabel setTextAlignment:NSTextAlignmentCenter];
        [directionLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:30]];
        
        UIView *stopLabelContainer = [[UIView alloc] initWithFrame:CGRectMake(0, directionLabel.frame.size.height, self.frame.size.width,30)];
        stopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
        [stopLabel setCenter:CGPointMake(directionLabel.frame.size.width/2, stopLabel.center.y)];
        [stopLabel setTextColor:[UIColor whiteColor]];
        [stopLabel setTextAlignment:NSTextAlignmentCenter];
        [stopLabel setFont:[UIFont fontWithName:@"PTSans-Narrow" size:20]];
        [stopLabelContainer addSubview:stopLabel];
        [stopLabel setCenter:CGPointMake(stopLabelContainer.frame.size.width/2, stopLabelContainer.frame.size.height/2)];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, directionLabel.frame.size.height + stopLabel.frame.size.height + 10, self.frame.size.width, 40)];
        [timeLabel setTextColor:[UIColor whiteColor]];
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        [timeLabel setFont:[UIFont fontWithName:@"PTSans-Narrow" size:15]];
        [timeLabel setNumberOfLines:2];
        
        [self addSubview:directionLabel];
        [self addSubview:stopLabelContainer];
        [self addSubview:timeLabel];
        
        return self;
    }
    
    return nil;
}

- (void)updateWithStopPrediction:(NSDictionary *) prediction{
    
    
    NSString *direction = [prediction objectForKey:@"title"];
    NSArray *times= [prediction objectForKey:@"times"];
    
    // If stop has no predictions direction title is different, as well as time
    if (!direction){
        
        direction = [[[prediction objectForKey:@"info"] objectForKey:@"dirTitleBecauseNoPredictions"] capitalizedString];
        [timeLabel setText:@"No times"];
        
        // If direction still doesn't exist then there are no stops for the stop ID
        if (!direction) {
            direction = @"SORRY";
        }
    }else {
        
        // Customize label for stop times
        NSString *timeAsString = @"";
        for (int i = 0; i < [times count] && i < 2; i ++){
            timeAsString = [NSString stringWithFormat:@"%@%d minutes",timeAsString,[[times objectAtIndex:i] intValue]];
            
            if(i != 1){
                timeAsString = [NSString stringWithFormat:@"%@\n",timeAsString];
            }
        }
        [timeLabel setText:timeAsString];
    }
    
    // Format the direction
    direction = [[direction substringToIndex:5] stringByReplacingOccurrencesOfString:@" " withString:@""];
    direction = [direction uppercaseString];
    
    [directionLabel setText:direction];
    [stopLabel setText: [[prediction objectForKey:@"info"] objectForKey:@"routeTitle"]];
}

- (void)setViewOrientation:(ViewOrientation) orientation{
    
    // Reset rotations
    [self setTransform:CGAffineTransformIdentity];
    
    switch (orientation) {
        case 1: // Right
            [self setTransform:CGAffineTransformMakeRotation(M_PI)];
            break;
        case 2: // Up
            [self setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            break;
        case 3: // Down
            [self setTransform:CGAffineTransformMakeRotation(M_PI + M_PI_2)];
            break;
        default: // Left
            break;
    }
    
    viewOrientation = orientation;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
