//
//  RSSParserDelegate.h
//  agrego
//
//  Created by Rushad on 4/8/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSItem.h"

#import <Foundation/Foundation.h>

@protocol RSSParserDelegate <NSObject>

- (void)foundItem:(RSSItem*)item;

@end
