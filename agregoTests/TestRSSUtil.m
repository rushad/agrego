//
//  TestRSSUtil.m
//  agrego
//
//  Created by Rushad on 4/11/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSUtil.h"

#import <XCTest/XCTest.h>

@interface TestRSSUtil : XCTestCase

@end

@implementation TestRSSUtil

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNormilizeShouldRemoveLineBreaks
{
  NSString* string = @"test\r\n\test";
  NSString* res = [RSSUtil normalizeString:string];
  XCTAssertEqual([res rangeOfString:@"\n"].location, NSNotFound);
  XCTAssertEqual([res rangeOfString:@"\r"].location, NSNotFound);
}

- (void)testShouldRemoveExtraSpaces
{
  NSString* string = @"test  test";
  NSString* res = [RSSUtil normalizeString:string];
  XCTAssertEqualObjects(res, @"test test");
}

@end
