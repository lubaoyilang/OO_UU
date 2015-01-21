//
//  CustomTextField.m
//  UThing
//
//  Created by Apple on 14/11/19.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "CustomTextField.h"
#import "QuickControl.h"

@implementation CustomTextField

//控制清除按钮的位置
-(CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    
    return CGRectMake(bounds.origin.x + bounds.size.width - 30, bounds.origin.y + bounds.size.height/2 - 8, 16, 16);
    
}

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 5);
    //注意
    CGSize size;
    if (IOS_7) {
        size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_placeHolderFont} context:nil].size;
    }
    else {
        size = [self.placeholder sizeWithFont:_placeHolderFont constrainedToSize:CGSizeMake(MAXFLOAT,30)];
    }
    
//    CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSAttachmentAttributeName:_placeHolderFont} context:nil].size;
    CGRect inset = CGRectMake(bounds.origin.x+bounds.size.width/2-size.width/2, bounds.origin.y+bounds.size.height/2-10, bounds.size.width -10, bounds.size.height);
    return inset;
    
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 50, 0);
    
    CGRect inset = CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    
    return inset;
    
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    
    return CGRectInset( bounds, 20 , 0 );
}

//控制左视图位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds

{
    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width-250, bounds.size.height);
    return inset;
}


//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    [[UIColor colorFromHexRGB:@"f1ece9"] setFill];
    
    [[self placeholder] drawInRect:rect withFont:_placeHolderFont];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
