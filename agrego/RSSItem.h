//
//  RSSItem.h
//  Downloader
//
//  Created by Rushad on 4/1/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSImage.h"

#import <Foundation/Foundation.h>

@interface RSSItem : NSObject

@property NSString* link;
@property NSString* category;
@property NSString* title;
@property NSString* description;
@property NSDate* pubDate;

@property RSSImage* image;

- (RSSItem*)initWithLink:(NSString*)link
                category:(NSString*)category
                   title:(NSString*)title
             description:(NSString*)description
                 pubDate:(NSDate*)pubDate
                   image:(RSSImage*)image;
@end
