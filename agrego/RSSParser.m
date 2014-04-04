//
//  RSSParser.m
//  Downloader
//
//  Created by Rushad on 3/28/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RFC822Date.h"
#import "RSSItem.h"
#import "RSSParser.h"

@interface RSSParser ()

@property NSMutableArray* tagStack;

@property NSXMLParser* parser;

@property NSMutableString* category;
@property NSMutableString* title;
@property NSMutableString* link;
@property NSMutableString* description;
@property NSMutableString* pubDate;

@property RSSImage* image;

@end

@implementation RSSParser

- (RSSParser*)initWithContent:(NSString*)content
{
  self = [super init];
  if (self != nil)
  {
    NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
    self.parser = [[NSXMLParser alloc] initWithData:data];
    [self initParser];
    [self.parser parse];
  }
  return self;
}

- (RSSParser*)initWithUrl:(NSString*)urlString
{
  self = [super init];
  if (self != nil)
  {
    NSURL* url = [NSURL URLWithString:urlString];
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [self initParser];
    [self.parser parse];
  }
  return self;
}

- (void)initParser
{
  self.tagStack = [[NSMutableArray alloc] init];
  self.header = [[RSSHeader alloc] init];
  self.items = [[NSMutableArray alloc] init];
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
  self.image = [[RSSImage alloc] init];
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
  if ([self.tagTop isEqualToString:@"title"])
  {
    [self.header.title appendString:string];
  }
  else if([self.tagTop isEqualToString:@"description"])
  {
    [self.header.description appendString:string];
  }
  else if([self.tagTop isEqualToString:@"link"])
  {
    [self.header.link appendString:string];
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
  RSSImage* image;
  
  if ([[self tagParentParent] isEqualToString:@"channel"])
    image = self.header.image;
  else if([[self tagParentParent] isEqualToString:@"item"])
    image = self.image;
  else
    return;
  
  if ([self.tagTop isEqualToString:@"title"])
  {
    [image.title appendString:string];
  }
  else if([self.tagTop isEqualToString:@"url"])
  {
    [image.url appendString:string];
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
    RSSItem* item = [[RSSItem alloc] init];
    
    item.category = self.category;
    item.title = self.title;
    item.link = self.link;
    item.description = self.description;
    item.image = self.image;
    
    RFC822Date* date = [[RFC822Date alloc] initWithString:self.pubDate];
    item.pubDate = date.date;
    
    [self.items addObject:item];
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
