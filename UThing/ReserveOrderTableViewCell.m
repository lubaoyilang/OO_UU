//
//  ReserveOrderTableViewCell.m
//  UThing
//
//  Created by luyuda on 15/1/7.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "ReserveOrderTableViewCell.h"

#import "QBFlatButton.h"


#define BtnWidth    145
#define BtnHeight   25


@interface ReserveOrderTableViewCell ()


@property (nonatomic,strong)UIView *bg;
@property (nonatomic,strong)UILabel *orderNumLabel;
@property (nonatomic,strong)UILabel *isPayLabel;
@property (nonatomic,strong)UILabel *brandName;
@property (nonatomic,strong)UILabel *brandTime	;
@property (nonatomic,strong)UILabel *brandPopCount;
@property (nonatomic,strong)UILabel *brandMoneyTitle;
@property (nonatomic,strong)UILabel *brandMoneyDetail;
@property (nonatomic,strong)QBFlatButton *payBtn;
@property (nonatomic,strong)QBFlatButton *detailBtn;
@property (nonatomic,strong)NSDictionary *infoDict;


@end


@implementation ReserveOrderTableViewCell
@synthesize delegate;




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellh
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, cellh-1)];
        _bg.backgroundColor = [UIColor whiteColor];
        
        _orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kMainScreenWidth-60, 30)];
        _orderNumLabel.text = [NSString stringWithFormat:@"预订单号: %@",@""];
        _orderNumLabel.font = [UIFont systemFontOfSize:14];
        _orderNumLabel.textColor = RGBCOLOR(136, 136, 136);
        _orderNumLabel.backgroundColor = [UIColor clearColor];
        [_bg addSubview:_orderNumLabel];
        
        _isPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-50, 10, 40, 20)];
        
        _isPayLabel.backgroundColor = [UIColor orangeColor];
        _isPayLabel.font = [UIFont systemFontOfSize:12];
        _isPayLabel.textColor = [UIColor whiteColor];
        _isPayLabel.textAlignment = NSTextAlignmentCenter;
        _isPayLabel.text = @"支付";
        [_bg addSubview:_isPayLabel];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 36, kMainScreenWidth, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_bg addSubview:line];
        
        
        _brandName = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, kMainScreenWidth-20, 20)];
        
        _brandName.backgroundColor = [UIColor clearColor];
        _brandName.font = [UIFont systemFontOfSize:12];
        _brandName.textColor = RGBCOLOR(136, 136, 136);
        _brandName.text = [NSString stringWithFormat:@"产品名称: %@",@""];
        [_bg addSubview:_brandName];
        
        
        
        
        _brandMoneyTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 60, 20)];
        
        _brandMoneyTitle.backgroundColor = [UIColor clearColor];
        _brandMoneyTitle.font = [UIFont systemFontOfSize:12];
        _brandMoneyTitle.textColor = RGBCOLOR(136, 136, 136);
        _brandMoneyTitle.text = @"订单金额: ";
        [_bg addSubview:_brandMoneyTitle];
        
        
        
        _brandMoneyDetail = [[UILabel alloc] initWithFrame:CGRectMake(70, 65, kMainScreenWidth-20-70, 20)];
        
        _brandMoneyDetail.backgroundColor = [UIColor clearColor];
        _brandMoneyDetail.font = [UIFont systemFontOfSize:12];
        _brandMoneyDetail.textColor = [UIColor colorFromHexRGB:@"ff6633"];
        _brandMoneyDetail.text = @"";
        [_bg addSubview:_brandMoneyDetail];
        
        [self addSubview:_bg];
        
        float wOff= (kMainScreenWidth-20-BtnWidth-BtnWidth)/2.0;
        
        
        
        [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
        [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
        
        
        _payBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        _payBtn.frame = CGRectMake(10, 90, BtnWidth, BtnHeight);
        _payBtn.faceColor =[UIColor colorWithRed:244.0/255.0 green:135.0/255.0 blue:12.0/255.0 alpha:1.0];
        _payBtn.sideColor = [UIColor colorWithRed:203.0/255.0 green:87.0/255.0 blue:0.0/255.0 alpha:1.0];
        _payBtn.radius = 0.0;
        _payBtn.margin = 0.0;
        _payBtn.depth = 2.0;
        _payBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [_payBtn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
        [_bg addSubview:_payBtn];
        
        
        
        _detailBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        _detailBtn.frame = CGRectMake(10+wOff+BtnWidth, 90, BtnWidth, BtnHeight);
        _detailBtn.faceColor =[UIColor whiteColor];
        _detailBtn.sideColor = [UIColor colorWithRed:203.0/255.0 green:87.0/255.0 blue:0.0/255.0 alpha:1.0];
        _detailBtn.radius = 0.0;
        _detailBtn.margin = 0.0;
        _detailBtn.depth = 2.0;
        [_detailBtn.layer setBorderWidth:1];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 237/255.0, 237/255.0, 237/255.0, 1 });
        
        [_detailBtn.layer setBorderColor:colorref];
        _detailBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_detailBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_detailBtn setTitle:@"点击查看预订单详情" forState:UIControlStateNormal];
        [_detailBtn addTarget:self action:@selector(goBlandDetail) forControlEvents:UIControlEventTouchUpInside];
        [_bg addSubview:_detailBtn];
        
        
        
        UIView *blodLine = [[UIView alloc] initWithFrame:CGRectMake(0, cellh-5, kMainScreenWidth, 5)];
        blodLine.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [_bg addSubview:blodLine];
        
        
        
        
    }
    return self;
}




- (void)refreshViewWithObject:(NSDictionary*)dict
{
    _infoDict = dict;
    
    NSString *title = [dict objectForKey:@"product_name"];
    _brandName.text = [NSString stringWithFormat:@"产品名称: %@",title];
    _orderNumLabel.text = [NSString stringWithFormat:@"订单号: %@",[dict objectForKey:@"id"]];
    //NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"trip_time"] doubleValue]];
    
    //_brandTime.text = [NSString stringWithFormat:@"出行时间: %@",[date stringWithFormat:NSDATE_FORMAT_DATE]];
    //_brandPopCount.text = [NSString stringWithFormat:@"出行人数: %@",[dict objectForKey:@"people_no"]];
    NSString *pri = [NSString moneyFromThousand:[dict objectForKey:@"price"]];
    _brandMoneyDetail.text = [NSString stringWithFormat:@"￥%@",pri];
    
    float wOff= (kMainScreenWidth-20-BtnWidth-BtnWidth);
    
    int status = [[dict objectForKey:@"status"] intValue]; //1下单未支付2下单取消3超时未支付4已支付
    
    switch (status) {
        case 0:
        {
            NSString *str = @"下单未支付";
            float W = [QuickControl widthForString:str andHeigh:_isPayLabel.height Font:_isPayLabel.font];
            _isPayLabel.frame = CGRectMake(kMainScreenWidth-W-20, 10, W+10, 20);
            _isPayLabel.text = str;
            
            _payBtn.hidden = NO;
            _detailBtn.hidden = NO;
            _payBtn.frame = CGRectMake(10, 90, BtnWidth, BtnHeight);
            _detailBtn.frame =CGRectMake(10+wOff+BtnWidth, 90, BtnWidth, BtnHeight);
            
            break;
        }
        case 2:
        {
            NSString *str = @"下单取消";
            float W = [QuickControl widthForString:str andHeigh:_isPayLabel.height Font:_isPayLabel.font];
            _isPayLabel.frame = CGRectMake(kMainScreenWidth-W-20, 10, W+10, 20);
            _isPayLabel.text = str;
            
            float x= (kMainScreenWidth-BtnWidth)/2.0;
            _payBtn.hidden = YES;
            _detailBtn.hidden = NO;
            _detailBtn.frame =CGRectMake(x, 90, BtnWidth, BtnHeight);
            
            
            break;
        }
        case 1:
        {
            NSString *str = @"已支付";
            float W = [QuickControl widthForString:str andHeigh:_isPayLabel.height Font:_isPayLabel.font];
            _isPayLabel.frame = CGRectMake(kMainScreenWidth-W-20, 10, W+10, 20);
            _isPayLabel.text = str;
            
            
            float x= (kMainScreenWidth-BtnWidth)/2.0;
            _payBtn.hidden = YES;
            _detailBtn.hidden = NO;
            _detailBtn.frame =CGRectMake(x, 90, BtnWidth, BtnHeight);
            
            break;
        }
        default:
            break;
    }
    
    
}




- (void)goPay
{
    NSLog(@"gopay");
    if (delegate && [delegate respondsToSelector:@selector(clickPay:)]) {
        [delegate clickPay:_infoDict];
    }
    
    
}



- (void)goBlandDetail
{
    NSLog(@"checkBlandDetail");
    if (delegate && [delegate respondsToSelector:@selector(clickInfo:)]) {
        [delegate clickInfo:_infoDict];
    }
    
}






@end
