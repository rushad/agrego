//
//  TestRSSPubDate.m
//  Downloader
//
//  Created by Rushad on 4/2/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "AgrDate.h"

#import <XCTest/XCTest.h>

@interface TestAgrDate : XCTestCase

@end

@implementation TestAgrDate

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
  AgrDate* rfcDate = [[AgrDate alloc] initWithRFC822String:string];

  NSDateFormatter* dateFormatter = [NSDateFormatter new];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
  NSDate* pattern = [dateFormatter dateFromString:@"2014-03-28 17:14:31 +0400"];
  XCTAssertEqualObjects(pattern, rfcDate.date);
}

- (void)testDateWithoutDayOfWeek
{
  NSString* string = @"28 Mar 2014 10:14:31 +0400";
  AgrDate* rfcDate = [[AgrDate alloc] initWithRFC822String:string];
  
  NSDateFormatter* dateFormatter = [NSDateFormatter new];
  [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss Z"];
  NSDate* pattern = [dateFormatter dateFromString:@"2014-03-28 10:14:31 +0400"];
  XCTAssertEqualObjects(pattern, rfcDate.date);
}

- (void)testShouldThrowOnWrongDate
{
  XCTAssertThrowsSpecificNamed([[AgrDate alloc] initWithRFC822String:@"bad data"], NSException, @"RFC822BadDate");
}

- (void)testToString
{
  NSDateFormatter* dateFormatter = [NSDateFormatter new];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
  NSDate* date = [dateFormatter dateFromString:@"2014-03-28 17:14:31 +0400"];
  AgrDate* rfcDate = [[AgrDate alloc] initWithDate:date];
  XCTAssertEqualObjects([rfcDate toRFC822String], @"28 Mar 2014 17:14:31 +0400");
}

- (void)testToSqliteString
{
  NSString* string = @"Fri, 28 Mar 2014 17:14:31 +0400";
  AgrDate* rfcDate = [[AgrDate alloc] initWithRFC822String:string];
  XCTAssertEqualObjects([rfcDate toSQLString], @"2014-03-28 17:14:31 +0400");
}

@end
