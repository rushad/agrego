//
//  RSSPubDate.m
//  Downloader
//
//  Created by Rushad on 4/2/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "AgrDate.h"

@interface AgrDate ()

+ (NSArray*)getDateFormats;

@end

@implementation AgrDate

+ (NSArray*)getDateFormats
{
  NSArray* dateFormats = [[NSArray alloc] initWithObjects:
                          @"EEE, dd MMM yyyy HH:mm:ss Z",
                          @"dd MMM yyyy HH:mm:ss Z",
                          nil];
  return dateFormats;
}

- (AgrDate*)initWithDate:(NSDate *)date
{
  self = [super init];
  if (self != nil)
  {
    self.date = date;
  }
  return self;
}

- (AgrDate*)initWithRFC822String:(NSString *)string
{
  NSArray* dateFormats = AgrDate.getDateFormats;
  NSDate* date;

  for (int i = 0; i < [dateFormats count]; ++i)
  {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[dateFormats objectAtIndex:i]];
    date = [dateFormatter dateFromString:string];
    if (date != nil)
      return [self initWithDate:date];
  }
  NSException* exception = [[NSException alloc] initWithName:@"RFC822BadDate" reason:nil userInfo:nil];
  [exception raise];
  return nil;
}

- (AgrDate*)initWithSQLString:(NSString *)string
{
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
  NSDate* date = [dateFormatter dateFromString:string];
  return [self initWithDate:date];
}

+ (AgrDate*)agrDateWithDate:(NSDate*)date
{
  return [[AgrDate alloc] initWithDate:date];
}

+ (AgrDate*)agrDateWithRFC822String:(NSString*)string
{
  return [[AgrDate alloc] initWithRFC822String:string];
}

+ (AgrDate*)agrDateWithSQLString:(NSString *)string
{
  return [[AgrDate alloc] initWithSQLString:string];
}

- (NSString*)toRFC822String
{
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss Z"];
  return [dateFormatter stringFromDate:self.date];
}

- (NSString*)toSQLString
{
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  return [dateFormatter stringFromDate:self.date];
}

@end
