//
//  RSSHeader.h
//  Downloader
//
//  Created by Rushad on 3/28/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSImage.h"

#import <Foundation/Foundation.h>

@interface RSSHeader : NSObject

@property NSString* link;
@property NSString* title;
@property NSString* description;

@property RSSImage* image;

- (RSSHeader*)initWithLink:(NSString*)link
                     title:(NSString*)title
               description:(NSString*)description
                     image:(RSSImage*)image;

@end
