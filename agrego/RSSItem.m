//
//  RSSItem.m
//  Downloader
//
//  Created by Rushad on 4/1/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSItem.h"

@implementation RSSItem

- (RSSItem*)initWithLink:(NSString*)link
                category:(NSString*)category
                   title:(NSString*)title
             description:(NSString*)description
                 pubDate:(NSDate*)pubDate
                   image:(RSSImage*)image
{
  self = [super init];
  if (self != nil)
  {
    self.link = link;
    self.category = category;
    self.title = title;
    self.description = description;
    self.pubDate = pubDate;
    self.image = image;
  }
  return self;
}

@end
