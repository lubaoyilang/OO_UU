//
//  NetworkingCenter.m
//  UThing
//
//  Created by Apple on 14/11/27.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "NetworkingCenter.h"

@interface NetworkingCenter ()

@property (nonatomic, strong) NSMutableData *receiveData;

@end

@implementation NetworkingCenter


- (void)myAsynchronousPostWithUrl:(NSString *)urlString postData:(NSData *)data
{
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if (connection) {
        
        if (_myProgressHUD) {
            self.myProgressHUD();
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"警告" message: @"不能连接到服务器,请检查您的网络" delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
        [alert show];
    }
}


//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
//    NSLog(@"%@",[res allHeaderFields]);
    self.receiveData = [NSMutableData data];
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.myResultsHandle(_receiveData);
}
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    
    if (_myProgressHUDHid) {
        self.myProgressHUDHid();
    }
    self.myError(error);
}

@end
