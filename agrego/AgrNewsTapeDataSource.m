//
//  AgrNewsTapeDataSource.m
//  agrego
//
//  Created by Rushad on 4/10/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "AgrNewsCell.h"
#import "AgrNewsTapeDataSource.h"
#import "RSSItem.h"
#import "RSSParser.h"

@interface AgrNewsTapeDataSource()

@property (weak) AgrNewsTapeViewController* newsTape;

@property NSMutableArray* rssItems;

@end

@implementation AgrNewsTapeDataSource

- (AgrNewsTapeDataSource*)initWithNewsTapeViewController:(AgrNewsTapeViewController*)newsTape
{
  self = [super init];
  if(self != nil)
  {
    self.newsTape = newsTape;
    self.rssItems = [[NSMutableArray alloc] init];
  }
  return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.rssItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  AgrNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
  
  RSSItem* item = self.rssItems[indexPath.row];
  cell.title.text = item.title;
  cell.description.text = item.description;
  
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"dd MMM yyyy HH:mm:ss Z"];
  cell.pubDate.text = [formatter stringFromDate:item.pubDate];
  
  return cell;
}

- (void)reloadNews
{
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
  spinner.color = [UIColor blueColor];
  [spinner startAnimating];
  [self.newsTape.tableView addSubview:spinner];
  
  [self.rssItems removeAllObjects];

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    RSSParser* parser = [[RSSParser alloc] initWithUrl:@"http://echo.msk.ru/news/rss-fulltext.xml" delegate:self];
    RSSParser* parser = [[RSSParser alloc] initWithUrl:@"http://lenta.ru/rss" delegate:self];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      // stop and remove the spinner on the background when done
      [spinner removeFromSuperview];
    });
  });
}

- (void)foundItem:(RSSItem*)item
{
  [self.rssItems addObject:item];
  [self.newsTape.tableView reloadData];
}
@end
