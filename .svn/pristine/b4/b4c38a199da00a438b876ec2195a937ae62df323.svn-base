//
//  hotel_AutoImageTextTableViewCell.m
//  UThing
//
//  Created by luyuda on 14/12/25.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "hotel_AutoImageTextTableViewCell.h"
#import "CycleScrollView.h"
#import "UIUnderlinedButton.h"
@interface hotel_AutoImageTextTableViewCell ()


@property (nonatomic,strong)UIView *bg;
@property (nonatomic,strong)UILabel *tLabel;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UIUnderlinedButton *showBtn;

@property (nonatomic,strong)NSString *strTEXT;


@end

@implementation hotel_AutoImageTextTableViewCell
@synthesize isShow;

- (id)initWithTEXTStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellh Images:(NSArray*)imgArray
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        isShow = NO;
        CycleScrollView *broadView;
        
        if (![imgArray isKindOfClass:[NSArray class]]) {
            broadView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 220) animationDuration:5 imageUrlArray:[NSArray arrayWithObjects:imgArray, nil]];
        }else{
            broadView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 220) animationDuration:5 imageUrlArray:imgArray];
        }
        
        
        
        [self addSubview:broadView];
        
//        CycleScrollView *broadView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 211) imageArr:imgArray];
//        broadView.delegate = nil;
//        broadView.autoBroad = YES;
//        [self addSubview:broadView];
        
        
        _tLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 220, [UIScreen mainScreen].bounds.size.width-100, 20)];
        _tLabel.numberOfLines = 1;
        _tLabel.font = [UIFont fontWithName:@"Arial" size:12];
        _tLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
        _tLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_tLabel];
        
        
        
        _showBtn = [UIUnderlinedButton buttonWithType:UIButtonTypeSystem];
        _showBtn.frame =CGRectMake([UIScreen mainScreen].bounds.size.width-70, 220, 60, 20);
        [_showBtn setTitle:@"点击展开" forState:UIControlStateNormal];
        _showBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _showBtn.titleLabel.textColor = [UIColor colorFromHexRGB:@"0066cc"];
        [_showBtn addTarget:self action:@selector(showText) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showBtn];
        
        
        
        
        
        
    }
    return self;

    
    
    
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
    _tLabel.frame = CGRectMake(5, 220,[UIScreen mainScreen].bounds.size.width-10,[QuickControl heightForString:_tLabel.text andWidth:[UIScreen mainScreen].bounds.size.width-10 Font:_tLabel.font]);
    _tLabel.numberOfLines = 0;
    [_showBtn removeFromSuperview];
    
}






@end
