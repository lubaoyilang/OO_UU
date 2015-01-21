//
//  Hotel_UserListenTableViewCell.m
//  UThing
//
//  Created by luyuda on 15/1/7.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "Hotel_UserListenTableViewCell.h"
#import "UIUnderlinedButton.h"
#import "QuickControl.h"
@interface Hotel_UserListenTableViewCell ()
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIUnderlinedButton *showBtn;
@end

@implementation Hotel_UserListenTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, 180)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = RGBCOLOR(120, 120, 120);
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = USERLISTEN;
        [self addSubview:_contentLabel];
        
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth-20-60, 170, 60, 20)];
        bg.backgroundColor = [UIColor whiteColor];
        [self addSubview:bg];
        _showBtn = [UIUnderlinedButton buttonWithType:UIButtonTypeSystem];
        _showBtn.frame =CGRectMake(0, 0, 60, 20);
        [_showBtn setTitle:@"查看全文" forState:UIControlStateNormal];
        _showBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _showBtn.titleLabel.textColor = [UIColor colorFromHexRGB:@"0066cc"];
        [_showBtn addTarget:self action:@selector(showText) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:_showBtn];

        
    }
    return self;
}

- (void)showText
{
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changesize" object:@"2"];
    _contentLabel.frame = CGRectMake(10, 10,kMainScreenWidth-20,[QuickControl heightForString:_contentLabel.text andWidth:kMainScreenWidth-20 Font:_contentLabel.font]);
    UIView *bg = [_showBtn superview];
    [bg removeFromSuperview];
    [_showBtn removeFromSuperview];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
