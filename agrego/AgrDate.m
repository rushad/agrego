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


- (NSString*)toRFC822String
{
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"dd MMM yyyy HH:mm:ss Z"];
  return [formatter stringFromDate:self.date];
}

- (NSString*)toSQLString
{
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
  return [formatter stringFromDate:self.date];
}

@end
