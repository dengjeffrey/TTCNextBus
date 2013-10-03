//
//  NBArrowView.h
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-06.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface NBArrowView : UIView

@property (assign, nonatomic) ViewOrientation viewOrientation;

- (id)initWithArrowColour:(UIColor *)colour;
- (void)setViewOrientation:(ViewOrientation) orientation;


@end
