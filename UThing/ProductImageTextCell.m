//
//  ProductImageTextCell.m
//  UThing
//
//  Created by luyuda on 14/11/25.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "ProductImageTextCell.h"
#import "UIUnderlinedButton.h"


@interface ProductImageTextCell ()

@property (nonatomic,strong)UIView *bg;
@property (nonatomic,strong)UILabel *tLabel;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UIUnderlinedButton *showBtn;

@property (nonatomic,strong)NSString *strTEXT;

@end


@implementation ProductImageTextCell
@synthesize isShow;


- (id)initWithTEXTStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellh
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        isShow = NO;
        
        
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 211)];
        
        [self addSubview:_img];
        
        
        _tLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 215, [UIScreen mainScreen].bounds.size.width-100, 20)];
        _tLabel.numberOfLines = 1;
        _tLabel.font = [UIFont fontWithName:@"Arial" size:12];
        _tLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
        _tLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_tLabel];
        
                
        
        _showBtn = [UIUnderlinedButton buttonWithType:UIButtonTypeSystem];
        _showBtn.frame =CGRectMake([UIScreen mainScreen].bounds.size.width-70, 218, 60, 20);
        [_showBtn setTitle:@"点击展开" forState:UIControlStateNormal];
        _showBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _showBtn.titleLabel.textColor = [UIColor colorFromHexRGB:@"0066cc"];
        [_showBtn addTarget:self action:@selector(showText) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showBtn];

        
        
        
        
        
    }
    return self;
    
}


- (void)loadImageWithUrl:(NSString*)url
{
    [_img sz_setImageWithUrlString:url imageSize:@"676x449" options:SDWebImageLowPriority placeholderImageName:nil];
    //[_img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
}

- (void)loadText:(NSString*)str
{
    _strTEXT = str;
    _tLabel.text = str;
    
    float strH =[QuickControl heightForString:str andWidth:[UIScreen mainScreen].bounds.size.width-10 Font:_tLabel.font];
    if (strH>= _tLabel.bounds.size.height) {
        _showBtn.hidden = NO;
    }else{
        _showBtn.hidden = YES;
    }
    
    
    
}


- (void)showText
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changesize" object:nil];
    
    
    isShow = YES;
    _tLabel.frame = CGRectMake(5, 215,[UIScreen mainScreen].bounds.size.width-10,[QuickControl heightForString:_tLabel.text andWidth:[UIScreen mainScreen].bounds.size.width-10 Font:_tLabel.font]);
    _tLabel.numberOfLines = 0;
    [_showBtn removeFromSuperview];
    
}


- (float)getCellHeight
{
    float strH =[QuickControl heightForString:_tLabel.text andWidth:[UIScreen mainScreen].bounds.size.width-10 Font:_tLabel.font];
    
    return strH+211;
}



@end
