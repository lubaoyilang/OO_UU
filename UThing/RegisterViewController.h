//
//  RegisterViewController.h
//  UThing
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterDelegate <NSObject>

- (void)successRegister;

@end

@interface RegisterViewController : UIViewController
@property (nonatomic,weak) id <RegisterDelegate> delegate;
@property (nonatomic) BOOL isMenuClick;
@end
