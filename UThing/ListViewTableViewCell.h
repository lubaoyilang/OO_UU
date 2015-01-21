//
//  ListViewTableViewCell.h
//  UThing
//
//  Created by Apple on 14/11/18.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UILabel *cellSubTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIView *priceBackView;
@end
