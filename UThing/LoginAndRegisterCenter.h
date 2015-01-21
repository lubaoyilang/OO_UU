//
//  LoginAndRegisterCenter.h
//  Uthing
//
//  Created by Apple on 14/11/1.
//  Copyright (c) 2014年 Wushengzhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *currentPrice;

@end

typedef void(^myProgressHUD)();
typedef void(^loginBlock)(NSDictionary *resultsDictionary);

@interface LoginAndRegisterCenter : NSObject

@property (nonatomic, copy) myProgressHUD myProgressHUD;
@property (nonatomic, copy) loginBlock loginBlock;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic) BOOL loggingStatus;

//
- (void)setMyProgressHUD:(myProgressHUD)myProgressHUD;

//登录
- (void)loginWithUsername:(NSString *)username password:(NSString *)password;

//注册
- (void)registerWithUsername:(NSString *)username password:(NSString *)password;

//注销
- (void)logout;


@end
