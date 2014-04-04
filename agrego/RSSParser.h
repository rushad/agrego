//
//  RSSParser.h
//  Downloader
//
//  Created by Rushad on 3/28/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSHeader.h"

#import <Foundation/Foundation.h>

@interface RSSParser : NSObject<NSXMLParserDelegate>

@property RSSHeader* header;
@property NSMutableArray* items;

- (RSSParser*)initWithContent:(NSString*)content;
- (RSSParser*)initWithUrl:(NSString*)url;

@end
