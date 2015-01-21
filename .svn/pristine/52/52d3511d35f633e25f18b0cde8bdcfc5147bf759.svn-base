//
//  LoginAndRegisterCenter.m
//  Uthing
//
//  Created by Apple on 14/11/1.
//  Copyright (c) 2014年 Wushengzhong. All rights reserved.
//

#import "LoginAndRegisterCenter.h"
#import "ParametersManagerObject.h"
#import "UserInfoSingleton.h"

#define TIMEINTERVAL 3*60*60*24UL


@implementation UserInfo
@end

@interface LoginAndRegisterCenter ()

@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSMutableData *registerReceiveData;
@property (nonatomic, strong) ParametersManagerObject *loginManagerObject;
@property (nonatomic, strong) ParametersManagerObject *registerManagerObject;
@property (nonatomic, strong) NSURLConnection *loginConnection;
@property (nonatomic, strong) NSURLConnection *registerConnection;
@end

@implementation LoginAndRegisterCenter

/*
 *用户登录
 */
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    _loginManagerObject = [[ParametersManagerObject alloc] init];
    [_loginManagerObject addParamer:[NSString stringWithFormat:@"username=%@",username]];
    [_loginManagerObject addParamer:[NSString stringWithFormat:@"password=%@",[_loginManagerObject passwordEncrypt:password]]];

    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[_loginManagerObject getHeetBody]];
    
    
    _loginConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if (_loginConnection) {
        if (_myProgressHUD) {
            self.myProgressHUD();
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"警告" message: @"不能连接到服务器,请检查您的网络" delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
        [alert show];
    }
}

/*
 *用户注册
 */
- (void)registerWithUsername:(NSString *)username password:(NSString *)password
{
    _registerManagerObject = [[ParametersManagerObject alloc] init];
    [_registerManagerObject addParamer:[NSString stringWithFormat:@"username=%@",username]];
    [_registerManagerObject addParamer:[NSString stringWithFormat:@"password=%@",[_registerManagerObject passwordEncrypt:password]]];
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:registerURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[_registerManagerObject getHeetBody]];
    
    
    
    _registerConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (_registerConnection) {
        if (_myProgressHUD) {
            self.myProgressHUD();
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"警告" message: @"不能连接到服务器,请检查您的网络" delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
        [alert show];
    }
}




#pragma mark ==Receive Data==
//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"%@",[res allHeaderFields]);
    if (connection == _loginConnection) {
        self.receiveData = [[NSMutableData alloc] init];
    }
    else {
        _registerReceiveData = [[NSMutableData alloc] init];
    }
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == _loginConnection) {
        [self.receiveData appendData:data];
    }
    else {
        [self.registerReceiveData appendData:data];
    }
    
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    __block NSError *error1 = [[NSError alloc] init];
    if ([_receiveData length]>0) {
        NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableLeaves error:&error1];
        
        NSLog(@"resultsDict = %@", resultsDictionary);
        
        if (connection == _loginConnection) {
            //验证
            if ([_loginManagerObject checkSign:[resultsDictionary objectForKey:@"data"] Sign:[resultsDictionary objectForKey:@"sign"]]) {
                NSLog(@"登录 验证成功");
                if (_loginBlock) {
                    _loginBlock(resultsDictionary);
                }
            }
            else{
                NSLog(@"登录失败");
            }
        }
        else {
            //验证
            if ([_registerManagerObject checkSign:[resultsDictionary objectForKey:@"data"] Sign:[resultsDictionary objectForKey:@"sign"]]) {
                NSLog(@"注册 验证成功");
                if (_loginBlock) {
                    _loginBlock(resultsDictionary);
                }
            }
            else{
                NSLog(@"登录失败");
            }
        }
        
        
        
    }
}
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
}

//注销
- (void)logout
{
    UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedInstance];
    userInfoSingleton.isLogin = NO;
    
    userInfoSingleton.userInfoModel = nil;
    userInfoSingleton.userInfoModel = [[UserInfoModel alloc] init];

    
    //通知菜单页改变数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutNotification" object:nil];
}


@end
