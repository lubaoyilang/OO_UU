//
//  FillInTextField.m
//  UThing
//
//  Created by Apple on 14/12/4.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "FillInTextField.h"

@implementation FillInTextField


//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 50, 0);
    
    CGRect inset = CGRectMake(bounds.origin.x+4, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    
    return inset;
    
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    
    return CGRectInset( bounds, 4 , 0 );
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
