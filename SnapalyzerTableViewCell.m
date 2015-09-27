//
//  SnapalyzerTableViewCell.m
//  Snapalyzer
//
//  Created by Kamen Tsvetkov on 10/12/14.
//  Copyright (c) 2014 Megatronix. All rights reserved.
//

#import "SnapalyzerTableViewCell.h"

@implementation SnapalyzerTableViewCell

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.imageView.bounds = CGRectMake(20,12,57,47);
    self.imageView.frame = CGRectMake(20,12,57,47);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
