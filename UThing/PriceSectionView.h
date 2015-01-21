//
//  PriceSectionView.h
//  UThing
//
//  Created by Apple on 15/1/15.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>


//价格选择区间视图
@interface PriceSectionView : UIView

//属性
@property (nonatomic) NSInteger currentMin;
@property (nonatomic) NSInteger currentMax;



//创建方法
- (instancetype)initWithFrame:(CGRect)frame maxNum:(NSInteger)max minNum:(NSInteger)min;

@end
