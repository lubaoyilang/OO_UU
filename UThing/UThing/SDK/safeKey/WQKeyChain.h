//
//  WQKeyChain.h
//  HoldNine
//
//  Created by luyuda on 14-5-14.
//  Copyright (c) 2014年 luyuda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQKeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service ;

@end
