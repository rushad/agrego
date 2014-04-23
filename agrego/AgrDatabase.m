//
//  AgrDatabase.m
//  agrego
//
//  Created by Rushad on 4/22/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "AgrDatabase.h"

@interface AgrDatabase()

@end

@implementation AgrDatabase

static NSString* const DB_FILE_NAME = @"agrego.db";

+ (NSString*)databasePathWithName:(NSString*)dbName
{
  NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  return [[NSString alloc] initWithString:[dirs[0] stringByAppendingPathComponent:dbName]];
}

- (AgrDatabase*)initWithDatabaseName:(NSString*)dbName
{
  self = [super init];
  if (self != nil)
  {

    if (sqlite3_open([[AgrDatabase databasePathWithName:dbName] UTF8String], &dbSql) != SQLITE_OK)
      return nil;

    sqlite3_exec(dbSql, "CREATE TABLE IF NOT EXISTS News ("
                          "link TEXT PRIMARY KEY,"
                          "category TEXT,"
                          "title TEXT,"
                          "description TEXT,"
                          "pubDate DATETIME,"
                          "image TEXT"
                        ")",
                 nil, nil, nil);
  }
  return self;
}

- (AgrDatabase*)init
{
  return [self initWithDatabaseName:DB_FILE_NAME];
}

- (void)addItem:(RSSItem*)item
{
  if (item != nil)
  {
    sqlite3_stmt* stmt;
    sqlite3_prepare(dbSql, "INSERT INTO News (link) VALUES (?)", -1, &stmt,  nil);
    sqlite3_bind_text(stmt, 1, [item.link UTF8String], -1, SQLITE_STATIC);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
  }
}

@end
