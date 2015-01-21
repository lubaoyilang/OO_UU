//
//  ProductImageTextCell.h
//  UThing
//
//  Created by luyuda on 14/11/25.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductImageTextCell : UITableViewCell




@property (assign,nonatomic)BOOL isShow;

- (id)initWithTEXTStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellh;


- (void)loadImageWithUrl:(NSString*)url;
- (void)loadText:(NSString*)str;


- (float)getCellHeight;

@end
