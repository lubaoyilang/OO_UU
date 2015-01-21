//
//  HotelPackagesTableViewCell.m
//  UThing
//
//  Created by Apple on 14/12/4.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "HotelPackagesTableViewCell.h"



@interface HotelPackagesTableViewCell ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) UILabel *leftPriceLabel;
@property (nonatomic, strong) UILabel *leftUnitLabel;
@property (nonatomic, strong) UIView *leftPriceBackView;

@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *rightTitleLabel;
@property (nonatomic, strong) UILabel *rightPriceLabel;
@property (nonatomic, strong) UILabel *rightUnitLabel;
@property (nonatomic, strong) UIView *rightPriceBackView;

@end

@implementation HotelPackagesTableViewCell

/**
 *  创建tableView
 *
 *  @param style           cell样式
 *  @param reuseIdentifier
 *
 *  @return tableView
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
        [self initView];
    }
    return self;
}




/**
 *  初始化视图
 */
- (void)initView
{
    CGFloat productWidth = (kMainScreenWidth-30)/2;
    CGFloat productHeight = ((kMainScreenWidth-30)/2)*400/640+30;
    
    
    //left 产品视图
    UIView *leftProductView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, productWidth, productHeight)];
    leftProductView.backgroundColor = [UIColor whiteColor];
        //图
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, productWidth, productHeight-30)];
    [leftProductView addSubview:_leftImageView];
        //title
    _leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, productHeight-27, productWidth-10, 25)];
    _leftTitleLabel.numberOfLines = 2;
    _leftTitleLabel.font = [UIFont systemFontOfSize:10];
    [leftProductView addSubview:_leftTitleLabel];
    
    //
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftProductTap:)];
    [leftProductView addGestureRecognizer:tap];
    
    _leftPriceLabel = [[UILabel alloc] init];
    _leftPriceLabel.font = [UIFont boldSystemFontOfSize:16];
    _leftPriceLabel.backgroundColor = [UIColor colorFromHexRGB:@"ee8f00"];
    _leftPriceLabel.textAlignment = NSTextAlignmentCenter;
    _leftPriceLabel.alpha = .9;
    _leftPriceLabel.textColor = [UIColor whiteColor];
    [_leftImageView addSubview:_leftPriceLabel];
    
    [self.contentView addSubview:leftProductView];
    
    
    //right 产品视图
    UIView *rightProductView = [[UIView alloc] initWithFrame:CGRectMake(productWidth+10, 10, productWidth, productHeight)];
    rightProductView.backgroundColor = [UIColor whiteColor];
    rightProductView.tag = 300;
    //图
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, productWidth, productHeight-30)];
    [rightProductView addSubview:_rightImageView];
    //title
    _rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, productHeight-27, productWidth-10, 25)];
    _rightTitleLabel.numberOfLines = 2;
    _rightTitleLabel.font = [UIFont systemFontOfSize:10];
    [rightProductView addSubview:_rightTitleLabel];
    
    
    _rightPriceLabel = [[UILabel alloc] init];
    _rightPriceLabel.font = [UIFont boldSystemFontOfSize:16];
    _rightPriceLabel.backgroundColor = [UIColor colorFromHexRGB:@"ee8f00"];
    _rightPriceLabel.textAlignment = NSTextAlignmentCenter;
    _rightPriceLabel.alpha = .9;
    _rightPriceLabel.textColor = [UIColor whiteColor];
    [_rightImageView addSubview:_rightPriceLabel];
    
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightProductTap:)];
    [rightProductView addGestureRecognizer:rightTap];
    
    [self.contentView addSubview:rightProductView];
    
    

    
}



//left 产品视图点击事件
- (void)leftProductTap:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(hotelPackagesClickIndex:)]) {
        [_delegate hotelPackagesClickIndex:_indexRow*2];
    }
}
//right 产品视图点击事件
- (void)rightProductTap:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(hotelPackagesClickIndex:)]) {
        [_delegate hotelPackagesClickIndex:_indexRow*2+1];
    }
}




/**
 *  重新显示控件数据
 */
#pragma mark ==reloadData==
- (void)reloadCellData
{
    
    [_leftImageView sz_setImageWithUrlString:_leftModel.cover_photo_url imageSize:@"320x215" options:SDWebImageLowPriority placeholderImageName:@"placeHolderImage_small.png"];
    
    _leftTitleLabel.text = _leftModel.title;
    
    if (self.rightModel) {
        UIView *view = (UIView *)[self viewWithTag:300];
        view.hidden = NO;
        [_rightImageView sz_setImageWithUrlString:_rightModel.cover_photo_url imageSize:@"320x215" options:SDWebImageLowPriority placeholderImageName:@"placeHolderImage_small.png"];
         _rightTitleLabel.text = _rightModel.title;
    }
    else {
        UIView *view = (UIView *)[self viewWithTag:300];
        view.hidden = YES;
    }
    
    

//    
    NSString *str = [NSString stringWithFormat:@"¥%@/人起", [NSString moneyFromThousand:_leftModel.low_price]];
    CGFloat width = [QuickControl widthForString:str andHeigh:20 Font:[UIFont systemFontOfSize:16]];
    _leftPriceLabel.text = str;
    [_leftPriceLabel setFrame:CGRectMake(_leftImageView.width-width-10, _leftImageView.bottom-30, width+10, 20)];
    
    
    NSString *rightStr = [NSString stringWithFormat:@"¥%@/人起", [NSString moneyFromThousand:_rightModel.low_price]];
    CGFloat rightWidth = [QuickControl widthForString:rightStr andHeigh:20 Font:[UIFont systemFontOfSize:16]];
    _rightPriceLabel.text = rightStr;
    [_rightPriceLabel setFrame:CGRectMake(_rightImageView.width-rightWidth-10, _rightImageView.bottom-30, rightWidth+10, 20)];
}

@end













