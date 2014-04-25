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

- (void)testAddItemShouldInsertRowIntoTable
{
  AgrDatabase* db = [[AgrDatabase alloc] initWithDatabaseName:@"test.db"];
  AgrDate* testDate = [AgrDate agrDateWithRFC822String:@"Fri, 28 Mar 2014 10:14:31 +0400"];
  RSSItem* item = [[RSSItem alloc] initWithLink:@"link"
                                       category:@"category"
                                          title:@"title"
                                    description:@"description"
                                        pubDate:testDate.date
                                          image:[[RSSImage alloc] initWithTitle:@"image title" url:@"image url"]];

  [db addItem:item];

  sqlite3* dbSql;
  NSString* path = [AgrDatabase databasePathWithName:@"test.db"];
  sqlite3_open([path UTF8String], &dbSql);
  sqlite3_stmt* stmt;
  NSString* query = @"SELECT * FROM News";
  sqlite3_prepare(dbSql, [query UTF8String], [query length] + 1, &stmt, nil);
  int r = sqlite3_step(stmt);

  NSString* link = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 0)];
  NSString* category = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 1)];
  NSString* title = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 2)];
  NSString* description = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 3)];
  AgrDate* pubDate = [AgrDate agrDateWithSQLString:[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 4)]];
  NSString* imageTitle = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 5)];
  NSString* imageUrl = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 6)];

  sqlite3_finalize(stmt);
  
  XCTAssertEqual(r, SQLITE_ROW);
  XCTAssertEqualObjects(link, @"link");
  XCTAssertEqualObjects(category, @"category");
  XCTAssertEqualObjects(title, @"title");
  XCTAssertEqualObjects(description, @"description");
  XCTAssertEqualObjects(pubDate.date, testDate.date);
  XCTAssertEqualObjects(imageTitle, @"image title");
  XCTAssertEqualObjects(imageUrl, @"image url");
}

- (void)testAddItemShouldAvoidDuplication
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

- (void)testAddItemWithNilShouldNotInsertRows
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

- (void)testGetItem
{
  AgrDatabase* db = [[AgrDatabase alloc] initWithDatabaseName:@"test.db"];
  AgrDate* testDate = [AgrDate agrDateWithRFC822String:@"Fri, 28 Mar 2014 10:14:31 +0400"];
  RSSItem* testItem = [[RSSItem alloc] initWithLink:@"link"
                                       category:@"category"
                                          title:@"title"
                                    description:@"description"
                                        pubDate:testDate.date
                                          image:[[RSSImage alloc] initWithTitle:@"image title" url:@"image url"]];
  
  [db addItem:testItem];

  RSSItem* item = [db getItem:0];
  
  XCTAssertEqualObjects(item.link, @"link");
  XCTAssertEqualObjects(item.category, @"category");
  XCTAssertEqualObjects(item.title, @"title");
  XCTAssertEqualObjects(item.description, @"description");
  XCTAssertEqualObjects(item.pubDate, testDate.date);
  XCTAssertEqualObjects(item.image.title, @"image title");
  XCTAssertEqualObjects(item.image.url, @"image url");
}

- (void)testGetItemNShouldReadItemN
{
  AgrDatabase* db = [[AgrDatabase alloc] initWithDatabaseName:@"test.db"];
  AgrDate* testDate = [AgrDate agrDateWithRFC822String:@"Fri, 28 Mar 2014 10:14:31 +0400"];
  RSSItem* testItem = [[RSSItem alloc] initWithLink:@"link0"
                                           category:@"category"
                                              title:@"title"
                                        description:@"description"
                                            pubDate:testDate.date
                                              image:[[RSSImage alloc] initWithTitle:@"image title" url:@"image url"]];
  
  [db addItem:testItem];

  testItem.link = @"link1";
  [db addItem:testItem];
  
  testItem.link = @"link2";
  [db addItem:testItem];

  RSSItem* item = [db getItem:1];
  
  XCTAssertEqualObjects(item.link, @"link1");
  XCTAssertEqualObjects(item.category, @"category");
  XCTAssertEqualObjects(item.title, @"title");
  XCTAssertEqualObjects(item.description, @"description");
  XCTAssertEqualObjects(item.pubDate, testDate.date);
  XCTAssertEqualObjects(item.image.title, @"image title");
  XCTAssertEqualObjects(item.image.url, @"image url");
}

@end
