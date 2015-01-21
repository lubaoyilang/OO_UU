//
//  NetworkingCenter.h
//  UThing
//
//  Created by Apple on 14/11/27.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^myError)(NSError *error);
typedef void(^myResultsHandle)(NSMutableData *resultData);
typedef void(^myProgressHUD)();
typedef void(^myProgressHUDHid)();

@interface NetworkingCenter : NSObject

@property (nonatomic, copy) myError myError;
@property (nonatomic, copy) myResultsHandle myResultsHandle;
@property (nonatomic, copy) myProgressHUD myProgressHUD;
@property (nonatomic, copy) myProgressHUDHid myProgressHUDHid;

//block回调方法

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此
- (void)setMyError:(myError)myError;
//
- (void)setMyResultsHandle:(myResultsHandle)myResultsHandle;
//
- (void)setMyProgressHUD:(myProgressHUD)myProgressHUD;

- (void)setMyProgressHUDHid:(myProgressHUDHid)myProgressHUDHid;

//异步post请求
- (void)myAsynchronousPostWithUrl:(NSString *)urlString postData:(NSData *)data;
@end
