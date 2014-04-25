//
//  AgrDatabase.m
//  agrego
//
//  Created by Rushad on 4/22/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "AgrDatabase.h"
#import "AgrDate.h"

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
                          "pubDate TEXT,"
                          "imageTitle TEXT,"
                          "imageUrl TEXT"
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
  if (item == nil)
    return;
  
  NSString* sql = @"INSERT INTO News (link, category, title, description, pubDate, imageTitle, imageUrl) VALUES (?, ?, ?, ?, ?, ?, ?)";
  
  sqlite3_stmt* stmt;
  
  sqlite3_prepare(dbSql, [sql UTF8String], -1, &stmt,  nil);
  
  sqlite3_bind_text(stmt, 1, [item.link UTF8String], -1, SQLITE_STATIC);
  sqlite3_bind_text(stmt, 2, [item.category UTF8String], -1, SQLITE_STATIC);
  sqlite3_bind_text(stmt, 3, [item.title UTF8String], -1, SQLITE_STATIC);
  sqlite3_bind_text(stmt, 4, [item.description UTF8String], -1, SQLITE_STATIC);
  sqlite3_bind_text(stmt, 5, [[[AgrDate agrDateWithDate:item.pubDate] toSQLString] UTF8String], -1, SQLITE_STATIC);
  sqlite3_bind_text(stmt, 6, [item.image.title UTF8String], -1, SQLITE_STATIC);
  sqlite3_bind_text(stmt, 7, [item.image.url UTF8String], -1, SQLITE_STATIC);
  
  sqlite3_step(stmt);
  
  sqlite3_finalize(stmt);
}

- (RSSItem*)getItem:(int)row
{
  sqlite3_stmt* stmt;
  NSString* query = @"SELECT * FROM News LIMIT 1 OFFSET ?";
  
  sqlite3_prepare(dbSql, [query UTF8String], [query length] + 1, &stmt, nil);
  
  sqlite3_bind_int(stmt, 1, row);
  
  sqlite3_step(stmt);
  
  RSSItem* item = [RSSItem itemWithLink:[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 0)]
                               category:[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 1)]
                                  title:[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 2)]
                            description:[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 3)]
                                pubDate:[AgrDate agrDateWithSQLString:[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 4)]].date
                                  image:[RSSImage imageWithTitle:[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 5)]
                                                             url:[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 6)]]];
  
  sqlite3_finalize(stmt);
  
  return item;
}

@end
