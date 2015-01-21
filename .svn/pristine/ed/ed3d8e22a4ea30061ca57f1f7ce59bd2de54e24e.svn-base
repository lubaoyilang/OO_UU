//
//  MyOrderTableViewCell.h
//  UThing
//
//  Created by luyuda on 14/11/17.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myOrderProtocal <NSObject>

- (void)clickPay:(NSDictionary*)dict;
- (void)clickInfo:(NSDictionary*)dict;

@end


@interface MyOrderTableViewCell : UITableViewCell

@property (nonatomic,weak)id<myOrderProtocal>delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellh;

- (void)refreshViewWithObject:(NSDictionary*)dict;

@end
