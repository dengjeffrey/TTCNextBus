//
//  NBViewController.h
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-04.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "NBMenuLabel.h"
#import "NBSearchTextFieldOverlay.h"

@interface NBViewController : UIViewController <UITextFieldDelegate, NBMenuLabelDelegate>

@property (assign,nonatomic) int currentStopID;

- (void)updateArrowsWithStopID:(int) stopID;

@end
