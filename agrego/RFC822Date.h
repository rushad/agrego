//
//  RSSPubDate.h
//  Downloader
//
//  Created by Rushad on 4/2/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFC822Date : NSObject

@property NSDate* date;

- (RFC822Date*)initWithString:(NSString*)string;

@end
