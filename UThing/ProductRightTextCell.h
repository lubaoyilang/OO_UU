//
//  ProductRightTextCell.h
//  UThing
//
//  Created by luyuda on 14/11/28.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>


#define rightTextW ([UIScreen mainScreen].bounds.size.width-35)
#define rightTextX 30

@interface ProductRightTextCell : UITableViewCell


- (void)loadText:(NSString*)str;
- (void)showLine:(float)h;
- (void)showIcon:(NSString*)type;

@end
