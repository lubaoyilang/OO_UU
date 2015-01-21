//
//  LoginStatusObject.m
//  UThing
//
//  Created by Apple on 14/12/1.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "LoginStatusObject.h"
#import "UserInfoSingleton.h"

@interface LoginStatusObject ()<UIAlertViewDelegate>

@end

@implementation LoginStatusObject

@synthesize isLogin;

+ (BOOL)isLoginStatus
{
    
    if ([UserInfoSingleton sharedInstance].isLogin) {
        return YES;
    }
    else {
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLoginViewController" object:nil];
        
    }
    return NO;
}


@end
