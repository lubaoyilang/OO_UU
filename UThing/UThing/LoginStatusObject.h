//
//  LoginStatusObject.h
//  UThing
//
//  Created by Apple on 14/12/1.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginStatusObject : NSObject


@property BOOL isLogin;


//判断是否是登录状态
+ (BOOL)isLoginStatus;

@end
