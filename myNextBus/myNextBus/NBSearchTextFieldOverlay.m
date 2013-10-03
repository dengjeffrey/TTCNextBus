//
//  NBSearchTextField.m
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-23.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import "NBSearchTextFieldOverlay.h"

@interface NBSearchTextFieldOverlay ()

@property (strong,nonatomic) UITextField *searchTextField;
@property (strong,nonatomic) UIView *blackOverlay;
@property (strong,nonatomic) UIButton *searchButton;

@end

@implementation NBSearchTextFieldOverlay

@synthesize searchTextField;
@synthesize blackOverlay;
@synthesize searchButton;

- (id)initWithDelegate:(NSObject <UITextFieldDelegate> *) delegate AndAnimation:(BOOL) animation {
    
    if(self = [super init]){
        
        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self setUserInteractionEnabled:YES];
        
        // Search Text Field
        searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
        [searchTextField setDelegate:delegate];
        [searchTextField setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height * 0.25)];
        [searchTextField setClearButtonMode:UITextFieldViewModeAlways];
        [searchTextField setHidden:animation];
        
        [searchTextField setPlaceholder:@"Stop ID"];
        [searchTextField setFont:[UIFont fontWithName:@"PTSans-Narrow" size:20]];
        [searchTextField setTextColor:[UIColor blackColor]];
        [searchTextField setBackgroundColor:[UIColor whiteColor]];
        [searchTextField setTextAlignment:NSTextAlignmentCenter];
        [searchTextField setKeyboardType:UIKeyboardTypeNumberPad];
        
        // Search button on keyboard
        searchButton = [[UIButton alloc] initWithFrame:CGRectMake(searchTextField.frame.origin.x + searchTextField.frame.size.width + 10,
                                                                  searchTextField.frame.origin.y, 35, 35)];
        [searchButton setCenter:CGPointMake(searchButton.center.x, searchTextField.center.y)];
        [searchButton setImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateNormal];
        [searchButton setHidden:YES];
        [searchButton addTarget:self action:@selector(searchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        // Black overlay dimmer
        blackOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [blackOverlay setBackgroundColor:[UIColor blackColor]];
        [blackOverlay setAlpha:0.8];
        
        [self addSubview:blackOverlay];
        [self addSubview:searchButton];
        [self addSubview:searchTextField];
        
        if (animation){
            [self animateEntrance];
        }
        
        return self;
    }
    
    return nil;
}

#pragma mark - Animations
- (void)animateEntrance {
    
    // Unhide search bar and buttons
    [searchTextField setCenter:CGPointMake(searchTextField.center.x, 0 - searchTextField.frame.size.height)];
    [searchButton setCenter:CGPointMake(searchButton.center.x, 0 - searchButton.frame.size.height)];
    [searchTextField setHidden:NO];
    [searchButton setHidden:NO];
    [searchTextField becomeFirstResponder];

    // Drop in search bar and search button
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:3 options:UIViewAnimationOptionTransitionNone animations:^{
        [searchTextField setCenter:CGPointMake(searchTextField.center.x, [UIScreen mainScreen].bounds.size.height * 0.25)];
        [searchButton setCenter:CGPointMake(searchButton.center.x, [UIScreen mainScreen].bounds.size.height * 0.25)];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}

- (void)animateExit {
    
    [searchTextField resignFirstResponder];

    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:3 options:UIViewAnimationOptionTransitionNone animations:^{
        [searchTextField setCenter:CGPointMake(searchTextField.center.x, 0 - searchTextField.frame.size.height)];
        [searchButton setCenter:CGPointMake(searchButton.center.x, 0 - searchButton.frame.size.height)];
        [blackOverlay setAlpha:0];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [self removeFromSuperview];
    }];
}

#pragma mark - Buttons

- (void)searchButtonPressed {
    
    [[searchTextField delegate] textFieldShouldReturn:searchTextField];
}


@end
