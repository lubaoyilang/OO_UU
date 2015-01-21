//
//  CycleScrollView.h
//  Product
//
//  Created by Apple on 14/12/25.
//  Copyright (c) 2014年 Wushengzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollView : UIView

//循环滚动视图    对于视图个数没有要求


@property (nonatomic , readonly) UIScrollView *scrollView;

/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *  @param imageUrlArray     图片url数组
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration imageUrlArray:(NSArray *)imageUrlArray;



#pragma mark -  ===================
#pragma mark -  block创建方法


/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;


/**
 数据源：获取总的page个数
 **/
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);
/**
 数据源：获取第pageIndex个位置的contentView
 **/
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);



@end
