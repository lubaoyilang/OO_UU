//
//  UserInfoSingleton.h
//  UThing
//
//  Created by Apple on 14/11/26.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject


@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, strong) NSString *authcode;
@property (nonatomic, strong) NSString *device;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *groupid;
@property (nonatomic, strong) NSString *head_ico;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *nikename;
@property (nonatomic, strong) NSString *src;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *updatetime;
@property (nonatomic, strong) NSString *username;

@end

@interface UserInfoSingleton : NSObject

@property (nonatomic, strong) UserInfoModel *userInfoModel;
@property (nonatomic, strong) NSString *scoreUrl; //评分链接
@property (nonatomic, strong) NSString *goDownUrl; //下载应用链接
@property (nonatomic, strong) NSString *phone;

+ (UserInfoSingleton *) sharedInstance;
@property (nonatomic) BOOL isLogin;

@end
