//
//  ProductRightTextCell.m
//  UThing
//
//  Created by luyuda on 14/11/28.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "ProductRightTextCell.h"

#define iconY 3
#define iconX 5

@interface ProductRightTextCell ()

@property (nonatomic,strong)UILabel *tLabel;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UIImageView *icon;

@end


@implementation ProductRightTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _tLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tLabel.backgroundColor = [UIColor clearColor];
        _tLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
        _tLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_tLabel];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(13, 0, 0.5, 0)];
        _line.backgroundColor = RGBCOLOR(216, 216, 216);
        _line.hidden = YES;
        [self addSubview:_line];
        
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, 18, 18)];
        _icon.backgroundColor = [UIColor whiteColor];
        _icon.image = [UIImage imageNamed:@"app-详情页_17"];
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
    //  1  显示  2 结束
    
   if([type isEqualToString:@"1"]){
        
        NSString *top = [_tLabel.text substringWithRange:NSMakeRange(0,1)];
       
        if ([top isEqualToString:@"第"]) {
            _icon.hidden = NO;
            _icon.frame = CGRectMake(iconX, iconY, 18, 18);
            _icon.image =[UIImage imageNamed:@"app-详情页_17"];
            NSString *num = [_tLabel.text substringWithRange:NSMakeRange(1,1)];
            
            [_icon removeAllSubviews];
            
            UILabel *day = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 10, 10)];
            day.font = [UIFont systemFontOfSize:7];
            day.textColor = [UIColor whiteColor];
            day.text = num;
            [_icon addSubview:day];
            
            
        }else{
            _icon.hidden = YES;
            
        }
       
        
        
    
    }else if ([type isEqualToString:@"2"]){
        
        _icon.hidden = NO;
        _icon.image = [UIImage imageNamed:@"app-详情页_29"];
        _icon.frame = CGRectMake(iconX, _line.bounds.size.height-18, 18, 18);
        
    }
    

}



- (void)loadText:(NSString*)str
{
    _tLabel.text = str;
    _tLabel.numberOfLines = 0;
    
    NSString *top = [str substringWithRange:NSMakeRange(0,1)];
    
    if ([top isEqualToString:@"第"]) {
        _tLabel.textColor = [UIColor colorFromHexRGB:@"999999"];
        _tLabel.font = [UIFont systemFontOfSize:14];
        
    }else{
        
        _tLabel.textColor = [UIColor blackColor];
        _tLabel.font = [UIFont systemFontOfSize:12];
        
    }
    
    
    
    float h =[QuickControl heightForString:str andWidth:rightTextW Font:_tLabel.font];
    
    if (h<=20.0) {
         _tLabel.frame = CGRectMake(rightTextX, 0, rightTextW,20);
        
    }else{
         _tLabel.frame = CGRectMake(rightTextX, 0, rightTextW, [QuickControl heightForString:str andWidth:rightTextW Font:_tLabel.font]);
    }
    
    
    
   
    
    
    
}




@end
