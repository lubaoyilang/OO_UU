//
//  AppModel.m
//  UThing
//
//  Created by Apple on 14/11/26.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (id)init
{
    if (self = [super init]) {
        _productArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end



