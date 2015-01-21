//
//  QuickControl.m
//  FreeLimit1413
//
//  Created by mac on 14-6-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "QuickControl.h"
#import  <CoreText/CoreText.h>

@implementation UIImage (QuickControl)

/**
 *  改变图片大小缩放方法
 *
 *  @param image 需要缩放的图片
 *  @param size  所需图片尺寸
 *
 *  @return 已经改变的图片
 */
+ (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

/**
 *  通过View获取图像
 *
 *  @param orgView view
 *
 *  @return 返回图片
 */
+ (UIImage *)getImageFromView:(UIView *)orgView {
    UIGraphicsBeginImageContext(orgView.bounds.size);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


@implementation UILabel (QuickControl)
//添加快速创建的方法
+(id)labelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    return label;
}
//多参数方法
+ (id)labelWithFrame:(CGRect)frame
                text:(NSString *)text
           textColor:(UIColor *)textColor
                font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    return label;
}

+ (UILabel *)createAutolayoutWithString:(NSString *)string fontSize:(CGFloat)fontSize color:(UIColor *)color valueX:(CGFloat)x valueY:(CGFloat)y
{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    UIFont * tfont = [UIFont systemFontOfSize:fontSize];
    label.font = tfont;
    label.lineBreakMode =NSLineBreakByCharWrapping ;
    label.text = string ;
    label.textColor = color;
    
    CGSize size =CGSizeMake([[UIScreen mainScreen] bounds].size.width-2*x,999999);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    label.frame = CGRectMake(x, y, actualsize.width, actualsize.height);
    
    return label;
}

/*根据label内容来调整label的高度*/
- (void)resizeLabelByContent:(UILabel *)label
{
    CGSize maxSize = CGSizeMake(label.frame.size.width, 9999);
    label.numberOfLines = 0;
    NSString *contentStr = label.text;
    UIFont *contentFont = label.font;
    
    CGRect contentFrame;
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if ([version floatValue] < 7.0) {
        CGSize contentStringSize = [contentStr sizeWithFont: contentFont constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
        contentFrame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, contentStringSize.height);
    } else {
        NSDictionary *contentDic = [NSDictionary                dictionaryWithObjectsAndKeys:contentFont, NSFontAttributeName, nil];
        CGSize contentStrSize = [contentStr boundingRectWithSize:maxSize                options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic                 context:nil].size;
        contentFrame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width,           contentStrSize.height);
    }
    label.frame = contentFrame;
}

@end

@implementation UIButton (QuickControl)

//快速创建按钮的方法
+(id)buttonWithFrame:(CGRect)frame
               title:(NSString *)title
               image:(NSString *)image
              target:(id)target
              action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(id)systemButtonWithFrame:(CGRect)frame
                     title:(NSString *)title
                    target:(id)target
                    action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)systemButtonWithFrame:(CGRect)frame
                      title:(NSString *)title
                      image:(NSString *)image
                     action:(void (^)(UIButton *button))action
{
    QuickButton *button = [QuickButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.blockAction = action;
    return button;
}

@end

@implementation QuickButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnClick:(QuickButton *)button
{
    //当按钮点击之后, 执行传入的block语句
    button.blockAction(button);
}
@end

@implementation UIImageView (QuickControl)
//快速创建imageView
+(id)imageViewWithFrame:(CGRect)frame
                  image:(NSString *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:image];
    return imageView;
}
@end

#pragma mark - UIView常用方法封装
@implementation UIView (QuickControl)
//可以为任何view设置圆角
-(void)setCornerRadius:(float)radius
{
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}



@end


#pragma mark - 系统常用方法(系统版本, 宽度, 高度)
@implementation NSObject (QuickControl)
//判断系统版本
+(int)osVersion
{
    //使用UIDevice设别类获取版本, 名字.....
    return [[[UIDevice currentDevice] systemVersion] intValue];
}
//获取屏幕高度
+(float)screenHeight
{
    //使用 UIScreen类获取
    return [[UIScreen mainScreen] bounds].size.height;
}
//获取屏幕宽度
+(float)screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}
+ (CGRect)screenBounds
{
    return [[UIScreen mainScreen] bounds];
}
@end

@implementation UIColor (QuickControl)
//通过RGB值#FFFFFF设置颜色
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}
@end


@implementation NSString (QuickControl)

/*邮箱验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL)validateCarNo:(NSString* )carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

- (UIBezierPath*)bezierPathWithFont:(UIFont*)font {
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:self attributes:[NSDictionary dictionaryWithObject:(__bridge id)ctFont forKey:(__bridge NSString*)kCTFontAttributeName]];
    CFRelease(ctFont);
    
    CGMutablePathRef letters = CGPathCreateMutable();
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attributed);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
    CGRect boundingBox = CGPathGetBoundingBox(letters);
    CGPathRelease(letters);
    CFRelease(line);
    
    // The path is upside down (CG coordinate system)
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    
    return path;
}


/**
 *  计算文字尺寸
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
#pragma mark ==计算文字尺寸==
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize

{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    //判断设备的操做系统是不是ios7

    if (IOS_7) {
        return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    }
    else
    {
        return [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];//ios7以上已经摒弃的这个方法
    }
}


@end



@implementation QuickControl


/**
 *  定制一个自定义颜色标题的按钮
 *
 *  @param tit    标题
 *  @param frame  坐标
 *  @param col    颜色
 *  @param action 方法
 *
 *  @return 按钮
 */
+ (UIView*)customButtonTitle:(NSString*)tit Frame:(CGRect)frame Color:(UIColor*)col Action:(SEL)action Target:(id)target
{
    UIView *bg = [[UIView alloc] initWithFrame:frame];
    bg.layer.cornerRadius = 4.0;
    
    UILabel *tijiaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    tijiaoLabel.text =tit;
    tijiaoLabel.layer.cornerRadius = 10.0;
    tijiaoLabel.textAlignment = NSTextAlignmentCenter;
    tijiaoLabel.font = [UIFont systemFontOfSize:14];
    tijiaoLabel.textColor = [UIColor whiteColor];
    tijiaoLabel.backgroundColor = col;
    [bg addSubview:tijiaoLabel];
    UIControl *yudingBtn = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [yudingBtn addTarget:target action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:yudingBtn];
    
    
    return bg;
}




+ (float) heightForString:(NSString *)text andWidth:(float)width Font:(UIFont*)f
{


    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:f,NSFontAttributeName, nil] context:nil];
    
    CGFloat contentH = tmpRect.size.height+5;

    return contentH;

}

+ (float) widthForString:(NSString *)text andHeigh:(float)h Font:(UIFont*)f
{
    
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake(1000, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:f,NSFontAttributeName, nil] context:nil];
    
    CGFloat contentW = tmpRect.size.width;
    
    return contentW;
    
    
}




@end










