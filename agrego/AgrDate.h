//
//  RSSPubDate.h
//  Downloader
//
//  Created by Rushad on 4/2/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgrDate : NSObject

@property NSDate* date;

- (AgrDate*)initWithDate:(NSDate*)date;
- (AgrDate*)initWithRFC822String:(NSString*)string;
- (AgrDate*)initWithSQLString:(NSString*)string;

+ (AgrDate*)agrDateWithDate:(NSDate*)date;
+ (AgrDate*)agrDateWithRFC822String:(NSString*)string;
+ (AgrDate*)agrDateWithSQLString:(NSString*)string;

- (NSString*)toRFC822String;
- (NSString*)toSQLString;

@end
