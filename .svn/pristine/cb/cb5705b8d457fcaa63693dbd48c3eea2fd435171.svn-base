//
//  HomePageTableViewCell.h
//  Uthing
//
//  Created by Apple on 14/11/10.
//  Copyright (c) 2014年 Wushengzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "ProductModel.h"

#define ELEMENTVIEW_ASPECT_RATIO 126/145

@protocol HomePageTableViewCellDelegate <NSObject>
- (void)clickToDetailViewInCell:(NSInteger)index cellIndex:(NSInteger)cellIndex;
- (void)checkMoreInCell:(NSInteger)index;
@end

@interface HomePageTableViewCell : UITableViewCell
@property (nonatomic) NSInteger cellIndex;
@property (nonatomic, strong) HomeModel *homeModel;
@property (nonatomic, assign) id<HomePageTableViewCellDelegate> m_delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(int)index;

- (void)setDataToTheControl;

- (void)reloadCellData;
@end
