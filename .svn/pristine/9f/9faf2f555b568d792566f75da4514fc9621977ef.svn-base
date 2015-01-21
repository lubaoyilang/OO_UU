//
//  HotelPackagesTableViewCell.h
//  UThing
//
//  Created by Apple on 14/12/4.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@protocol HotelPackagesDelegate <NSObject>

- (void)hotelPackagesClickIndex:(NSInteger)index;

@end

@interface HotelPackagesTableViewCell : UITableViewCell

@property (nonatomic) NSInteger indexRow;
@property (nonatomic, weak) id<HotelPackagesDelegate> delegate;
@property (nonatomic, strong) ProductModel *leftModel;
@property (nonatomic, strong) ProductModel *rightModel;

//
- (void)reloadCellData;

@end
