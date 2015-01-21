//
//  ProductRightImageCell.m
//  UThing
//
//  Created by luyuda on 14/11/28.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "ProductRightImageCell.h"

#define iconY 3
#define iconX 4

@interface ProductRightImageCell ()

@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UIImageView *icon;

@end


@implementation ProductRightImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, [UIScreen mainScreen].bounds.size.width-35, 184)];
        
        [self addSubview:_img];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(13, 0, 0.5, 0)];
        _line.backgroundColor = RGBCOLOR(216, 216, 216);
        _line.hidden = YES;
        [self addSubview:_line];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _icon.backgroundColor = [UIColor whiteColor];
        _icon.hidden = YES;
        [self addSubview:_icon];
        
    }
    return self;
}

- (void)showLine:(float)h
{
    _line.hidden = NO;
    _line.frame = CGRectMake(13, 0, 0.5, h);
}

- (void)showIcon:(NSString*)type
{
    if ([type isEqualToString:@"2"]){
        
        _icon.hidden = NO;
        _icon.image = [UIImage imageNamed:@"app-详情页_29"];
        _icon.frame = CGRectMake(iconX, _line.bounds.size.height-18, 18, 18);
        
    }else{
        _icon.hidden = YES;
    }
    
}


- (void)loadImageWithUrl:(NSString*)url
{
    [_img sz_setImageWithUrlString:url imageSize:@"676x449" options:SDWebImageLowPriority placeholderImageName:nil];
    //[_img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
}



@end
