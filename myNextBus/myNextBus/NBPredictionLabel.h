//
//  NBPredictionLabel.h
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-20.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface NBPredictionLabel : UIView

@property (strong,nonatomic) UILabel *directionLabel;
@property (strong,nonatomic) UILabel *stopLabel;
@property (strong,nonatomic) UILabel *timeLabel;
@property (assign,nonatomic) ViewOrientation viewOrientation;

- (void)setViewOrientation:(ViewOrientation) orientation;
- (void)updateWithStopPrediction:(NSDictionary *) prediction;

@end
