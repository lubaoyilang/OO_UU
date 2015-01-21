//
//  hotel_AutoImageTextTableViewCell.h
//  UThing
//
//  Created by luyuda on 14/12/25.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hotel_AutoImageTextTableViewCell : UITableViewCell



@property (nonatomic,assign)BOOL isShow;

- (id)initWithTEXTStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellh Images:(NSArray*)imgArray;


- (void)loadText:(NSString*)str;
@end
