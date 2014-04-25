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
  NSString* string = @"Fri, 28 Mar 2014 17:14:31 +0700";
  AgrDate* rfcDate = [[AgrDate alloc] initWithRFC822String:string];

  NSDateFormatter* dateFormatter = [NSDateFormatter new];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
  NSDate* pattern = [dateFormatter dateFromString:@"2014-03-28 17:14:31 +0700"];
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
  AgrDate* rfcDate = [[AgrDate alloc] initWithDate:[NSDate date]];
  NSDateFormatter* rfcDateFormatter = [NSDateFormatter new];
  [rfcDateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss Z"];
  XCTAssertEqualObjects([rfcDate toRFC822String], [rfcDateFormatter stringFromDate:rfcDate.date]);
}

- (void)testToSqliteString
{
  NSString* string = @"Fri, 28 Mar 2014 17:14:31 +0400";
  AgrDate* rfcDate = [[AgrDate alloc] initWithRFC822String:string];
  XCTAssertEqualObjects([rfcDate toSQLString], @"2014-03-28 13:14:31");
}

- (void)testAgrDateWithDate
{
  NSString* string = @"Fri, 28 Mar 2014 17:14:31 +0700";
  AgrDate* date = [[AgrDate alloc] initWithRFC822String:string];
  
  AgrDate* agrDate = [AgrDate agrDateWithDate:date.date];
  XCTAssertEqualObjects(date.date, agrDate.date);
}

- (void)testAgrDateWithRFC822String
{
  AgrDate* date = [AgrDate agrDateWithRFC822String:@"Fri, 28 Mar 2014 17:14:31 +0700"];
  XCTAssertEqualObjects([date toSQLString], @"2014-03-28 10:14:31");
}

- (void)testAgrDateWithSQLString
{
  AgrDate* date = [AgrDate agrDateWithSQLString:@"2014-03-28 10:14:31"];
  XCTAssertEqualObjects([date toSQLString], @"2014-03-28 10:14:31");
}

@end
