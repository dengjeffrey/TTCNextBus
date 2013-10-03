//
//  NBSearchTextView.h
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-22.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class NBMenuLabel;
@protocol NBMenuLabelDelegate <NSObject>
@required
- (void)searchButtonPressed;
- (void)refreshButtonPressed;
- (void)locationButtonPressed;
@optional
@end

@interface NBMenuLabel : UIView

@property (assign,nonatomic) ViewOrientation viewOrientation;
@property (strong,nonatomic) NSObject <NBMenuLabelDelegate> *delegate;

- (id)initWithDelegate: (NSObject <NBMenuLabelDelegate> *)delegate;
- (void)setViewOrientation:(ViewOrientation) orientation;

@end
