//
//  NBSearchTextView.m
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-22.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import "NBMenuLabel.h"

@interface NBMenuLabel ()

@property (strong,nonatomic) UILabel *searchPrompt;
@property (strong,nonatomic) UIButton *searchButton;
@property (strong,nonatomic) UIButton *refreshButton;
@property (strong,nonatomic) UIButton *locationButton;

@end


@implementation NBMenuLabel

@synthesize searchPrompt;
@synthesize viewOrientation;
@synthesize searchButton;
@synthesize refreshButton;
@synthesize locationButton;

- (id)initWithDelegate: (NSObject <NBMenuLabelDelegate> *)delegate {
    
    if (self = [super init]){
        
        _delegate = delegate;
        
        [self setFrame:CGRectMake(0, 0, 160, 90)];
        
        searchPrompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
        [searchPrompt setFont:[UIFont fontWithName:@"OpenSans-Bold" size:30]];
        [searchPrompt setTextColor:[UIColor whiteColor]];
        [searchPrompt setTextAlignment:NSTextAlignmentCenter];
        [searchPrompt setNumberOfLines:2];
        [searchPrompt setText:@"SEARCH"];
        
        searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [searchButton setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateNormal];
        [searchButton setCenter:CGPointMake(self.frame.size.width / 2, searchPrompt.frame.size.height + searchButton.frame.size.height/2 + 10)];
        [searchButton addTarget:self action:@selector(searchPressed) forControlEvents:UIControlEventTouchUpInside];
        
        refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [refreshButton setBackgroundImage:[UIImage imageNamed:@"refreshButton"] forState:UIControlStateNormal];
        [refreshButton setCenter:CGPointMake(self.frame.size.width / 2 - 40, searchButton.center.y + 30)];
        [refreshButton addTarget:self action:@selector(refreshPressed) forControlEvents:UIControlEventTouchUpInside];
        
        locationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [locationButton setBackgroundImage:[UIImage imageNamed:@"locationButton"] forState:UIControlStateNormal];
        [locationButton setCenter:CGPointMake(self.frame.size.width / 2 + 40, searchButton.center.y + 30)];
        [locationButton addTarget:self action:@selector(locationPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:searchPrompt];
        [self addSubview:searchButton];
        [self addSubview:refreshButton];
        [self addSubview:locationButton];
        
        return self;
    }
    
    return nil;
}

#pragma mark - Button selectors
- (void)searchPressed {
    [_delegate searchButtonPressed];
}

- (void)refreshPressed {
    [_delegate refreshButtonPressed];
}

- (void)locationPressed {
    [_delegate locationButtonPressed];
}

#pragma mark - Accessors
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
