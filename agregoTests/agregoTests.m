//
//  agregoTests.m
//  agregoTests
//
//  Created by Rushad on 3/13/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "agNewsTapeController.h"

//#import <OCMock/OCMock.h>

@interface agregoNewsTapeTests : XCTestCase
{
    //agNewsTapeController* _controller;
}

@property (strong, nonatomic) agNewsTapeController* controller;
@end

@implementation agregoNewsTapeTests

//@synthesize controller = _controller;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    //self.controller = [[agNewsTapeController alloc] init];
    
    // load storyboard by name
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    //"first" is a StoryboardID in controller's Identity Inspector pane
    self.controller = [storyboard instantiateViewControllerWithIdentifier:@"News"];
    
    //call loadView in main thread, it's important
    [self.controller performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    //_controller = nil;
}

- (void)testShouldBeAbleToInstantiateController
{
    XCTAssertNotNil(_controller);
}

- (void)testControllerShouldInstantiateModel
{
/*    agAgregator* model = [_controller Model];
    XCTAssertNotNil(model);*/
}

- (void) testControllerShouldDelegateView
{
/*    UITableView* view = [_controller News];
    XCTAssertNotNil(view);*/
}

@end

