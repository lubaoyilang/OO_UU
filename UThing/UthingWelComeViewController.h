//
//  UthingWelComeViewController.h
//  UThing
//
//  Created by luyuda on 14/12/10.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "BaseViewController.h"

@protocol welCallBack <NSObject>

- (void)goWelBack;

@end

@interface UthingWelComeViewController : BaseViewController

@property (nonatomic,weak)id<welCallBack>delegate;

@end
