//
//  NBSearchTextField.h
//  myNextBus
//
//  Created by Jeffrey Deng on 2013-09-23.
//  Copyright (c) 2013 Jeffrey Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBSearchTextFieldOverlay : UIView

@property (strong,nonatomic) UITextField *searchTextField;

- (id)initWithDelegate:(NSObject <UITextFieldDelegate> *) delegate AndAnimation:(BOOL) animation;
- (void)animateExit;

@end
