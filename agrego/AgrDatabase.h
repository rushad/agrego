//
//  AgrDatabase.h
//  agrego
//
//  Created by Rushad on 4/22/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSItem.h"

#import <sqlite3.h>

#import <Foundation/Foundation.h>

@interface AgrDatabase : NSObject
{
@public
  sqlite3* dbSql;
}

+ (NSString*)databasePathWithName:(NSString*)dbName;

- (AgrDatabase*)init;
- (AgrDatabase*)initWithDatabaseName:(NSString*)dbName;

- (void)addItem:(RSSItem*)item;

@end
