//
//  UthingMenuViewController.h
//  UThing
//
//  Created by luyuda on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MenuProtocal <NSObject>

- (void)clickMenuIndex:(int)index;

@end

@interface UthingMenuViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>




@property (nonatomic,weak) id<MenuProtocal>delegate;



@end
