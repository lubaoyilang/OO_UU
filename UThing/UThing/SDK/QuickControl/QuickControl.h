//
//  QuickControl.h
//  FreeLimit1413
//
//  Created by mac on 14-6-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface QuickControl : NSObject

//获取字符串的高度，系统版本通用
+ (float) heightForString:(NSString *)text andWidth:(float)width Font:(UIFont*)f;

+ (float) widthForString:(NSString *)text andHeigh:(float)h Font:(UIFont*)f;


+ (UIView*)customButtonTitle:(NSString*)tit Frame:(CGRect)frame Color:(UIColor*)col Action:(SEL)action Target:(id)target;





@end

//目的为了快速创建控件

#pragma mark - UILabel快捷创建方法
@interface UILabel (QuickControl)
//简单方法
+ (id)labelWithFrame:(CGRect)frame
               text:(NSString *)text;
//多参数方法
+ (id)labelWithFrame:(CGRect)frame
                text:(NSString *)text
           textColor:(UIColor *)textColor
                font:(UIFont *)font;

//根据内容自动返回一个label
+ (UILabel *)createAutolayoutWithString:(NSString *)string fontSize:(CGFloat)fontSize color:(UIColor *)color valueX:(CGFloat)x valueY:(CGFloat)y;

@end

#pragma mark - UIButton快捷创建方法
@interface UIButton (QuickControl)
//快速创建按钮的方法
+ (id)buttonWithFrame:(CGRect)frame
                title:(NSString *)title
                image:(NSString *)image
               target:(id)target
               action:(SEL)action;
+ (id)systemButtonWithFrame:(CGRect)frame
                      title:(NSString *)title
                     target:(id)target
                     action:(SEL)action;
//block方法
+ (id)systemButtonWithFrame:(CGRect)frame
                      title:(NSString *)title
                      image:(NSString *)image
                     action:(void (^)(UIButton *button))action;
@end

@interface QuickButton : UIButton
@property (copy, nonatomic) void (^blockAction)(UIButton *button);
@end

#pragma mark - UIImageView快捷创建方法
@interface UIImageView (QuickControl)
//快速创建imageView
+ (id)imageViewWithFrame:(CGRect)frame
                  image:(NSString *)image;


@end

#pragma mark - UIView常用方法封装(圆角图片)
@interface UIView (QuickControl)
//设置圆角
- (void)setCornerRadius:(float)radius;
@end

@interface UIImage (QuickControl)
+ (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
+ (UIImage *)getImageFromView:(UIView *)orgView;
@end


#pragma mark - 系统常用方法(系统版本, 宽度, 高度)
@interface NSObject (QuickControl)
//判断系统版本
+ (int)osVersion;
//获取屏幕高度
+ (float)screenHeight;
//获取屏幕宽度
+ (float)screenWidth;

+ (CGRect)screenBounds;
@end

#pragma mark - UIColor常用方法
@interface UIColor (QuickControl)
//通过RGB值#FFFFFF设置颜色 传入参数FFFFFF
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;
@end

#pragma mark - NSString  判定是否是邮箱
@interface NSString (QuickControl)



/*邮箱验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateEmail:(NSString *)email;
/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(NSString *)mobile;
/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL)validateCarNo:(NSString *)carNo;

- (UIBezierPath*)bezierPathWithFont:(UIFont*)font;


/**
 *  计算文字尺寸
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
#pragma mark ==计算文字尺寸==
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;



@end




