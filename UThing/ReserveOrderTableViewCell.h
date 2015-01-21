//
//  ReserveOrderTableViewCell.h
//  UThing
//
//  Created by luyuda on 15/1/7.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol myReseOrderProtocal <NSObject>

- (void)clickPay:(NSDictionary*)dict;
- (void)clickInfo:(NSDictionary*)dict;

@end



@interface ReserveOrderTableViewCell : UITableViewCell


@property (nonatomic,weak)id<myReseOrderProtocal>delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellh;

- (void)refreshViewWithObject:(NSDictionary*)dict;

@end
