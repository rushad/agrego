//
//  RSSImage.m
//  Downloader
//
//  Created by Rushad on 4/2/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSImage.h"

@implementation RSSImage

- (RSSImage*)initWithTitle:(NSString*)title url:(NSString*)url
{
  self = [super init];
  if (self != nil)
  {
    self.title = title;
    self.url = url;
  }
  return self;
}

@end
