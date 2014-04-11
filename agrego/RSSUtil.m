//
//  RSSUtil.m
//  agrego
//
//  Created by Rushad on 4/11/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSUtil.h"

@implementation RSSUtil

+ (NSString*)normalizeString:(NSString *)string
{
  NSString* res = string;
  
  res = [res stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
  res = [res stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

  while([res rangeOfString:@"  "].location != NSNotFound)
  {
    res = [res stringByReplacingOccurrencesOfString:@"  " withString:@" "];
  }

  NSRange range;
  while((range = [res rangeOfString:@"<.*>" options:NSRegularExpressionSearch]).location != NSNotFound)
    res = [res stringByReplacingCharactersInRange:range withString:@""];

  range.location = 0;
  range.length = 1;
  if([[res substringWithRange:range] isEqualToString:@" "])
    res = [res stringByReplacingCharactersInRange:range withString:@""];
    
  return res;
}

@end
