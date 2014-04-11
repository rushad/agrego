//
//  RSSParser.h
//  Downloader
//
//  Created by Rushad on 3/28/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSHeader.h"
#include "RSSParserDelegate.h"

#import <Foundation/Foundation.h>

@interface RSSParser : NSObject<NSXMLParserDelegate>

@property RSSHeader* header;
@property NSMutableArray* items;

@property (weak) id <RSSParserDelegate> delegate;

- (RSSParser*)initWithContent:(NSString*)content delegate:(id)delegate;
- (RSSParser*)initWithUrl:(NSString*)url delegate:(id)delegate;

@end
