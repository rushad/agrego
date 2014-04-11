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
    _title = [[NSMutableString alloc] init];
    _description = [[NSMutableString alloc] init];
    _link = [[NSMutableString alloc] init];
    _image = [[RSSImage alloc] init];
  }
  return self;
}

@end
