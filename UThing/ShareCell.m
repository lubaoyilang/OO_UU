//
//  ShareCell.m
//  UThing
//
//  Created by luyuda on 14/11/20.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "ShareCell.h"

#define IMAGE_SIZE 35.0

@implementation ShareCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat vg = (self.contentView.frame.size.height - IMAGE_SIZE) / 2;
    
    self.imageView.frame = CGRectMake(vg, vg, IMAGE_SIZE, IMAGE_SIZE);
    self.textLabel.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + vg, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
}

@end
