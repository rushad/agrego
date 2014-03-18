//
//  agNewsCellController.m
//  agrego
//
//  Created by  Pavel Lasarev on 16/03/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "agNewsViewCell.h"

@implementation agNewsViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
