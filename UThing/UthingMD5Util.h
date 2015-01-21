//
//  UthingMD5Util.h
//  UThing
//
//  Created by luyuda on 14/11/24.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface UthingMD5Util : NSObject


//计算NSData 的MD5值

+(NSString*)getMD5WithData:(NSData*)data;


//计算字符串的MD5值，

+(NSString*)getmd5WithString:(NSString*)string;


//计算大文件的MD5值

+(NSString*)getFileMD5WithPath:(NSString*)path;


@end
