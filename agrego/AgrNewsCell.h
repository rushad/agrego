//
//  AgrNewsCell.h
//  agrego
//
//  Created by Rushad on 4/10/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgrNewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *pubDate;

@end
