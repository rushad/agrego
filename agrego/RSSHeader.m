//
//  RSSHeader.m
//  Downloader
//
//  Created by Rushad on 3/28/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSHeader.h"

@implementation RSSHeader

- (RSSHeader*)init
{
  self = [super init];
  if (self != nil)
  {
    self.title = [[NSMutableString alloc] init];
    self.description = [[NSMutableString alloc] init];
    self.link = [[NSMutableString alloc] init];
    self.image = [[RSSImage alloc] init];
  }
  return self;
}

@end
