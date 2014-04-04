//
//  TestRSSPubDate.m
//  Downloader
//
//  Created by Rushad on 4/2/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RFC822Date.h"

#import <XCTest/XCTest.h>

@interface TestRFC822Date : XCTestCase

@end

@implementation TestRFC822Date

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

- (void)testDateWithDayOfWeek
{
  NSString* string = @"Fri, 28 Mar 2014 17:14:31 +0400";
  RFC822Date* date = [[RFC822Date alloc] initWithString:string];

  NSDateFormatter* dateFormatter = [NSDateFormatter new];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
  NSDate* pattern = [dateFormatter dateFromString:@"2014-03-28 17:14:31 +0400"];
  XCTAssertEqualObjects(pattern, date.date);
}

- (void)testDateWithoutDayOfWeek
{
  NSString* string = @"28 Mar 2014 10:14:31 +0400";
  RFC822Date* date = [[RFC822Date alloc] initWithString:string];
  
  NSDateFormatter* dateFormatter = [NSDateFormatter new];
  [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss Z"];
  NSDate* pattern = [dateFormatter dateFromString:@"2014-03-28 10:14:31 +0400"];
  XCTAssertEqualObjects(pattern, date.date);
}

- (void)testShouldThrowOnWrongDate
{
  XCTAssertThrowsSpecificNamed([[RFC822Date alloc] initWithString:@"bad data"], NSException, @"RFC822BadDate");
}

@end
