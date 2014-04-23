//
//  RSSHeader.m
//  Downloader
//
//  Created by Rushad on 3/28/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSHeader.h"

@implementation RSSHeader

- (RSSHeader*)initWithLink:(NSString*)link
                     title:(NSString*)title
               description:(NSString*)description
                     image:(RSSImage *)image
{
  self = [super init];
  if (self != nil)
  {
    self.link = link;
    self.title = title;
    self.description = description;
    self.image = image;
  }
  return self;
}

@end
