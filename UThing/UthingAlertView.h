//
//  ILSMLAlertView.h
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSArray *selections;

typedef void (^PopViewSelectedHandle) (NSInteger selectedIndex);

@interface UthingAlertView : UIView

//传值需要显示的数组
@property (nonatomic, strong) NSArray *selections;
//block回调函数
@property (nonatomic, copy) PopViewSelectedHandle selectedHandle;
@property (nonatomic) BOOL visible;

@property (nonatomic, strong) NSString *currentString;


//创建alertView
- (instancetype)init;
//显示alertView
- (void)showFromView:(UIView*)view animated:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end

