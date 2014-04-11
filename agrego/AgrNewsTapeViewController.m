//
//  AgrNewsTapeViewController.m
//  agrego
//
//  Created by Rushad on 4/10/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "AgrNewsCell.h"
#import "AgrNewsTapeDataSource.h"
#import "AgrNewsTapeViewController.h"

@interface AgrNewsTapeViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tvNewsTape;

@property AgrNewsTapeDataSource* myDataSource;

@end

@implementation AgrNewsTapeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self)
  {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.myDataSource = [[AgrNewsTapeDataSource alloc] initWithNewsTapeViewController:self];
  [self.tvNewsTape setDataSource:self.myDataSource];
  [self.myDataSource reloadNews];
  
}

@end
