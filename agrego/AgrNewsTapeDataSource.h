//
//  AgrNewsTapeDataSource.h
//  agrego
//
//  Created by Rushad on 4/10/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "AgrNewsTapeViewController.h"
#import "RSSParserDelegate.h"

#import <Foundation/Foundation.h>

@interface AgrNewsTapeDataSource : NSObject<UITableViewDataSource, RSSParserDelegate>

- (AgrNewsTapeDataSource*)initWithNewsTapeViewController:(AgrNewsTapeViewController*)newsTape;
- (void)reloadNews;

@end
