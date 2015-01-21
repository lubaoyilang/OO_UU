//
//  ProductRightImageCell.h
//  UThing
//
//  Created by luyuda on 14/11/28.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductRightImageCell : UITableViewCell


- (void)loadImageWithUrl:(NSString*)url;

- (void)showLine:(float)h;
- (void)showIcon:(NSString*)type;

@end
