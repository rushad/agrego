//
//  TestAgrDatabase.m
//  agrego
//
//  Created by Rushad on 4/22/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "AgrDatabase.h"
#import "AgrDate.h"
#import "RSSItem.h"

#import <sqlite3.h>

#import <XCTest/XCTest.h>

@interface TestAgrDatabase : XCTestCase

@end

@implementation TestAgrDatabase

- (void)setUp
{
  [super setUp];

  NSString* path = [AgrDatabase databasePathWithName:@"test.db"];
  NSFileManager* fm = [NSFileManager defaultManager];
  [fm removeItemAtPath:path error:nil];
}

- (void)tearDown
{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testDatabasePathWithName
{
  NSString* path1 = [AgrDatabase databasePathWithName:@"test"];
  
  NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* path2 = [[NSString alloc] initWithString:[dirs[0] stringByAppendingPathComponent:@"test"]];
  
  XCTAssertEqualObjects(path1, path2);
}

- (void)testInitShouldCreateFileInAppsDocumentsFolder
{
  NSString* path = [AgrDatabase databasePathWithName:@"test.db"];
  
  AgrDatabase* __attribute__((unused)) fdb = [[AgrDatabase alloc] initWithDatabaseName:@"test.db"];
  
  XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path]);
}

- (void)testInitShouldOpenSqliteDatabase
{
  AgrDatabase* db = [[AgrDatabase alloc] initWithDatabaseName:@"test.db"];
  XCTAssertTrue(db->dbSql != nil);
}

- (void)testInitShouldCreateTableNews
{
  AgrDatabase* __attribute__((unused)) db = [[AgrDatabase alloc] initWithDatabaseName:@"test.db"];

  sqlite3* dbSql;
  NSString* path = [AgrDatabase databasePathWithName:@"test.db"];
  sqlite3_open([path UTF8String], &dbSql);
  sqlite3_stmt* stmt;
  NSString* query = @"SELECT * FROM sqlite_master WHERE type='table' AND name='News'";
  sqlite3_prepare(dbSql, [query UTF8String], [query length] + 1, &stmt, nil);
  int r = sqlite3_step(stmt);
  sqlite3_finalize(stmt);
  XCTAssertEqual(r, SQLITE_ROW);
}

- (void)testInsertItemShouldInsertRowIntoTable
{
  AgrDatabase* db = [[AgrDatabase alloc] initWithDatabaseName:@"test.db"];
  RSSItem* item = [[RSSItem alloc] initWithLink:@"link"
                                       category:@"category"
                                          title:@"title"
                                    description:@"description"
                                        pubDate:[[[AgrDate alloc] initWithRFC822String:@"Fri, 28 Mar 2014 10:14:31 +0400"] date]
                                          image:[[RSSImage alloc] initWithTitle:@"image title" url:@"image url"]];

  [db addItem:item];

  sqlite3* dbSql;
  NSString* path = [AgrDatabase databasePathWithName:@"test.db"];
  sqlite3_open([path UTF8String], &dbSql);
  sqlite3_stmt* stmt;
  NSString* query = @"SELECT * FROM News";
  sqlite3_prepare(dbSql, [query UTF8String], [query length] + 1, &stmt, nil);
  int r = sqlite3_step(stmt);
  sqlite3_finalize(stmt);
  XCTAssertEqual(r, SQLITE_ROW);
}

- (void)testInsertItemShouldAvoidDuplication
{
  AgrDatabase* db = [[AgrDatabase alloc] initWithDatabaseName:@"test.db"];
  RSSItem* item = [[RSSItem alloc] initWithLink:@"link"
                                       category:@"category"
                                          title:@"title"
                                    description:@"description"
                                        pubDate:[[[AgrDate alloc] initWithRFC822String:@"Fri, 28 Mar 2014 10:14:31 +0400"] date]
                                          image:[[RSSImage alloc] initWithTitle:@"image title" url:@"image url"]];
  
  [db addItem:item];
  [db addItem:item];
  
  sqlite3* dbSql;
  NSString* path = [AgrDatabase databasePathWithName:@"test.db"];
  sqlite3_open([path UTF8String], &dbSql);
  sqlite3_stmt* stmt;
  NSString* query = @"SELECT * FROM News";
  sqlite3_prepare(dbSql, [query UTF8String], [query length] + 1, &stmt, nil);
  int rows = 0;
  while (sqlite3_step(stmt) == SQLITE_ROW)
    ++rows;
  sqlite3_finalize(stmt);
  XCTAssertEqual(rows, 1);
}

- (void)testInsertItemWithNilShouldNotInsertRows
{
  AgrDatabase* db = [[AgrDatabase alloc] initWithDatabaseName:@"test.db"];

  [db addItem:nil];
  
  sqlite3* dbSql;
  NSString* path = [AgrDatabase databasePathWithName:@"test.db"];
  sqlite3_open([path UTF8String], &dbSql);
  sqlite3_stmt* stmt;
  NSString* query = @"SELECT * FROM News";
  sqlite3_prepare(dbSql, [query UTF8String], [query length] + 1, &stmt, nil);
  int r = sqlite3_step(stmt);
  sqlite3_finalize(stmt);
  XCTAssertEqual(r, SQLITE_DONE);
}

@end
