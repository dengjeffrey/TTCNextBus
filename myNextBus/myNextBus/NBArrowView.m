//
//  NBArrowView.m
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-06.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import "NBArrowView.h"
#import "NBLocationManager.h"
#import "NBDataManager.h"

@interface NBArrowView()

@property (strong, nonatomic) UIColor *arrowColour;
@property (assign, nonatomic) CGPathRef arrowPath;

@end


@implementation NBArrowView

@synthesize arrowColour;
@synthesize arrowPath;
@synthesize viewOrientation;

- (id)initWithArrowColour:(UIColor *)colour {
    self = [super initWithFrame:CGRectMake(0, 0, 254, 204)];
    if (self){
        
        arrowColour = colour;
        [self setBackgroundColor:[UIColor clearColor]];
        
        return self;
    }
    return nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Configurations
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, [arrowColour CGColor]);
    
    // Path
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 18)];
    [bezierPath addLineToPoint:CGPointMake(172, 18)];
    [bezierPath addLineToPoint:CGPointMake(172, 0)];
    [bezierPath addLineToPoint:CGPointMake(254, 102)];
    [bezierPath addLineToPoint:CGPointMake(172, 204)];
    [bezierPath addLineToPoint:CGPointMake(172, 186)];
    [bezierPath addLineToPoint:CGPointMake(0, 186)];
    [bezierPath addLineToPoint:CGPointMake(0, 18)];
    
    arrowPath = [bezierPath CGPath];
    CGContextAddPath(context, [bezierPath CGPath]);
    
    // Fill path
    CGContextFillPath(context);
}

- (void)setViewOrientation:(ViewOrientation) orientation {
    
    // Reset rotations
    [self setTransform:CGAffineTransformIdentity];
    
    switch (orientation) {
        case 1: // Right
            [self setTransform:CGAffineTransformMakeRotation(M_PI)];
            break;
        case 2: // Up
            [self setTransform:CGAffineTransformMakeRotation(M_PI + M_PI_2)];
            break;
        case 3: // Down
            [self setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            break;
        default: // Left
            break;
    }
    
    viewOrientation = orientation;
}

@end
