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

@property NSMutableString* title;
@property NSMutableString* description;
@property NSMutableString* link;

@property RSSImage* image;

@end
