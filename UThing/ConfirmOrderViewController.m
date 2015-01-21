//
//  ConfirmOrderViewController.m
//  UThing
//
//  Created by Apple on 14/11/18.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "Umpay.h"
#import "UserInfoSingleton.h"
#import "JSONKit.h"
#import "IIViewDeckController.h"

#import "UserInfoSingleton.h"

#define GoPayHeight 30.0f




@interface ConfirmOrderViewController ()<UmpayDelegate>

@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UIView *orderInfoBackView;
@property (nonatomic, strong) UIView *passengerInfoBackView;
@property (nonatomic, strong) UIView *orderPeopleInfoBackView;
@property (nonatomic, strong) UIView *payWayBackView;
@property (nonatomic, strong) UIView *goPayView;

@property (nonatomic, strong) UIView *voucherView;
@property (nonatomic, strong) UIView *singleRoomView;

@property (nonatomic, strong) NSArray *nsArray;
@property (nonatomic, strong) NSMutableData *infoData;

@property (nonatomic, strong) NSURLConnection *payConn;
@property (nonatomic, strong) NSMutableData *payData;



@end

@implementation ConfirmOrderViewController
@synthesize productInfo;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    
    _nsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"",@"",@"",@"",@"",@""];
    
    
    [self downloadData];
    
    
}

- (void)downloadData
{
    if (!_orderId) {
        _orderId = [productInfo objectForKey:@"id"];
    }
    
    ParametersManagerObject *managerObject = [[ParametersManagerObject alloc] init];
    
    UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedInstance];
    //uid、authcode、nickname
    [managerObject addParamer:[NSString stringWithFormat:@"uid=%@", userInfoSingleton.userInfoModel.id]];
    [managerObject addParamer:[NSString stringWithFormat:@"id=%@", _orderId]];
    [managerObject addParamer:[NSString stringWithFormat:@"device=%@", @"ios"]];
    

    
    
    
    NSString* urlstr = [getOrderList stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *loginUrl = [NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[managerObject getAddParamer:[NSArray arrayWithObject:[NSString stringWithFormat:@"authcode=%@", userInfoSingleton.userInfoModel.authcode]]]];
    
    
    NSURLConnection *historyConn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if (historyConn) {
        _infoData = [[NSMutableData alloc] init];
        
        [self showHub:@"订单生成中"];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"警告"
                                                        message: @"不能连接到服务器,请检查您的网络"
                                                       delegate: nil
                                              cancelButtonTitle: @"确定"
                                              otherButtonTitles: nil];
        [alert show];
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == _payConn) {
        [_payData appendData:data];
    }
    else {
        [_infoData appendData:data];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"连接服务器超时,请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alow show];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == _payConn) {
        id dict = [_payData objectFromJSONData];
        
        NSLog(@"resultCode = %@", dict);
        
        NSString *resultCode = [dict objectForKey:@"result"];
        
        
        
        if ([resultCode isEqualToString:@"ok"]) {
            
            NSDictionary *listDict = [dict objectForKey:@"data"];
            NSString *sign = [dict objectForKey:@"sign"];
            
            ParametersManagerObject *p = [[ParametersManagerObject alloc] init];
            BOOL isSign = [p checkSign:listDict Sign:sign];
            
            if (isSign) {
                
                NSString *pay_id = [listDict objectForKey:@"trade_no"];
                if ([pay_id length]) {
                    [Umpay pay:pay_id payType:@"9" rootViewController:self delegate:self];
                }else{
                    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"警告" message:@"订单支付数据超时，请重新购买" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [al show];
                }
                
                
            }else{
                
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"警告" message:@"数据校验出错，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [al show];
                
            }
            
            
            
        }else{
            NSDictionary *data_dict = [dict objectForKey:@"data"];
            NSString *errorMsg = [data_dict objectForKey:@"msg"];
            
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"警告" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            
            
        }
        
        
        
        
        
        
        [self hideHub];
        
        
        
        
        
        

    }
    else {
        NSError *error1 = [[NSError alloc] init];
        NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:_infoData options:NSJSONReadingMutableContainers error:&error1];
        NSLog(@"rr = %@",resultsDictionary);
        
        if ([[resultsDictionary objectForKey:@"result"] isEqualToString:@"ok"]) {
            
            productInfo = nil;
            productInfo = [resultsDictionary objectForKey:@"data"];
            
            //存储修改的数据到单例类
            [self createBackScrollView];
            
            [self theOrderInfoView];
            
            [self passengerInfoView];
            
            [self theOrderPeopleInfoView];
            
            

            //判断是否使用代金券和单间差
            
            //使用代金券和有单间差
            if ([self isVoucherYesOrNo] && [self isSingleRoomPriceYesOrNo]) {
               
                //代金券
                [self creatVoucherView];
                
                //单间差
                [self createSingleRoomView];
                
            }
            //有代金券,没有单间差
            else if ([self isVoucherYesOrNo] && [self isSingleRoomPriceYesOrNo] == NO) {
                
                [self creatVoucherView];
            }
            //没有代金券,有单间差
            else if ([self isVoucherYesOrNo]==NO && [self isSingleRoomPriceYesOrNo]) {
                
                [self createSingleRoomView];
            }
            //没有代金券,有单间差
            else if ([self isVoucherYesOrNo]==NO && [self isSingleRoomPriceYesOrNo]==NO) {
                
            }
            
            
            
            
            
    
            [self thePayWayView];
            
            [self theGoPayView];
            
            _backScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, _goPayView.frame.origin.y+_goPayView.frame.size.height+20);


            
        }
        else{
            UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[[resultsDictionary objectForKey:@"data"] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alow show];
        }

        
        [self hideHub];
    }
    
}


/**
 *  判断是否使用代金券
 *
 *  @return YES Or NO
 */
- (BOOL)isVoucherYesOrNo
{
    
    NSLog(@"productInfo ======================= %@", [productInfo objectForKey:@"coupon_code"]);
    
    NSString *coupon_code = [productInfo objectForKey:@"coupon_code"];
    if ([[productInfo objectForKey:@"coupon_code"] isEqual:[NSNull null]] || coupon_code.length==0) {
        
        return NO;
    }
    
    return YES;
}

/**
 *  判断是否有单间差
 *
 *  @return YES Or NO
 */
- (BOOL)isSingleRoomPriceYesOrNo
{
    if ([[productInfo objectForKey:@"single_room_total"] floatValue]) {
        
        return YES;
    }
    
    return NO;
}

- (void)creatVoucherView
{
    _voucherView = [[UIView alloc] initWithFrame:CGRectMake(0, _orderPeopleInfoBackView.frame.origin.y+_orderPeopleInfoBackView.frame.size.height+10, kMainScreenWidth, 30)];
    _voucherView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel labelWithFrame:CGRectMake(5, 5, 100, 14) text:@"已使用"];
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:14];
    [_voucherView addSubview:label];
    
    
    UILabel *voucherPrice = [UILabel labelWithFrame:CGRectMake(label.frame.size.width+5, 5, 100, 30) text:[NSString stringWithFormat:@"¥ %@", [NSString moneyFromThousand:[productInfo objectForKey:@"coupon_price"]]]];
    voucherPrice.textColor = [UIColor orangeColor];
    voucherPrice.font = [UIFont systemFontOfSize:14];
    [voucherPrice sizeToFit];
    [_voucherView addSubview:voucherPrice];
    
    
    UILabel *voucherLabel = [UILabel labelWithFrame:CGRectMake(voucherPrice.frame.origin.x+voucherPrice.frame.size.width+5, 0, 100, 30) text:@"代金券"];
    voucherLabel.font = [UIFont systemFontOfSize:14];
    [_voucherView addSubview:voucherLabel];
    
    
    [self.backScrollView addSubview:_voucherView];
}

/**
 *  单间差
 */
- (void)createSingleRoomView
{
    
    _singleRoomView = [[UIView alloc] initWithFrame:CGRectMake(0, _orderPeopleInfoBackView.frame.origin.y+_orderPeopleInfoBackView.frame.size.height+10, kMainScreenWidth, 30)];
    
    if ([self isVoucherYesOrNo]) {
        [_singleRoomView setFrame:CGRectMake(0, _voucherView.frame.origin.y+30+10, kMainScreenWidth, 30)];
    }
    
    _singleRoomView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel labelWithFrame:CGRectMake(5, 6, 100, 14) text:@"含单间差："];
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    [_singleRoomView addSubview:label];
    
    UILabel *price = [UILabel labelWithFrame:CGRectMake(label.frame.size.width, 0, 100, 30) text:[NSString stringWithFormat:@"¥ %@", [NSString moneyFromThousand:[productInfo objectForKey:@"single_room_total"]]]];
    price.font = [UIFont systemFontOfSize:14];
    price.textColor = [UIColor orangeColor];
    [_singleRoomView addSubview:price];
    
    [self.backScrollView addSubview:_singleRoomView];
}

//tabBar返回按钮 返回按钮点击事件
- (void)backToTheLastViewController:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ==ScrollView==
- (void)createBackScrollView
{
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backView.image = [UIImage imageNamed:@"list-bg.png"];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [backView addSubview:_backScrollView];
}

#pragma mark ==Order Info View==
- (void)theOrderInfoView
{
    _orderInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 105)];
    [_orderInfoBackView addSubview:[self titleViewWithIcon:@"app-填写完成_支付_03" title:@"订单详情"]];
    _orderPeopleInfoBackView.userInteractionEnabled = YES;
    _orderInfoBackView.backgroundColor = [UIColor whiteColor];
    
    //
    UIView *priceBackView = [[UIView alloc] init];
    priceBackView.backgroundColor = [UIColor whiteColor];
    priceBackView.alpha = .9;
    
    UILabel *label = [UILabel labelWithFrame:CGRectMake(3, 5, 5, 16) text:@"￥"];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorFromHexRGB:@"ee8f00"];
    [label sizeToFit];
    [priceBackView addSubview:label];
    
    UILabel *priceLabel = [UILabel labelWithFrame:CGRectMake(15, 1.5, 100, 22) text:@"399"];
    priceLabel.font = [UIFont boldSystemFontOfSize:16];
    priceLabel.text = [NSString moneyFromThousand:[productInfo objectForKey:@"price"]];
    [priceLabel sizeToFit];
    priceLabel.textColor = [UIColor colorFromHexRGB:@"ee8f00"];
    [priceBackView addSubview:priceLabel];
    
    UILabel *leftUnitLabel = [UILabel labelWithFrame:CGRectMake(15+priceLabel.bounds.size.width+3, 5, 7, 16) text:@""];
    leftUnitLabel.font = [UIFont systemFontOfSize:12];
    [leftUnitLabel sizeToFit];
    leftUnitLabel.textColor = [UIColor colorFromHexRGB:@"ee8f00"];
    [priceBackView addSubview:leftUnitLabel];
    
    CGFloat w = 15+priceLabel.bounds.size.width+3+leftUnitLabel.bounds.size.width;
    priceBackView.frame = CGRectMake(kMainScreenWidth-w-20, 6, w, 22);
    
    [_orderInfoBackView addSubview:priceBackView];
    
    [_backScrollView addSubview:_orderInfoBackView];
    
    UILabel *orderNumber = [UILabel labelWithFrame:CGRectMake(0, 40, self.view.bounds.size.width*0.35, 20) text:@"订单号:" textColor:nil font:[UIFont systemFontOfSize:12]];
    orderNumber.textAlignment = NSTextAlignmentRight;
    [_orderInfoBackView addSubview:orderNumber];
    
    UILabel *orderNumberLabel = [UILabel labelWithFrame:CGRectMake(self.view.bounds.size.width*0.4, 40, self.view.bounds.size.width*0.5, 20) text:[productInfo objectForKey:@"id"] textColor:nil font:[UIFont systemFontOfSize:12]];
    orderNumberLabel.textAlignment = NSTextAlignmentLeft;
    [_orderInfoBackView addSubview:orderNumberLabel];
    
    UILabel *productName = [UILabel labelWithFrame:CGRectMake(0, 60, self.view.bounds.size.width*0.35, 20) text:@"产品名称:" textColor:nil font:[UIFont systemFontOfSize:12]];
    productName.textAlignment = NSTextAlignmentRight;
    [_orderInfoBackView addSubview:productName];
    
    UILabel *productNameLabel = [UILabel labelWithFrame:CGRectMake(self.view.bounds.size.width*0.4, 60, self.view.bounds.size.width*0.5, 20) text:[productInfo objectForKey:@"product_name"] textColor:nil font:[UIFont systemFontOfSize:12]];
    productNameLabel.textAlignment = NSTextAlignmentLeft;
    productNameLabel.text = [productInfo objectForKey:@"product_name"];
    [_orderInfoBackView addSubview:productNameLabel];
    
    
    NSString *string = [productInfo objectForKey:@"trip_time"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[string longLongValue]];

    NSString *dateString = [date stringWithFormat:@"yyyy-MM-dd" locale:LOCALE_CHINA];
    
    
    UILabel *tripTime = [UILabel labelWithFrame:CGRectMake(0, 80, self.view.bounds.size.width*0.35, 20) text:@"出行时间:" textColor:nil font:[UIFont systemFontOfSize:12]];
    tripTime.textAlignment = NSTextAlignmentRight;
    [_orderInfoBackView addSubview:tripTime];
    
    UILabel *tripTimeLabel = [UILabel labelWithFrame:CGRectMake(self.view.bounds.size.width*0.4, 80, self.view.bounds.size.width*0.5, 20) text:dateString textColor:nil font:[UIFont systemFontOfSize:12]];
    tripTimeLabel.textAlignment = NSTextAlignmentLeft;
    [_orderInfoBackView addSubview:tripTimeLabel];
}

#pragma mark == Passenger Info View ==
- (void)passengerInfoView
{
    _passengerInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _orderInfoBackView.frame.origin.y+_orderInfoBackView.frame.size.height+10, self.view.bounds.size.width, 30+[[productInfo objectForKey:@"people_no"] intValue]*160)];
    _passengerInfoBackView.userInteractionEnabled = YES;
    [_backScrollView addSubview:_passengerInfoBackView];
    
    UIView *view = [self titleViewWithIcon:@"app-订单填写_passenger" title:@"旅客信息"];
    [_passengerInfoBackView addSubview:view];
    
    [self addPassengerInfoView];
}

- (void)addPassengerInfoView
{
    int people_no = [[productInfo objectForKey:@"people_no"] intValue];
    if (people_no <= 2) {

        for (int i=0; i<people_no; i++) {
            [_passengerInfoBackView addSubview:[self singlePassengerInfoViewWith:i]];
        }
        
        [_passengerInfoBackView setFrame:CGRectMake(0, _orderInfoBackView.frame.origin.y+_orderInfoBackView.frame.size.height+10, self.view.bounds.size.width, 30+people_no*160)];
    }
    
    //
    if (people_no > 2) {

        for (int i=0; i<2; i++) {
            [_passengerInfoBackView addSubview:[self singlePassengerInfoViewWith:i]];
        }
        
        [_passengerInfoBackView addSubview:[self checkAllPassengerInfoBtnView]];
        
        [_passengerInfoBackView setFrame:CGRectMake(0, _orderInfoBackView.frame.origin.y+_orderInfoBackView.frame.size.height+10, self.view.bounds.size.width, 30+2*160+40)];
    }
}

#pragma mark ==check More==
- (UIView *)checkAllPassengerInfoBtnView
{
    UIView *allView = [[UIView alloc] initWithFrame:CGRectMake(0, 30+320, self.view.bounds.size.width, 40)];
    allView.userInteractionEnabled = YES;
    allView.backgroundColor = [UIColor whiteColor];
    
    UIButton *checkMoreBtn = [UIButton buttonWithFrame:CGRectMake(10, 1, self.view.bounds.size.width-20, 30) title:@"查看所有旅客信息" image:nil target:self action:@selector(checkMoreBtn)];
    checkMoreBtn.layer.borderWidth = 1;
    checkMoreBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [allView addSubview:checkMoreBtn];
    
    return allView;
}

- (void)checkMoreBtn
{
    int people_no = [[productInfo objectForKey:@"people_no"] intValue];
    for (int i=2; i<people_no; i++) {
        [_passengerInfoBackView addSubview:[self singlePassengerInfoViewWith:i]];
    }
    
    [self setFrame];
}

- (void)setFrame
{
    [UIView animateWithDuration:0.3 animations:^{
        [_passengerInfoBackView setFrame:CGRectMake(0, _orderInfoBackView.frame.origin.y+_orderInfoBackView.frame.size.height+15, self.view.bounds.size.width, 30+[[productInfo objectForKey:@"people_no"] intValue]*160)];
        
        
        [_orderPeopleInfoBackView setFrame:CGRectMake(0, _passengerInfoBackView.frame.origin.y+_passengerInfoBackView.bounds.size.height+10, self.view.bounds.size.width, 105)];
        
        
        
        //有代金券,有单间差
        if ([self isVoucherYesOrNo] && [self isSingleRoomPriceYesOrNo]) {
            
            [_voucherView setFrame:CGRectMake(0, _orderPeopleInfoBackView.frame.origin.y+_orderPeopleInfoBackView.frame.size.height+10, kMainScreenWidth, 30)];
            
            [_singleRoomView setFrame:CGRectMake(0, _voucherView.frame.origin.y+30+10, kMainScreenWidth, 30)];
            
            _payWayBackView.frame = CGRectMake(0, _singleRoomView.frame.origin.y+_singleRoomView.bounds.size.height+10, self.view.bounds.size.width, 80);
            
        }
        //有代金券,没有单间差
        else if ([self isVoucherYesOrNo] && ![self isSingleRoomPriceYesOrNo]) {
            
            [_voucherView setFrame:CGRectMake(0, _orderPeopleInfoBackView.frame.origin.y+_orderPeopleInfoBackView.frame.size.height+10, kMainScreenWidth, 30)];
            
            _payWayBackView.frame = CGRectMake(0, _voucherView.frame.origin.y+_voucherView.bounds.size.height+10, self.view.bounds.size.width, 80);
        }
        //没有代金券,有单间差
        else if (![self isVoucherYesOrNo] && [self isSingleRoomPriceYesOrNo]) {
            
            [_singleRoomView setFrame:CGRectMake(0, _orderPeopleInfoBackView.frame.origin.y+_orderPeopleInfoBackView.frame.size.height+10, kMainScreenWidth, 30)];
            
            _payWayBackView.frame = CGRectMake(0, _singleRoomView.frame.origin.y+_singleRoomView.bounds.size.height+10, self.view.bounds.size.width, 80);
        }
        //没有代金券,没有单间差
        else if (![self isVoucherYesOrNo] && ![self isSingleRoomPriceYesOrNo]) {
            
            _payWayBackView.frame = CGRectMake(0, _orderPeopleInfoBackView.frame.origin.y+_orderPeopleInfoBackView.bounds.size.height+10, self.view.bounds.size.width, 80);
        }
        
    
        [_goPayView setFrame:CGRectMake(0, _payWayBackView.frame.origin.y+_payWayBackView.bounds.size.height+10, self.view.bounds.size.width, GoPayHeight)];
        
        _backScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, _goPayView.frame.origin.y+_goPayView.frame.size.height+20);

        
    }];
    
}


/**
 *  每项头部视图  如 "icon 订单详情"
 *
 *  @param imageName icon图片名字
 *  @param title     标题
 *
 *  @return 头部title视图view
 */
- (UIView *)titleViewWithIcon:(NSString *)imageName title:(NSString *)title
{
    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    titleBackView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    iconView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
    [titleBackView addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 29)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleBackView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"6c554f"];
    [titleBackView addSubview:lineView];
    
    return titleBackView;
}

/**
 *  单个旅客信息
 *
 *  @param index 第几位旅客
 *
 *  @return 单个旅客信息界面
 */
- (UIView *)singlePassengerInfoViewWith:(NSInteger)index
{
    //取到用户信息
    NSDictionary *guestDict = [productInfo objectForKey:@"guest_info"];
    NSDictionary *singleGuestDict = [guestDict objectForKey:[NSString stringWithFormat:@"%i",index+1]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 31+(160)*index, self.view.bounds.size.width, 160)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, self.view.bounds.size.width*.25, 6)];
    leftView.image = [[UIImage imageNamed:@"app-订单填写_02.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [view addSubview:leftView];
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*.75, 15, self.view.bounds.size.width*.25, 6)];
    rightView.image = [[UIImage imageNamed:@"app-订单填写_04.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [view addSubview:rightView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"第%d位旅客", index+1];
    [titleLabel sizeToFit];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.bounds.size.width, 0, 70, 25)];
    [subTitleLabel sizeToFit];
    subTitleLabel.font = [UIFont systemFontOfSize:13];
    subTitleLabel.textColor = [UIColor lightGrayColor];
    [titleView addSubview:subTitleLabel];
    
    
    [titleView setFrame:CGRectMake(0, 0, titleLabel.bounds.size.width+subTitleLabel.bounds.size.width, 30)];
    titleView.center = CGPointMake(self.view.bounds.size.width/2, 25);
    [view addSubview:titleView];
    
    NSArray *singlePassengerInfoArr = [[_orderInfoArr objectAtIndex:0] objectAtIndex:index];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width*0.4, 25)];
    nameLabel.text = @"姓名：";
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:nameLabel];
    
    UILabel *name = [UILabel labelWithFrame:CGRectMake(self.view.bounds.size.width*0.4, 40, self.view.bounds.size.width*0.6, 25) text:singlePassengerInfoArr[0] textColor:nil font:[UIFont systemFontOfSize:12]];
    name.text = [singleGuestDict objectForKey:@"name"];
    [view addSubview:name];
    
    UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width*0.4, 25)];
    genderLabel.text = @"性别：";
    genderLabel.font = [UIFont systemFontOfSize:12];
    genderLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:genderLabel];
    
    UILabel *gender = [UILabel labelWithFrame:CGRectMake(self.view.bounds.size.width*0.4, 60, self.view.bounds.size.width*0.4, 25) text:singlePassengerInfoArr[1] textColor:nil font:[UIFont systemFontOfSize:12]];
    gender.text = [singleGuestDict objectForKey:@"sex"];
    [view addSubview:gender];
    
    UILabel *credentialLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width*0.4, 25)];
    credentialLabel.text = @"证件类型：";
    credentialLabel.font = [UIFont systemFontOfSize:12];
    credentialLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:credentialLabel];
    
    UILabel *credential = [UILabel labelWithFrame:CGRectMake(self.view.bounds.size.width*0.4, 80, self.view.bounds.size.width*0.4, 25) text:singlePassengerInfoArr[1] textColor:nil font:[UIFont systemFontOfSize:12]];
    credential.text = [singleGuestDict objectForKey:@"credential"];
    [view addSubview:credential];
    
    UILabel *documentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width*0.4, 25)];
    documentNumLabel.text = @"证件号码：";
    documentNumLabel.font = [UIFont systemFontOfSize:12];
    documentNumLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:documentNumLabel];
    
    UILabel *documentNum = [UILabel labelWithFrame:CGRectMake(self.view.bounds.size.width*0.4, 100, self.view.bounds.size.width*0.6, 25) text:singlePassengerInfoArr[3] textColor:nil font:[UIFont systemFontOfSize:12]];
    documentNum.text = [singleGuestDict objectForKey:@"id"];
    [view addSubview:documentNum];
    
    UILabel *contactNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, self.view.bounds.size.width*0.4, 25)];
    contactNumberLabel.text = @"联系电话：";
    contactNumberLabel.font = [UIFont systemFontOfSize:12];
    contactNumberLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:contactNumberLabel];
    
    UILabel *contactNumber = [UILabel labelWithFrame:CGRectMake(self.view.bounds.size.width*0.4, 120, self.view.bounds.size.width*0.4, 25) text:singlePassengerInfoArr[4] textColor:nil font:[UIFont systemFontOfSize:12]];
    contactNumber.text = [singleGuestDict objectForKey:@"mobile"];
    [view addSubview:contactNumber];

    return view;
}

#pragma mark ==Book People Info View==
/**
 *  预订人信息
 */
- (void)theOrderPeopleInfoView
{
    _orderPeopleInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _passengerInfoBackView.frame.origin.y+_passengerInfoBackView.bounds.size.height+10, self.view.bounds.size.width, 105)];
    _orderPeopleInfoBackView.backgroundColor = [UIColor whiteColor];
    _orderPeopleInfoBackView.userInteractionEnabled = YES;
    [_backScrollView addSubview:_orderPeopleInfoBackView];
    
    [_orderPeopleInfoBackView addSubview:[self titleViewWithIcon:@"app-订单填写_10" title:@"预订人信息"]];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.view.bounds.size.width*0.35, 25)];
    nameLabel.text = @"姓名：";
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [_orderPeopleInfoBackView addSubview:nameLabel];
    
    NSArray *orderPeopleInfoArr = [_orderInfoArr objectAtIndex:1];
    
    UILabel *name = [UILabel labelWithFrame:CGRectMake(self.view.bounds.size.width*0.35, 35, self.view.bounds.size.width*0.4, 25) text:orderPeopleInfoArr[0] textColor:nil font:[UIFont systemFontOfSize:12]];
    name.text = [productInfo objectForKey:@"contact_name"];
    [_orderPeopleInfoBackView addSubview:name];
    
    UILabel *contactNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, self.view.bounds.size.width*0.35, 25)];
    contactNumberLabel.text = @"联系电话：";
    contactNumberLabel.font = [UIFont systemFontOfSize:12];
    contactNumberLabel.textAlignment = NSTextAlignmentRight;
    [_orderPeopleInfoBackView addSubview:contactNumberLabel];
    
    UILabel *contactNumber = [UILabel labelWithFrame:CGRectMake(self.view.bounds.size.width*0.35, 55, self.view.bounds.size.width*0.4, 25) text:orderPeopleInfoArr[1] textColor:nil font:[UIFont systemFontOfSize:12]];
    contactNumber.text = [productInfo objectForKey:@"contact_mobil"];
    [_orderPeopleInfoBackView addSubview:contactNumber];
    
    UILabel *EmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, self.view.bounds.size.width*0.35, 25)];
    EmailLabel.text = @"Email：";
    EmailLabel.font = [UIFont systemFontOfSize:12];
    EmailLabel.textAlignment = NSTextAlignmentRight;
    [_orderPeopleInfoBackView addSubview:EmailLabel];
    
    UILabel *Email = [UILabel labelWithFrame:CGRectMake(self.view.bounds.size.width*0.35, 75, self.view.bounds.size.width*0.6, 25) text:orderPeopleInfoArr[2] textColor:nil font:[UIFont systemFontOfSize:12]];
    Email.text = [productInfo objectForKey:@"contact_email"];
    [_orderPeopleInfoBackView addSubview:Email];
    

}

#pragma mark ==The Pay Way==
- (void)thePayWayView
{
    _payWayBackView = [[UIView alloc] init];
    
    //有单间差
    if ([self isSingleRoomPriceYesOrNo]) {
        
        _payWayBackView.frame = CGRectMake(0, _singleRoomView.frame.origin.y+_singleRoomView.bounds.size.height+10, self.view.bounds.size.width, 80);
        
    }
    //有代金券,没有单间差
    else if ([self isVoucherYesOrNo] && ![self isSingleRoomPriceYesOrNo]) {
        
        _payWayBackView.frame = CGRectMake(0, _voucherView.frame.origin.y+_voucherView.bounds.size.height+10, self.view.bounds.size.width, 80);
    }

    //没有代金券,没有单间差
    else if (![self isVoucherYesOrNo] && ![self isSingleRoomPriceYesOrNo]) {
        
        _payWayBackView.frame = CGRectMake(0, _orderPeopleInfoBackView.frame.origin.y+_orderPeopleInfoBackView.bounds.size.height+10, self.view.bounds.size.width, 80);
    }
    
    
    
    //支付方式标题视图
    
    _payWayBackView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:_payWayBackView];
    
    UIView *titleView = [self titleViewWithIcon:@"app-填写完成_支付_10" title:@"支付方式"];


    //判断是否是工行专属
    if ([[productInfo objectForKey:@"is_icbc"] intValue] == 1) {
        UILabel *icbcLabel = [UILabel labelWithFrame:CGRectMake(100, 0, kMainScreenWidth-100, 30) text:@"(此产品将跳转网页进行支付)"];
        icbcLabel.font = [UIFont systemFontOfSize:12];
        [titleView addSubview:icbcLabel];
    }
    
    [_payWayBackView addSubview:titleView];
    
    
    //U付按钮
    UIButton *payWayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payWayButton.frame = CGRectMake(10, 38, _payWayBackView.bounds.size.width-20, 35);
    
    payWayButton.selected = YES;
    
    payWayButton.layer.borderWidth = 1;
    payWayButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [payWayButton addTarget:self action:@selector(payWayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
      //加入图片和标题
    UIView *buttonView = [[UIView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 22)];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
   

    //工商银行
    if ([[productInfo objectForKey:@"is_icbc"] intValue] == 1) {
        
        [imageView setFrame:CGRectMake(0, 0, 80, 22)];
        imageView.image = LOADIMAGE(@"icbc", @"png");
        
        [label setFrame:CGRectMake(80, 0, 120, 22)];
        label.text = @"工行信用卡支付";
        [buttonView setFrame:CGRectMake(0, 0, 200, 22)];
    }
    //京东白条
    else if ([[productInfo objectForKey:@"pay_type"] intValue] == 10002){
        [imageView setFrame:CGRectMake(0, 0, 65, 22)];
        imageView.image = LOADIMAGE(@"旅游白条小logo", @"png");
        
        [label setFrame:CGRectMake(68, 0, 60, 22)];
        label.text = @"京东白条";
        
        [buttonView setFrame:CGRectMake(0, 0, 105, 22)];
    }
    //U付支付
    else if ([[productInfo objectForKey:@"pay_type"] intValue] == 10000 || [[productInfo objectForKey:@"pay_type"] intValue] == 0) {
        
        [imageView setFrame:CGRectMake(0, 0, 45, 22)];
        imageView.image = LOADIMAGE(@"U付", @"png");
        
        [label setFrame:CGRectMake(45, 0, 60, 22)];
        label.text = @"U付支付";
        
        [buttonView setFrame:CGRectMake(0, 0, 105, 22)];
    }
    //支付宝
    else if ([[productInfo objectForKey:@"pay_type"] intValue] == 6) {
        
        [imageView setFrame:CGRectMake(0, 0, 55, 22)];
        imageView.image = LOADIMAGE(@"支付宝", @"png");
        
        [label setFrame:CGRectMake(55, 0, 70, 22)];
        label.text = @"支付宝支付";
        
        [buttonView setFrame:CGRectMake(0, 0, 105, 22)];
    }
    
    
    
    [buttonView addSubview:imageView];
    [buttonView addSubview:label];
  
    
    buttonView.center = CGPointMake(payWayButton.frame.size.width/2, payWayButton.frame.size.height/2);
    
    [payWayButton addSubview:buttonView];
    
    [_payWayBackView addSubview:payWayButton];
    
}

//支付方式按钮点击事件
- (void)payWayButtonClick:(UIButton *)button
{

}

#pragma mark ==go Pay View==
- (void)theGoPayView
{
    _goPayView = [[UIView alloc] initWithFrame:CGRectMake(0, _payWayBackView.frame.origin.y+_payWayBackView.bounds.size.height+10, self.view.bounds.size.width, GoPayHeight)];
    _goPayView.userInteractionEnabled = YES;
    _goPayView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:_goPayView];
    
    
    UIButton *cellphoneBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, GoPayHeight, GoPayHeight) title:nil image:@"" target:self action:@selector(cellphoneClick:)];
    
    UIImageView *imageView = [UIImageView imageViewWithFrame:CGRectMake(0,0, 20, 20) image:@"app-详情页_41"];
    imageView.center = CGPointMake(cellphoneBtn.bounds.size.width/2, cellphoneBtn.bounds.size.height/2);
    [cellphoneBtn addSubview:imageView];
    
    [_goPayView addSubview:cellphoneBtn];
    
    
    //line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(GoPayHeight, 0, 1, GoPayHeight)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_goPayView addSubview:lineView];
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, 0, self.view.bounds.size.width-80-1-25, GoPayHeight)];

    priceLabel.text = [NSString stringWithFormat:@"¥ %@",[NSString moneyFromThousand:[productInfo objectForKey:@"price"]]];
    priceLabel.textColor = [UIColor orangeColor];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [_goPayView addSubview:priceLabel];
    
    UIButton *goPayBtn = [UIButton buttonWithFrame:CGRectMake(self.view.bounds.size.width-80, 0, 80, GoPayHeight) title:@"去支付" image:nil target:self action:@selector(gopayClick:)];
    [goPayBtn setBackgroundColor:[UIColor orangeColor]];
    [goPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        goPayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    switch ([[productInfo objectForKey:@"status"] intValue]) {
        case 1:{
            [goPayBtn setTitle:@"去支付" forState:UIControlStateNormal];
            goPayBtn.enabled = YES;
            break;
        }
        case 2:{
            [goPayBtn setTitle:@"已取消" forState:UIControlStateNormal];
            goPayBtn.backgroundColor = [UIColor lightGrayColor];
            goPayBtn.enabled = NO;
            break;
        }
        case 3:{
            [goPayBtn setTitle:@"超时未支付" forState:UIControlStateNormal];
            goPayBtn.backgroundColor = [UIColor lightGrayColor];
            goPayBtn.enabled = NO;
            break;
        }
        case 4:{
            [goPayBtn setTitle:@"已支付" forState:UIControlStateNormal];
            goPayBtn.backgroundColor = [UIColor lightGrayColor];
            goPayBtn.enabled = NO;
            break;
        }
            
            
        default:
            break;
    };
    
    
    
    

    [_goPayView addSubview:goPayBtn];
}
- (void)cellphoneClick:(UIButton *)btn
{
    
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要拨打客服电话吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    al.tag = 8991;
    [al show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 8991) {
        if (buttonIndex == 1) {
            
            NSString *phone = [UserInfoSingleton sharedInstance].phone;
            if ([phone length]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
                
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000798790"]];
             
                
            }
        }
        
    }
    
    
}


- (void)gopayClick:(UIButton *)btn
{
    //判断是否是工行支付
    if ([[productInfo objectForKey:@"is_icbc"] intValue] == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[productInfo objectForKey:@"link"]]];
        
    }
    else {
        id pay_id = [productInfo objectForKey:@"pay_order_id"];
        
        
        if (![pay_id isKindOfClass:[NSNull class]]) {
            
            if ([pay_id length]) {
                [Umpay pay:pay_id payType:@"9" rootViewController:self delegate:self];
            }
            
        }
        else{
            
            
            NSLog(@"dict = %@",productInfo);
            
            ParametersManagerObject *pObject = [[ParametersManagerObject alloc] init];
            
            
            
            NSString *paymentid =[NSString stringWithFormat:@"paymentid=%@",@"10000"] ; //key = password
            [pObject addParamer:paymentid];
            NSString *orderid = [NSString stringWithFormat:@"orderid=%@",[productInfo objectForKey:@"id"]];
            [pObject addParamer:orderid];
            NSString *total_fee = [NSString stringWithFormat:@"total_fee=%@",[productInfo objectForKey:@"price"]];
            [pObject addParamer:total_fee];
            
            NSString *it_b_pay = [NSString stringWithFormat:@"it_b_pay=%@",[productInfo objectForKey:@"time_out"]];
            [pObject addParamer:it_b_pay];
            NSString *order_creattime = [NSString stringWithFormat:@"order_creattime=%@",[productInfo objectForKey:@"create_time"]];
            [pObject addParamer:order_creattime];
            
            UserInfoSingleton *uInfo =[UserInfoSingleton sharedInstance];
            
            
            NSString *uuuid =[NSString stringWithFormat:@"uid=%@",uInfo.userInfoModel.id] ; //key = password
            
            
            [pObject addParamer:uuuid];
            
            
            
            NSString* urlstr = [getPayIdURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *loginUrl = [NSURL URLWithString:urlstr];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[pObject getHeetBody]];
            
            NSLog(@"pars = %@",[pObject getParamersWithSign]);
            _payConn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            
            if (_payConn) {
                
                _payData = [[NSMutableData alloc] initWithData:nil];
                
                [self showHub:@"订单生成中"];
                
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"警告"
                                                                message: @"不能连接到服务器,请检查您的网络"
                                                               delegate: nil
                                                      cancelButtonTitle: @"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }
            
            
            
            
            
            
            
        }

    }
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self changeMenu:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self changeMenu:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - payDelegate
- (void)onPayResult:(NSString*)orderId resultCode:(NSString*)resultCode resultMessage:(NSString*)resultMessage
{
    if ([resultCode isEqualToString:@"0000"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
                                                        message: @"支付成功,订单详情请去我的订单查看"
                                                       delegate: nil
                                              cancelButtonTitle: @"确定"
                                              otherButtonTitles: nil];
        [alert show];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
                                                        message: @"支付失败"
                                                       delegate: nil
                                              cancelButtonTitle: @"确定"
                                              otherButtonTitles: nil];
        [alert show];
        
    }
}

#pragma mark - NSURLConn Delegate











/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
