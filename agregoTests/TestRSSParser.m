//
//  TestRSSParser.m
//  Downloader
//
//  Created by Rushad on 3/28/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "RSSItem.h"
#import "RSSParser.h"
#import "RSSParserDelegate.h"

#import <XCTest/XCTest.h>

@interface TestRSSParser : XCTestCase <RSSParserDelegate>

@property NSString* contentWithImages;
@property NSString* contentWithoutImages;
@property NSString* contentBad;

@property NSMutableArray* items;

@end

@implementation TestRSSParser

- (void)setUp
{
  [super setUp];
  self.contentWithImages = @"\
<?xml version=\"1.0\" encoding=\"UTF-8\"?>\
<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\
<channel>\
<language>ru</language>\
<title>Lenta.ru : Новости</title>\
<description>Новости, статьи, фотографии, видео. Семь дней в неделю, 24 часа в сутки</description>\
<link>http://lenta.ru</link>\
<image>\
<url>http://assets.lenta.ru/small_logo.png</url>\
<title>Lenta.ru</title>\
<link>http://lenta.ru</link>\
<width>134</width>\
<height>22</height>\
</image>\
<atom:link rel=\"self\" type=\"application/rss+xml\" href=\"http://lenta.ru/rss\"/>\
<item>\
<guid>http://lenta.ru/news/2014/03/28/film/</guid>\
<title>Рогозин снимет фильм о самолетах «Сухого»</title>\
<link>http://lenta.ru/news/2014/03/28/film/</link>\
<description>\
<![CDATA[Вице-премьер России Дмитрий Рогозин намерен снять документальный фильм о самолетах Конструкторского бюро имени Сухого. Об этом куратор российского оборонно-промышленного комплекса написал в Facebook. Новый фильм будет называться «Сухой. Выбор цели». В настоящее время ведется подготовка к съемкам.]]>\
</description>\
<image>\
<url>http://assets.lenta.ru/small_logo.png</url>\
<title>Lenta.ru</title>\
<link>http://lenta.ru</link>\
<width>134</width>\
<height>22</height>\
</image>\
<pubDate>Fri, 28 Mar 2014 10:14:31 +0400</pubDate>\
<enclosure url=\"http://icdn.lenta.ru/images/2014/03/28/10/20140328101359812/pic_0de6b2cf2dbbb9af648f4bc8a6e0a336.jpg\" length=\"12531\" type=\"image/jpeg\"/>\
<category>Наука и техника</category>\
</item>\
</channel>\
</rss>\
";
  
  self.contentWithoutImages = @"\
<?xml version=\"1.0\" encoding=\"UTF-8\"?>\
<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\
<channel>\
<language>ru</language>\
<title>Lenta.ru : Новости</title>\
<description>Новости, статьи, фотографии, видео. Семь дней в неделю, 24 часа в сутки</description>\
<link>http://lenta.ru</link>\
<atom:link rel=\"self\" type=\"application/rss+xml\" href=\"http://lenta.ru/rss\"/>\
<item>\
<guid>http://lenta.ru/news/2014/03/28/film/</guid>\
<title>Рогозин снимет фильм о самолетах «Сухого»</title>\
<link>http://lenta.ru/news/2014/03/28/film/</link>\
<description>\
<![CDATA[Вице-премьер России Дмитрий Рогозин намерен снять документальный фильм о самолетах Конструкторского бюро имени Сухого. Об этом куратор российского оборонно-промышленного комплекса написал в Facebook. Новый фильм будет называться «Сухой. Выбор цели». В настоящее время ведется подготовка к съемкам.]]>\
</description>\
<pubDate>Fri, 28 Mar 2014 10:14:31 +0400</pubDate>\
<enclosure url=\"http://icdn.lenta.ru/images/2014/03/28/10/20140328101359812/pic_0de6b2cf2dbbb9af648f4bc8a6e0a336.jpg\" length=\"12531\" type=\"image/jpeg\"/>\
<category>Наука и техника</category>\
</item>\
</channel>\
</rss>\
";
  self.contentBad = @"bad content";
  self.items = [[NSMutableArray alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)foundItem:(RSSItem *)item
{
  NSLog(@"foundItem: %@", item);
  [self.items addObject:item];
}

- (void)testShouldReadHeaderFields
{
  RSSParser* parser = [[RSSParser alloc] initWithContent:self.contentWithImages delegate:self];
  [parser parse];
  RSSHeader* header = parser.header;
  NSLog(@"Title: %@", header.title);
  NSLog(@"Description: %@", header.description);
  NSLog(@"Link: %@", header.link);
  XCTAssertEqualObjects(header.title, @"Lenta.ru : Новости");
  XCTAssertEqualObjects(header.description, @"Новости, статьи, фотографии, видео. Семь дней в неделю, 24 часа в сутки");
  XCTAssertEqualObjects(header.link, @"http://lenta.ru");
}

- (void)testShouldReadItems
{
  RSSParser* parser = [[RSSParser alloc] initWithContent:self.contentWithImages delegate:self];
  [parser parse];
  XCTAssertEqual(1, [self.items count]);
  RSSItem* item = [self.items objectAtIndex:0];
  XCTAssertEqualObjects(item.category, @"Наука и техника");
  XCTAssertEqualObjects(item.title, @"Рогозин снимет фильм о самолетах «Сухого»");
  XCTAssertEqualObjects(item.link, @"http://lenta.ru/news/2014/03/28/film/");
  XCTAssertEqualObjects(item.description, @"Вице-премьер России Дмитрий Рогозин намерен снять документальный фильм о самолетах Конструкторского бюро имени Сухого. Об этом куратор российского оборонно-промышленного комплекса написал в Facebook. Новый фильм будет называться «Сухой. Выбор цели». В настоящее время ведется подготовка к съемкам.");
  NSDateFormatter* dateFormatter = [NSDateFormatter new];
  [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss Z"];
  XCTAssertEqualObjects(item.pubDate, [dateFormatter dateFromString:@"2014-03-28 10:14:31 +0400"]);
}

- (void)testShouldReadHeaderImage
{
  RSSParser* parser = [[RSSParser alloc] initWithContent:self.contentWithImages delegate:self];
  [parser parse];
  RSSHeader* header = parser.header;
  XCTAssertEqualObjects(header.image.title, @"Lenta.ru");
  XCTAssertEqualObjects(header.image.url, @"http://assets.lenta.ru/small_logo.png");
}

- (void)testShouldReadItemImage
{
  RSSParser* parser = [[RSSParser alloc] initWithContent:self.contentWithImages delegate:self];
  [parser parse];
  RSSItem* item = [self.items objectAtIndex:0];
  XCTAssertEqualObjects(item.image.title, @"Lenta.ru");
  XCTAssertEqualObjects(item.image.url, @"http://assets.lenta.ru/small_logo.png");
}

- (void)testShouldNotFailIfNoHeaderImage
{
  RSSParser* parser = [[RSSParser alloc] initWithContent:self.contentWithoutImages delegate:self];
  [parser parse];
  RSSHeader* header = parser.header;
  XCTAssertEqualObjects(header.image.title, @"");
  XCTAssertEqualObjects(header.image.url, @"");
}

- (void)testShouldNotFailIfNoItemImage
{
  RSSParser* parser = [[RSSParser alloc] initWithContent:self.contentWithoutImages delegate:self];
  [parser parse];
  RSSItem* item = [self.items objectAtIndex:0];
  XCTAssertEqualObjects(item.image.title, @"");
  XCTAssertEqualObjects(item.image.url, @"");
}

- (void)testShouldRaiseException
{
  RSSParser* parser = [[RSSParser alloc] initWithContent:self.contentBad delegate:self];
  XCTAssertThrowsSpecificNamed([parser parse], NSException, @"RSSBadContent");
}

- (void)testDelegate
{
  RSSParser* parser = [[RSSParser alloc] initWithContent:self.contentWithImages delegate:self];
  [parser parse];
  RSSItem* item = self.items[0];
  XCTAssertEqualObjects(item.title, @"Рогозин снимет фильм о самолетах «Сухого»");
}

@end
