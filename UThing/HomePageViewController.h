//
//  HomePageViewController.h
//  UThing
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "BaseViewController.h"

@protocol HomePageProtocal <NSObject>

- (void)clickHomepageIndex:(NSInteger)index;
- (void)clickTabBarIndex:(NSInteger)index;

@end

@interface HomePageViewController : BaseViewController

@property (nonatomic,weak) id <HomePageProtocal> delegate;

@end
