//
//  PriceView.m
//  UThing
//
//  Created by Apple on 14/12/24.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "PriceView.h"

@interface PriceView ()
{
    NSString *_price;
}

@end

@implementation PriceView


- (id)initWithFrame:(CGRect)frame price:(NSString *)price
{
    _price = price;
    self = [self initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    CGFloat height = 40;
    frame.size.height = height;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorFromHexRGB:@"ee8f00"];
        self.alpha = .9f;
        
        [self initView];
        
    }
    return self;
}

//
- (void)initView
{
    //left
    UILabel *label = [[UILabel alloc] init];
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@ /人起",_price]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,1)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,str.length-5)];

    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0] range:NSMakeRange(2,str.length-6)];


    
    label.attributedText = str;
    
    CGRect frame = self.frame;
    frame.size.width = label.width+2;
    self.frame = frame;
    
    [self addSubview:label];
    


//    UILabel *label = [UILabel labelWithFrame:CGRectMake(0, 4, 8, 16) text:@"￥%@/人起",_price];
//    label.font = [UIFont systemFontOfSize:12];
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:label];
//
//    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right, 0, [QuickControl widthForString:_price andHeigh:20 Font:[UIFont systemFontOfSize:16]], 20)];
//    priceLabel.font = [UIFont boldSystemFontOfSize:16];
//    priceLabel.text = _price;
//    priceLabel.textColor = [UIColor whiteColor];
//    priceLabel.tag = 201;
//    [self addSubview:priceLabel];
//    
//    UILabel *unitLabel = [UILabel labelWithFrame:CGRectMake(15+priceLabel.bounds.size.width+3, 5, 7, 16) text:@"/人起"];
//    unitLabel.font = [UIFont systemFontOfSize:12];
//    [unitLabel sizeToFit];
//    unitLabel.textColor = [UIColor whiteColor];
//    [self addSubview:unitLabel];
//    
//    CGFloat w = 8+priceLabel.width+3+unitLabel.width;
//    [self setFrame:CGRectMake(0, 0, w, 40)];
//    
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.greaterThanOrEqualTo(self).offset(5);
//        make.left.equalTo(self).offset(3);
//        make.bottom.equalTo(self).offset(3);
//        make.right.equalTo(priceLabel.mas_left);
//    }];
//    
//    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.greaterThanOrEqualTo(self).offset(0);
//        make.left.equalTo(label.mas_right);
//        make.bottom.equalTo(self).offset(3);
//        make.right.equalTo(priceLabel.mas_left);
//    }];
//    
//    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.greaterThanOrEqualTo(5);
//        make.left.equalTo(priceLabel.mas_right);
//        make.bottom.equalTo(self).offset(3);
//        make.right.equalTo(self).offset(3);
//    }];
    
    
}

- (void)reDrawViewWithPrice:(NSString *)string
{
    CGFloat width = [QuickControl widthForString:string andHeigh:100 Font:[UIFont systemFontOfSize:16]];
    
    CGRect frame = self.frame;
    frame.size.width = self.frame.size.width+width;
    [self setFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
