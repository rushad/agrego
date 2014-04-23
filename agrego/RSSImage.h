//
//  RSSImage.h
//  Downloader
//
//  Created by Rushad on 4/2/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSImage : NSObject

@property NSString* title;
@property NSString* url;

- (RSSImage*)initWithTitle:(NSString*)title url:(NSString*)url;

@end
