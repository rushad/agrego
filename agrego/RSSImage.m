//
//  RSSImage.m
//  Downloader
//
//  Created by Rushad on 4/2/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSImage.h"

@implementation RSSImage

- (RSSImage*)init
{
  self = [super init];
  if (self != nil)
  {
    _title = [[NSMutableString alloc] init];
    _url = [[NSMutableString alloc] init];
  }
  return self;
}

@end
