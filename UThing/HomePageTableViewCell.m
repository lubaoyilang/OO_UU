//
//  HomePageTableViewCell.m
//  Uthing
//
//  Created by Apple on 14/11/10.
//  Copyright (c) 2014年 Wushengzhong. All rights reserved.
//

#import "HomePageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TextFieldAndSelectedView.h"

#define ELEMENTVIEW_TO_LEFT 5


@interface HomePageTableViewCell ()
{
    
    UILabel *m_cellTitleLabel;
    UILabel *m_cellSubTitleLabel;
    
    UIView *m_cellLineView;
    UIButton *m_checkMoreBtn;
    
    UIButton *m_cellButton;
}
@end

@implementation HomePageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(int)index
{
    self.cellIndex = index;
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self createControl];
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)createControl
{
    [self configMainTitleView];
    
    //cell elementView
    [self configElementView];
}

- (void)configMainTitleView
{
    m_cellLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 3)];
    [self.contentView addSubview:m_cellLineView];
    
    m_cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    m_cellTitleLabel.textAlignment = NSTextAlignmentCenter;
    m_cellTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    m_cellTitleLabel.center = CGPointMake(kMainScreenWidth/2, 25);
    [self.contentView addSubview:m_cellTitleLabel];
    
    m_cellSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    m_cellSubTitleLabel.textAlignment = NSTextAlignmentCenter;
    m_cellSubTitleLabel.font = [UIFont systemFontOfSize:14];
    m_cellSubTitleLabel.alpha = 0.5;
    m_cellSubTitleLabel.center = CGPointMake(kMainScreenWidth/2, 50);
    [self.contentView addSubview:m_cellSubTitleLabel];
    
    
    //left
    UIImageView *leftImageView = [UIImageView imageViewWithFrame:CGRectMake(0, 15, kMainScreenWidth*0.25, 45) image:nil];
    leftImageView.image = [UIImage imageNamed:@"app-首页_02.png"];
    [self.contentView addSubview:leftImageView];
   
    
    //right
    UIImageView *rightImageView = [UIImageView imageViewWithFrame:CGRectMake(kMainScreenWidth*.75, 15, kMainScreenWidth*0.25, 45) image:@"app-首页_04.png"];
    rightImageView.image = [UIImage imageNamed:@"app-首页_04.png"];
    [self.contentView addSubview:rightImageView];

    m_checkMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //TODO: 根据个数修改
    m_checkMoreBtn.frame = CGRectMake(10, 90+(kMainScreenWidth-20)*ELEMENTVIEW_ASPECT_RATIO, kMainScreenWidth-20, 35);
    ;
    m_checkMoreBtn.backgroundColor = [UIColor clearColor];
    m_checkMoreBtn.layer.borderWidth = 1;
    m_checkMoreBtn.layer.borderColor = [UIColor colorFromHexRGB:@"ad9895"].CGColor;
    m_checkMoreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [m_checkMoreBtn addTarget:self action:@selector(checkMoreClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:m_checkMoreBtn];
    
}

- (void)checkMoreClick
{
    if (_m_delegate && [_m_delegate respondsToSelector:@selector(checkMoreInCell:)]) {
        [_m_delegate checkMoreInCell:_cellIndex];
    }
}


- (void)setDataToTheControl
{
    [self settingTitleTextAndColor];
}
/*
 *给cell赋值
 */
- (void)settingTitleTextAndColor
{
    UIColor *color;
    switch (_cellIndex) {
        case 0:{
            color = [UIColor colorFromHexRGB:@"ff9900"];
            m_cellSubTitleLabel.text = @"Customized tour";
            break;
        }
        case 1:{
            color = [UIColor colorFromHexRGB:@"a2ff00"];
            m_cellSubTitleLabel.text = @"Local tour";
            break;
        }
        case 2:{
            color = [UIColor colorFromHexRGB:@"ffff00"];
            m_cellSubTitleLabel.text = @"Free line";
            break;
        }
        case 3:{
            color = [UIColor colorFromHexRGB:@"20ffe6"];
            m_cellSubTitleLabel.text = @"Hotel packages";
            break;
        }
            
        default:
            break;
    }
    [self setColorWithColor:color];
}

- (void)setColorWithColor:(UIColor *)color
{
    m_cellTitleLabel.textColor = color;
    m_cellSubTitleLabel.textColor = color;
    m_cellLineView.backgroundColor = color;
    [m_checkMoreBtn setTitleColor:color forState:UIControlStateHighlighted];
    m_checkMoreBtn.layer.borderColor = color.CGColor;
}


//产品图和标题
#pragma mark ==Product View And Title==
- (void)configElementView
{
    for (int i=0; i<4; i++) {
        [self addElementView:i];
    }
}

- (void)addElementView:(int)index
{
    float w = (kMainScreenWidth-20)/2;
    float h = [[NSString stringWithFormat:@"%f",w*ELEMENTVIEW_ASPECT_RATIO] intValue];
    float x = ELEMENTVIEW_TO_LEFT + (w+10)*(index%2);
    float y = 70 + (h+10)*(index/2);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, w, h);
    
    button.backgroundColor = [UIColor colorFromHexRGB:@"ffffff"];
    [self addIconAndTitleToView:button index:index];
    button.tag = 1000+index;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:button];
}

- (void)btnClick:(UIButton *)button
{
    [self.m_delegate clickToDetailViewInCell:button.tag-1000 cellIndex:_cellIndex];
}

- (void)addIconAndTitleToView:(UIButton *)button index:(NSInteger)index
{
    //imageView
    CGRect frame = button.bounds;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*0.7)];
    imageView.tag = 900+index;
    [button addSubview:imageView];
    
    
    //Price
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.font = [UIFont systemFontOfSize:16];
    priceLabel.tag = 321+index;
    priceLabel.alpha = .9;
    priceLabel.backgroundColor = [UIColor colorFromHexRGB:@"ee8f00"];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    
    [imageView addSubview:priceLabel];
    
    
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.size.height*0.7+3, frame.size.width-10, frame.size.height*(1-0.7)-6)];

    titleLabel.numberOfLines = 2;
    titleLabel.tag = 800+index;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [button addSubview:titleLabel];
}


#pragma mark ==reloadData==
- (void)reloadCellData
{
    m_cellTitleLabel.text = [_homeModel.infoDict objectForKey:@"name"];
    
    for (int i=0; i<4; i++) {
        
        ProductModel *model = [_homeModel.productArr objectAtIndex:i];
        UIImageView *imageView = (UIImageView *)[self viewWithTag:900+i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[model.cover_photo_url replaceCharcter:@"index" withCharcter:@"320x215"]] placeholderImage:[UIImage imageNamed:@"placeHolderImage_small.png"] options:SDWebImageLowPriority];
        
        
        UILabel *priceLabel = (UILabel *)[self viewWithTag:321+i];

        NSString *str = [NSString stringWithFormat:@"¥%@/人起", [NSString moneyFromThousand:model.low_price]];
        CGFloat width = [QuickControl widthForString:str andHeigh:20 Font:[UIFont systemFontOfSize:16]];
        [priceLabel setFrame:CGRectMake(imageView.width-width-10, imageView.height-30, width+10, 20)];
        priceLabel.text = str;
        
        UILabel *title = (UILabel *)[self viewWithTag:800+i];
        
        title.text = model.title;
    }
    
    [m_checkMoreBtn setTitle:[NSString stringWithFormat:@"查看更多%@", [_homeModel.infoDict objectForKey:@"name"]] forState:UIControlStateNormal];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
