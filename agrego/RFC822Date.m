//
//  RSSPubDate.m
//  Downloader
//
//  Created by Rushad on 4/2/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RFC822Date.h"

@interface RFC822Date ()

+ (NSArray*)getDateFormats;

@end

@implementation RFC822Date

+ (NSArray*)getDateFormats
{
  NSArray* dateFormats = [[NSArray alloc] initWithObjects:
                          @"EEE, dd MMM yyyy HH:mm:ss Z",
                          @"dd MMM yyyy HH:mm:ss Z",
                          nil];
  return dateFormats;
}

- (RFC822Date*)initWithString:(NSString *)string
{
  self = [super init];
  if (self != nil)
  {
    NSArray* dateFormats = RFC822Date.getDateFormats;
    
    for (int i = 0; i < [dateFormats count]; ++i)
    {
      NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:[dateFormats objectAtIndex:i]];
      self.date = [dateFormatter dateFromString:string];
      if (self.date != nil)
        return self;
    }
    
    NSException* exception = [[NSException alloc] initWithName:@"RFC822BadDate" reason:nil userInfo:nil];
    [exception raise];
  }
  return self;
}

@end
