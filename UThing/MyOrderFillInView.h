//
//  MyOrderFillInView.h
//  UThing
//
//  Created by Apple on 14/11/20.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UthingAlertView.h"

@protocol MyOrderFillInViewDelegate <NSObject>

- (void)commitTheOrderFillInInfo:(NSDictionary *)proInfo;

@end

@interface MyOrderFillInView : UIView

@property (nonatomic,strong) NSMutableDictionary *productInfo;

@property (nonatomic, strong) NSMutableDictionary *proInfo;

@property (nonatomic, assign) id<MyOrderFillInViewDelegate> m_delegate;

- (id)initWithFrame:(CGRect)frame productInfo:(NSMutableDictionary *)proInfo;

@end
