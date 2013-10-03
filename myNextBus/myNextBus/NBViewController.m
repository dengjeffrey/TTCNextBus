//
//  NBViewController.m
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-04.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import "NBViewController.h"
#import "NBDataManager.h"
#import "NBArrowView.h"
#import "NBPredictionLabel.h"
#import "NBLocationManager.h"
#import "NBSearchTextFieldOverlay.h"

@interface NBViewController ()

@property (strong,nonatomic) NBArrowView *redArrow;
@property (strong,nonatomic) NBArrowView *blueArrow;
@property (strong,nonatomic) NBSearchTextFieldOverlay *searchOverlayView;
@property (strong,nonatomic) NBPredictionLabel *predictionLabel;
@property (strong,nonatomic) NBMenuLabel *searchTextLabel;
@property (assign,nonatomic) int currentStopID;

@end

@implementation NBViewController

@synthesize redArrow;
@synthesize blueArrow;
@synthesize searchOverlayView;
@synthesize predictionLabel;
@synthesize searchTextLabel;
@synthesize currentStopID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ARROWS AND PREDICTION LABELS
    redArrow = [[NBArrowView alloc] initWithArrowColour:[UIColor colorWithRed:1 green:.364705882 blue:.231372549 alpha:1]];
    [self.view addSubview:redArrow];
    
    // Second Arrow should be right or down
    blueArrow = [[NBArrowView alloc] initWithArrowColour:[UIColor colorWithRed:.137254902 green:.48627451 blue:.909803922 alpha:1]];
    [self.view addSubview:blueArrow];
    
    predictionLabel = [[NBPredictionLabel alloc] init];
    searchTextLabel = [[NBMenuLabel alloc] initWithDelegate:self];
    
    [redArrow addSubview:predictionLabel];
    [blueArrow addSubview:searchTextLabel];

    int currentLocationStopID = [[NBDataManager sharedManager] stopIDForClosestStopAtLocation:[[NBLocationManager sharedManager] currentLocation]];
    [self updateArrowsWithStopID:currentLocationStopID];
}

#pragma mark - Data
// Updates data and arrow orientation for a new stop with stop ID, Returns true if succesfully updated
- (void)updateArrowsWithStopID:(int) stopID{
    
    // Configure data
    [predictionLabel updateWithStopPrediction:[[NBDataManager sharedManager] predictionForStopID:stopID]];
    
    // Update data
    currentStopID = stopID;
    
    // Arrow orientation
    if ([predictionLabel.directionLabel.text isEqualToString:@"SOUTH"]){
        [redArrow setViewOrientation:Down];
        [blueArrow setViewOrientation:Up];
    }else if ([predictionLabel.directionLabel.text isEqualToString:@"NORTH"]){
        [redArrow setViewOrientation:Up];
        [blueArrow setViewOrientation:Down];
    }else if ([predictionLabel.directionLabel.text isEqualToString:@"EAST"]){
        [redArrow setViewOrientation:Left];
        [blueArrow setViewOrientation:Right];
    }else if ([predictionLabel.directionLabel.text isEqualToString:@"WEST"]){
        [redArrow setViewOrientation:Right];
        [blueArrow setViewOrientation:Left];
    }else {
        NSLog(@"ERROR OCCURED, unable to find direction of stop");
        [redArrow setViewOrientation:Left];
        [blueArrow setViewOrientation:Right];
    }
    
    // Prediction label position on arrow
    if (redArrow.viewOrientation == Left || redArrow.viewOrientation == Right){
        [predictionLabel setCenter:CGPointMake(redArrow.frame.size.width/2 - 15, redArrow.frame.size.height/2)];
        [searchTextLabel setCenter:CGPointMake(blueArrow.frame.size.width/2 - 15, blueArrow.frame.size.height/2)];
    }else if (redArrow.viewOrientation == Up || redArrow.viewOrientation == Down) {
        [predictionLabel setCenter:CGPointMake(redArrow.frame.size.height/2, redArrow.frame.size.width/2)];
        [searchTextLabel setCenter:CGPointMake(blueArrow.frame.size.height/2, blueArrow.frame.size.width/2)];
    }

    [predictionLabel setViewOrientation:redArrow.viewOrientation];
    [searchTextLabel setViewOrientation:blueArrow.viewOrientation];
    
    [self enterFirstArrow:redArrow AndSecondArrow:blueArrow];
}

#pragma mark - Animations
- (void)enterFirstArrow:(NBArrowView *)firstArrow AndSecondArrow:(NBArrowView *)secondArrow{
    
    // Variables for custom animation
    int adjustForSpring = 19;
    float animationDuration = 3;
    float springDamping = 0.9;
    
    // Put arrows off of screen according to direction of firstArrow and transition them in
    switch (firstArrow.viewOrientation) {
        case 0:{ // Left
            
            [secondArrow setViewOrientation:Right];
            
            [firstArrow setFrame:CGRectMake(0 - firstArrow.frame.size.width,
                                            [[UIScreen mainScreen] bounds].size.height * 0.05,
                                            firstArrow.frame.size.width,
                                            firstArrow.frame.size.height)];
            
            [secondArrow setFrame:CGRectMake(320,
                                             [[UIScreen mainScreen] bounds].size.height * 0.95 - secondArrow.bounds.size.height,
                                             secondArrow.frame.size.width,
                                             secondArrow.frame.size.height)];
            
            // Transition in
            [UIView animateWithDuration:animationDuration
                                  delay:0
                 usingSpringWithDamping:springDamping
                  initialSpringVelocity:3
                                options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                    
                                    [firstArrow setFrame:CGRectMake(0 - adjustForSpring,
                                                                    firstArrow.frame.origin.y,
                                                                    firstArrow.frame.size.width,
                                                                    firstArrow.frame.size.height)];
                                    
                                    [secondArrow setFrame:CGRectMake((320 - secondArrow.frame.size.width) + adjustForSpring,
                                                                     secondArrow.frame.origin.y,
                                                                     secondArrow.frame.size.width,
                                                                     secondArrow.frame.size.height)];
                                    
                                } completion:^(BOOL finished) {}];
            break;
        }case 1:{ // Right
            
            [secondArrow setViewOrientation:Left];
            
            [secondArrow setFrame:CGRectMake(0 - secondArrow.frame.size.width,
                                             [[UIScreen mainScreen] bounds].size.height * 0.05,
                                             secondArrow.frame.size.width,
                                             secondArrow.frame.size.height)];
            
            [firstArrow setFrame:CGRectMake(320,
                                            [[UIScreen mainScreen] bounds].size.height * 0.95 - firstArrow.bounds.size.height,
                                            firstArrow.frame.size.width,
                                            firstArrow.frame.size.height)];
            
            // Transition in
            [UIView animateWithDuration:animationDuration
                                  delay:0
                 usingSpringWithDamping:springDamping
                  initialSpringVelocity:3
                                options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                    
                                    [secondArrow setFrame:CGRectMake(0 - adjustForSpring,
                                                                     secondArrow.frame.origin.y,
                                                                     secondArrow.frame.size.width,
                                                                     secondArrow.frame.size.height)];
                                    
                                    [firstArrow setFrame:CGRectMake(
                                                                    (320 - firstArrow.frame.size.width) + adjustForSpring,
                                                                    firstArrow.frame.origin.y,
                                                                    firstArrow.frame.size.width,
                                                                    firstArrow.frame.size.height)];
                                    
                                } completion:^(BOOL finished) {}];
            
            
            break;
        }case 2:{ // Up
            
            [secondArrow setViewOrientation:Down];
            
            [secondArrow setFrame:CGRectMake(10,
                                             0 - secondArrow.frame.size.height,
                                             secondArrow.frame.size.width,
                                             secondArrow.frame.size.height)];
            
            [firstArrow setFrame:CGRectMake(320 - firstArrow.frame.size.width - 10,
                                            [UIScreen mainScreen].bounds.size.height,
                                            firstArrow.frame.size.width,
                                            firstArrow.frame.size.height)];
            
            // Transition in
            [UIView animateWithDuration:animationDuration
                                  delay:0
                 usingSpringWithDamping:springDamping
                  initialSpringVelocity:3
                                options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                    
                                    [secondArrow setFrame:CGRectMake(secondArrow.frame.origin.x,
                                                                     0 - adjustForSpring,
                                                                     secondArrow.frame.size.width,
                                                                     secondArrow.frame.size.height)];
                                    
                                    [firstArrow setFrame:CGRectMake(firstArrow.frame.origin.x,
                                                                    [UIScreen mainScreen].bounds.size.height - firstArrow.frame.size.height + adjustForSpring,
                                                                    firstArrow.frame.size.width,
                                                                    firstArrow.frame.size.height)];
                                } completion:^(BOOL finished) {}];
            
            
            break;
        }case 3:{ // Down
            
            [secondArrow setViewOrientation:Up];
            
            [firstArrow setFrame:CGRectMake(10,
                                            0 - firstArrow.frame.size.height,
                                            firstArrow.frame.size.width,
                                            firstArrow.frame.size.height)];
            
            [secondArrow setFrame:CGRectMake(320 - secondArrow.frame.size.width - 10,
                                             [UIScreen mainScreen].bounds.size.height,
                                             secondArrow.frame.size.width,
                                             secondArrow.frame.size.height)];
            
            // Transition in
            [UIView animateWithDuration:animationDuration
                                  delay:0
                 usingSpringWithDamping:springDamping
                  initialSpringVelocity:3
                                options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                    
                                    [firstArrow setFrame:CGRectMake(firstArrow.frame.origin.x,
                                                                    0 - adjustForSpring,
                                                                    firstArrow.frame.size.width,
                                                                    firstArrow.frame.size.height)];
                                    
                                    [secondArrow setFrame:CGRectMake(secondArrow.frame.origin.x,
                                                                     [UIScreen mainScreen].bounds.size.height - secondArrow.frame.size.height + adjustForSpring,
                                                                     secondArrow.frame.size.width,
                                                                     secondArrow.frame.size.height)];
                                } completion:^(BOOL finished) {}];
            break;
        }default:
            break;
    }
}

// Transitions a pair of arrow views off the screen
- (void)exitFirstArrow:(NBArrowView *)firstArrow AndSecondArrow:(NBArrowView *)secondArrow completion:(completion) compBlock{
    
    // Animation customization:
    float animationDuration = 1;
    
    switch (redArrow.viewOrientation) {
        case 0:{ // Left
            
            [UIView animateWithDuration:animationDuration animations:^{
                
                [firstArrow setFrame:CGRectMake(0 - firstArrow.frame.size.width,
                                                [[UIScreen mainScreen] bounds].size.height * 0.05,
                                                firstArrow.frame.size.width,
                                                firstArrow.frame.size.height)];
                
                [secondArrow setFrame:CGRectMake(320,
                                                 [[UIScreen mainScreen] bounds].size.height * 0.95 - secondArrow.bounds.size.height,
                                                 secondArrow.frame.size.width,
                                                 secondArrow.frame.size.height)];
            } completion:^(BOOL finished) {
                compBlock(YES);
            }];
            break;
        }case 1:{ // Right
            
            [UIView animateWithDuration:animationDuration animations:^{
                
                [secondArrow setFrame:CGRectMake(0 - secondArrow.frame.size.width,
                                                 [[UIScreen mainScreen] bounds].size.height * 0.05,
                                                 secondArrow.frame.size.width,
                                                 secondArrow.frame.size.height)];
                
                [firstArrow setFrame:CGRectMake(320,
                                                [[UIScreen mainScreen] bounds].size.height * 0.95 - firstArrow.bounds.size.height,
                                                firstArrow.frame.size.width,
                                                firstArrow.frame.size.height)];
            } completion:^(BOOL finished) {
                compBlock(YES);
            }];
            break;
        }case 2:{ // Up
            
            [UIView animateWithDuration:animationDuration animations:^{
                
                // Put arrows off of screen
                [secondArrow setFrame:CGRectMake(10,
                                                 0 - secondArrow.frame.size.height,
                                                 secondArrow.frame.size.width,
                                                 secondArrow.frame.size.height)];
                
                [firstArrow setFrame:CGRectMake(320 - firstArrow.frame.size.width - 10,
                                                [UIScreen mainScreen].bounds.size.height,
                                                firstArrow.frame.size.width,
                                                firstArrow.frame.size.height)];
            } completion:^(BOOL finished) {
                compBlock(YES);
            }];
            break;
        }case 3:{ // Down
            [UIView animateWithDuration:animationDuration animations:^{
                
                // Put arrows off of screen
                [firstArrow setFrame:CGRectMake(10,
                                                0 - firstArrow.frame.size.height,
                                                firstArrow.frame.size.width,
                                                firstArrow.frame.size.height)];
                
                [secondArrow setFrame:CGRectMake(320 - secondArrow.frame.size.width - 10,
                                                 [UIScreen mainScreen].bounds.size.height,
                                                 secondArrow.frame.size.width,
                                                 secondArrow.frame.size.height)];
            } completion:^(BOOL finished) {
                compBlock(YES);
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - NBSearchTextLabel Delegate methods

-(void)searchButtonPressed {
    
    // Add the search overlay
    searchOverlayView = [[NBSearchTextFieldOverlay alloc] initWithDelegate:self AndAnimation:YES];
    
    [self.view addSubview:searchOverlayView];
}

- (void)refreshButtonPressed {
 
    [self exitFirstArrow:redArrow AndSecondArrow:blueArrow completion:^(BOOL finished) {
        [self updateArrowsWithStopID:currentStopID];
    }];
}

- (void)locationButtonPressed {
    
    [self exitFirstArrow:redArrow AndSecondArrow:blueArrow completion:^(BOOL finished) {
        int currentLocationStopID = [[NBDataManager sharedManager] stopIDForClosestStopAtLocation:[[NBLocationManager sharedManager] currentLocation]];
        [self updateArrowsWithStopID:currentLocationStopID];
    }];
}

#pragma mark - NBSearchTextField Delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [searchOverlayView animateExit];
    [self exitFirstArrow:redArrow AndSecondArrow:blueArrow completion:^(BOOL finished) {
        [self updateArrowsWithStopID:[textField.text intValue]];
    }];
    
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
