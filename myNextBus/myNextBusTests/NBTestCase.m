//
//  NBTestCase.m
//  myNextBus
//
//  Created by Jeffrey Deng on 2014-03-10.
//  Copyright (c) 2014 Jeffrey Deng. All rights reserved.
//

#import "NBTestCase.h"
#import "NBViewController.h"
#import "NBSearchTextFieldOverlay.h"

@interface NBTestCase()

@property (nonatomic)  NBViewController *testVC;

@end


@implementation NBTestCase

@synthesize testVC;

- (void)setUp
{
    [super setUp];
    
    testVC = [[NBViewController alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSearch1
{
    
    [testVC searchButtonPressed];
    
    NBSearchTextFieldOverlay *textOverlay = [[NBSearchTextFieldOverlay alloc] initWithDelegate:testVC AndAnimation:YES];
    textOverlay.searchTextField.text = @"41";
    
    [testVC updateArrowsWithStopID:textOverlay.searchTextField.text.intValue];
    
    XCTAssertEqual(testVC.currentStopID, 41, @"Not a match");
}

- (void)testSearch2
{
    
    NBSearchTextFieldOverlay *textOverlay = [[NBSearchTextFieldOverlay alloc] initWithDelegate:testVC AndAnimation:YES];
    textOverlay.searchTextField.text = @"0";
    
    [testVC updateArrowsWithStopID:textOverlay.searchTextField.text.intValue];
    
    XCTAssertEqual(testVC.currentStopID, 0, @"Not a match");
}



@end
