//
//  NSArray+safeArray.m
//  UThing
//
//  Created by luyuda on 14/12/16.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "NSArray+safeArray.h"

@implementation NSArray (safeArray)


- (id)safeFirstObject
{
    if ([self count]) {
        
        return [self firstObject];
        
    }else{
        return nil;
    }

}
- (id)safeLastObject
{
    if ([self count]) {
        
        return [self lastObject];
        
    }else{
        return nil;
    }
    
}

- (id)safeObjectIndex:(int)index
{
    if ([self count]-1>=index) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
    
}

- (void)showStrObjects
{
    for (int i = 0 ; i<[self count]; i++) {
        id obj = [self safeObjectIndex:i];
        if ([obj isKindOfClass:[NSString class]]) {
            NSLog(@"%@",obj);
        }
    }
    

}


@end
