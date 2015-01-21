//
//  ParametersManagerObject.h
//  UThing
//
//  Created by luyuda on 14/11/24.
//  Copyright (c) 2014年 UThing. All rights reserved.
//网络参数的封装

#import <Foundation/Foundation.h>

@interface ParametersManagerObject : NSObject

- (NSString*)passwordEncrypt:(NSString*)pwd;
- (void)addParamer:(NSObject*)objct; 
- (NSString*)getSign;
- (NSString*)getParamers;
- (NSString*)getParamersWithSign;
- (NSData*)getAddParamer:(NSArray*)pArr;

- (void)removeObjects;

//直接获取要上传参数的 data格式，可以直接post上去
- (NSData*)getHeetBody;

//接口返回数据的校验，data 传入 解析后的data数据，sign 传入 解析后的sign字符串
- (BOOL)checkSign:(id)data Sign:(NSString*)sg;




@end
