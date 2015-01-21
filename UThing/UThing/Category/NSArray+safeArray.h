//
//  NSArray+safeArray.h
//  UThing
//
//  Created by luyuda on 14/12/16.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (safeArray)


- (id)safeFirstObject;
- (id)safeLastObject;
- (id)safeObjectIndex:(int)index;

- (void)showStrObjects;

@end
