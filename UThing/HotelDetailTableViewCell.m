//
//  HotelDetailTableViewCell.m
//  UThing
//
//  Created by luyuda on 14/12/29.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "HotelDetailTableViewCell.h"
#import "QBFlatButton.h"

#define StartX 10



@interface HotelDetailTableViewCell ()

@property (nonatomic,strong)UILabel *titleText;
@property (nonatomic,strong)UILabel *subtitle;
@property (nonatomic,strong)UILabel *contentText;
@property (nonatomic,strong)UILabel *featureText;
@property (nonatomic,strong)id obj;
@property (nonatomic,strong)QBFlatButton *qBtn;

@end


@implementation HotelDetailTableViewCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = RGBCOLOR(248, 248, 248);
        _titleText = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleText.font = [UIFont systemFontOfSize:15];
        _titleText.textColor = [UIColor blackColor];
        _titleText.text = @"套餐简介";
        [self addSubview:_titleText];
        
        _contentText = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentText.numberOfLines = 0;
        _contentText.font = [UIFont systemFontOfSize:15];
        _contentText.textColor = RGBCOLOR(120, 120, 120);
        [self addSubview:_contentText];
        
        
        
        _subtitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitle.font = [UIFont systemFontOfSize:15];
        _subtitle.textColor = [UIColor blackColor];
        _subtitle.text = @"套餐亮点";
        [self addSubview:_subtitle];
        
        
        _featureText = [[UILabel alloc] initWithFrame:CGRectZero];
        _featureText.font = [UIFont systemFontOfSize:15];
        _featureText.numberOfLines = 0;
        _featureText.textColor = RGBCOLOR(120, 120, 120);
        [self addSubview:_featureText];
        
        
        
        
        
        [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
        [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
        
        
        _qBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        _qBtn.frame = CGRectZero;
        _qBtn.faceColor =[UIColor colorWithRed:246.0/255.0 green:102.0/255.0 blue:7.0/255.0 alpha:1.0];
        _qBtn.sideColor = [UIColor colorWithRed:203.0/255.0 green:87.0/255.0 blue:0.0/255.0 alpha:1.0];
        _qBtn.radius = 0.0;
        _qBtn.margin = 0.0;
        _qBtn.depth = 2.0;
        _qBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_qBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_qBtn setTitle:@"预定咨询" forState:UIControlStateNormal];
        [_qBtn addTarget:self action:@selector(goAsk) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_qBtn];
        
        
        
        
    }
    return self;
    
}


- (void)goAsk
{
    if (delegate && [delegate respondsToSelector:@selector(callBackObj:)]) {
        [delegate callBackObj:_obj];
    }
    
    
}


- (void)loadObj:(NSDictionary*)obj
{
    
    _obj = obj;
    NSString *cont = [obj objectForKey:@"content"];
    NSString *feature = [obj objectForKey:@"feature"];
    
    float c_h = [QuickControl heightForString:cont andWidth:kMainScreenWidth-20 Font:_contentText.font];
    float f_h = [QuickControl heightForString:feature andWidth:kMainScreenWidth-20 Font:_featureText.font];
    
    
    _titleText.frame = CGRectMake(10, 10, kMainScreenWidth-20, 20);
    _contentText.frame = CGRectMake(10, 30, kMainScreenWidth-20, c_h);
    
    _subtitle.frame = CGRectMake(10, 30+c_h, kMainScreenWidth-20, 20);
    _featureText.frame = CGRectMake(10, 30+c_h+20, kMainScreenWidth-20, f_h);
    
    
    
    _contentText.text = cont;
    _featureText.text = feature;
    
    _qBtn.frame = CGRectMake((kMainScreenWidth-120)/2, 30+c_h+20+f_h+10, 120, 30);
    

}

@end
