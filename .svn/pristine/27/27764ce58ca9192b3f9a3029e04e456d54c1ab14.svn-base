//
//  ListViewTableViewCell.m
//  UThing
//
//  Created by Apple on 14/11/18.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "ListViewTableViewCell.h"


@interface ListViewTableViewCell ()
{
    CGRect m_frame;
}

@end

@implementation ListViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        m_frame = self.bounds;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 99*250/192, 98)];
    [self.contentView addSubview:_iconView];
    
    _cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(99*250/192+5, 5, self.bounds.size.width - 99*290/192, 20)];

    _cellTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:_cellTitleLabel];

    _cellSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(99*250/192+5, 25, self.bounds.size.width - 99*250/192-5, 60)];
    _cellSubTitleLabel.numberOfLines = 2;
    _cellSubTitleLabel.font = [UIFont systemFontOfSize:14];
    _cellSubTitleLabel.alpha = 0.5;
    [self.contentView addSubview:_cellSubTitleLabel];
    
    
    _priceBackView = [[UIView alloc] init];
    
    UILabel *label = [UILabel labelWithFrame:CGRectMake(3, 6, 7, 16) text:@"￥"];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    [_priceBackView addSubview:label];
    
    _priceLabel = [UILabel labelWithFrame:CGRectMake(15, 0, 100, 22) text:nil];
    _priceLabel.font = [UIFont systemFontOfSize:18];
    [_priceLabel sizeToFit];
    _priceLabel.textColor = [UIColor whiteColor];
    [_priceBackView addSubview:_priceLabel];
    
    _unitLabel = [UILabel labelWithFrame:CGRectMake(15+_priceLabel.bounds.size.width+3, 6, 7, 16) text:@"/人起"];
    _unitLabel.font = [UIFont systemFontOfSize:12];
    [_unitLabel sizeToFit];
    _unitLabel.textColor = [UIColor whiteColor];
    [_priceBackView addSubview:_unitLabel];
    
    CGFloat w = 15+_priceLabel.bounds.size.width+3+_unitLabel.bounds.size.width;
    _priceBackView.frame = CGRectMake(self.bounds.size.width-w-2, 99-22, w, 22);
    _priceBackView.backgroundColor = [UIColor colorFromHexRGB:@"ee8f00"];
    
    [self.contentView addSubview:_priceBackView];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
