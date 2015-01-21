//
//  UserInfoSingleton.m
//  UThing
//
//  Created by Apple on 14/11/26.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "UserInfoSingleton.h"

static UserInfoSingleton *sharedObj = nil;

@implementation UserInfoSingleton

+ (UserInfoSingleton *) sharedInstance
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (sharedObj == nil) {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];
        _userInfoModel = [[UserInfoModel alloc] init];
        return self;
    }
}
@end


@implementation UserInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
