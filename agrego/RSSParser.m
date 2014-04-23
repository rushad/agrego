//
//  RSSParser.m
//  Downloader
//
//  Created by Rushad on 3/28/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "AgrDate.h"
#import "RSSItem.h"
#import "RSSParser.h"
#import "RSSUtil.h"

@interface RSSParser ()

@property NSMutableArray* tagStack;

@property NSXMLParser* parser;

@property NSMutableString* headerLink;
@property NSMutableString* headerTitle;
@property NSMutableString* headerDescription;
@property NSMutableString* headerImageTitle;
@property NSMutableString* headerImageUrl;

@property NSMutableString* category;
@property NSMutableString* title;
@property NSMutableString* link;
@property NSMutableString* description;
@property NSMutableString* pubDate;
@property NSMutableString* itemImageTitle;
@property NSMutableString* itemImageUrl;

@end

@implementation RSSParser

- (RSSParser*)initWithContent:(NSString*)content delegate:(id)delegate
{
  self = [super init];
  if (self != nil)
  {
    self.delegate = delegate;
    NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
    _parser = [[NSXMLParser alloc] initWithData:data];
    [self initParser];
  }
  return self;
}

- (RSSParser*)initWithUrl:(NSString*)urlString delegate:(id)delegate
{
  self = [super init];
  if (self != nil)
  {
    self.delegate = delegate;
    NSURL* url = [NSURL URLWithString:urlString];
    _parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [self initParser];
  }
  return self;
}

- (void)parse
{
  [self.parser parse];
}

- (void)initParser
{
  self.tagStack = [[NSMutableArray alloc] init];
  self.headerLink = [[NSMutableString alloc] init];
  self.headerTitle = [[NSMutableString alloc] init];
  self.headerDescription = [[NSMutableString alloc] init];
  self.headerImageTitle = [[NSMutableString alloc] init];
  self.headerImageUrl = [[NSMutableString alloc] init];
  [self.parser setDelegate:self];
  [self.parser setShouldProcessNamespaces:NO];
  [self.parser setShouldReportNamespacePrefixes:NO];
  [self.parser setShouldResolveExternalEntities:NO];
}

- (void)initItem
{
  self.category = [[NSMutableString alloc] init];
  self.title = [[NSMutableString alloc] init];
  self.link = [[NSMutableString alloc] init];
  self.description = [[NSMutableString alloc] init];
  self.pubDate = [[NSMutableString alloc] init];
  self.itemImageTitle = [[NSMutableString alloc] init];
  self.itemImageUrl = [[NSMutableString alloc] init];
}

- (NSString*)tagAtLevelFromTop:(uint) pos
{
  if ([self.tagStack count] < (pos + 1))
    return nil;
  return [self.tagStack objectAtIndex:[self.tagStack count] - (pos + 1)];
}

- (NSString*)tagTop
{
  return [self tagAtLevelFromTop:0];
}

- (NSString*)tagParent
{
  return [self tagAtLevelFromTop:1];
}

- (NSString*)tagParentParent
{
  return [self tagAtLevelFromTop:2];
}

- (void)tagPush:(NSString*)tag
{
  [self.tagStack addObject:tag];
}

- (void)tagPop
{
  if ([self.tagStack count] > 0)
  {
    [self.tagStack removeLastObject];
  }
}

- (void)parseHeader:(NSString*)string
{
  if([self.tagTop isEqualToString:@"link"])
  {
    [self.headerLink appendString:string];
  }
  else if ([self.tagTop isEqualToString:@"title"])
  {
    [self.headerTitle appendString:string];
  }
  else if([self.tagTop isEqualToString:@"description"])
  {
    [self.headerDescription appendString:string];
  }
}

- (void)parseItem:(NSString*)string
{
  if ([self.tagTop isEqualToString:@"category"])
  {
    [self.category appendString:string];
  }
  else if ([self.tagTop isEqualToString:@"title"])
  {
    [self.title appendString:string];
  }
  else if([self.tagTop isEqualToString:@"link"])
  {
    [self.link appendString:string];
  }
  else if([self.tagTop isEqualToString:@"description"])
  {
    [self.description appendString:string];
  }
  else if ([self.tagTop isEqualToString:@"pubDate"])
  {
    [self.pubDate appendString:string];
  }
}

- (void)parseImage:(NSString*)string
{
  NSMutableString* title;
  NSMutableString* url;
  
  if ([[self tagParentParent] isEqualToString:@"channel"])
  {
    title = self.headerImageTitle;
    url = self.headerImageUrl;
  }
  else if([[self tagParentParent] isEqualToString:@"item"])
  {
    title = self.itemImageTitle;
    url = self.itemImageUrl;
  }
  else
    return;
  
  if ([self.tagTop isEqualToString:@"title"])
  {
    [title appendString:string];
  }
  else if([self.tagTop isEqualToString:@"url"])
  {
    [url appendString:string];
  }
}

- (void)parser:(NSXMLParser *)parser
  didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
  attributes:(NSDictionary *)attributeDict
{
  [self tagPush:elementName];

  if ([[self tagTop] isEqualToString:@"item"])
  {
    [self initItem];
  }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
  if ([[self tagParent] isEqualToString:@"channel"])
  {
    [self parseHeader:string];
  }
  else if ([[self tagParent] isEqualToString:@"item"])
  {
    [self parseItem:string];
  }
  else if ([[self tagParent] isEqualToString:@"image"])
  {
    [self parseImage:string];
  }
}

- (void)parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
{
  if ([[self tagTop] isEqualToString:@"item"])
  {
    if(self.delegate != nil)
    {
      RSSItem* item = [[RSSItem alloc] initWithLink:self.link
                                           category:self.category
                                              title:[RSSUtil normalizeString:self.title]
                                        description:self.description
                                            pubDate:[[[AgrDate alloc] initWithRFC822String:self.pubDate] date]
                                              image:[[RSSImage alloc] initWithTitle:self.itemImageTitle url:self.itemImageUrl]];
      [self.delegate foundItem:item];
    }
  }
  else if ([[self tagTop] isEqualToString:@"channel"])
  {
    self.header = [[RSSHeader alloc] initWithLink:self.headerLink
                                            title:self.headerTitle
                                      description:self.headerDescription
                                            image:[[RSSImage alloc] initWithTitle:self.headerImageTitle url:self.headerImageUrl]];
  }
  
  [self tagPop];
}

- (void)parser:(NSXMLParser*)parser
  parseErrorOccurred:(NSError *)parseError
{
  NSException* exception = [NSException exceptionWithName:@"RSSBadContent" reason:parseError.description userInfo:nil];
  [exception raise];
}

@end
