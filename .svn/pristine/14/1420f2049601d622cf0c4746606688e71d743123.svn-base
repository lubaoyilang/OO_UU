//
//  MyOrderFillInViewController.m
//  UThing
//
//  Created by Apple on 14/11/17.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "MyOrderFillInViewController.h"

#import "ConfirmOrderViewController.h"
#import "MyOrderFillInView.h"
#import "UserInfoSingleton.h"

@interface MyOrderFillInViewController ()<MyOrderFillInViewDelegate, UIAlertViewDelegate>

//@property (nonatomic, strong) NSMutableArray *orderInfoArr;
@property (nonatomic, strong) NSMutableDictionary *collectProductInfo;
@property (nonatomic, strong) NSMutableData *orderData;
@property (nonatomic, strong) UIAlertView *orderAl;
@property (nonatomic, strong) NSDictionary *resultDict;


@property (nonatomic, strong) NSString *productString;

@end

@implementation MyOrderFillInViewController

@synthesize productDict,tripTime,roomNum,single_room_Price;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单填写";
    self.hidesBottomBarWhenPushed = YES;
    
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    
    //
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:tripTime forKey:@"tripTime"];
    [dict setValue:_adultNum forKey:@"adultNum"];
    [dict setValue:_childNum forKey:@"childNum"];
    
    MyOrderFillInView *myOrderFillInView = [[MyOrderFillInView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) productInfo:dict];
    myOrderFillInView.m_delegate = self;
    [self.view addSubview:myOrderFillInView];
    
}
//tabBar返回按钮 返回按钮点击事件
- (void)backToTheLastViewController:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  提交按钮
 *
 *  @param array 存放产品信息（含订单,预订人,旅客等信息）
 */
- (void)commitTheOrderFillInInfo:(NSDictionary *)proInfo
{

    [self generateTheOrderInfo:proInfo];
    
    
    
    
    
    //判断用户订单是否已提交
    if ( !_productString || ![_productString isEqual:[NSString stringWithFormat:@"%@", proInfo]]) {
        
        _productString = [NSString stringWithFormat:@"%@", proInfo];
        
        [self submitTheOrder];
    }
    else {

        
        ConfirmOrderViewController *confirmOrderVC = [[ConfirmOrderViewController alloc] init];
        confirmOrderVC.orderId = [[_resultDict objectForKey:@"data"] objectForKey:@"order_id"];
        [self.navigationController pushViewController:confirmOrderVC animated:YES];
        
    }
    
}

/**
 *  生成订单数据
 *
 *  @param proInfo 字典 存放:订单填写数据
 */
- (void)generateTheOrderInfo:(NSDictionary *)proInfo
{
    _collectProductInfo = [NSMutableDictionary dictionaryWithDictionary:proInfo];
    
    //
    
    [_collectProductInfo setObject:tripTime forKey:@"trip_time"];
    [_collectProductInfo setObject:[productDict objectForKey:@"title"] forKey:@"product_name"];
    [_collectProductInfo setValue:_adultNum forKey:@"adultNum"];
    [_collectProductInfo setValue:_childNum forKey:@"childNum"];

}

- (void)submitTheOrder
{
    ParametersManagerObject *managerObject = [[ParametersManagerObject alloc] init];
    
    //uid、authcode、pid、gid、room_num、contact_name、contact_mobile、
    //contact_email、goods_type_id
    UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedInstance];
    [managerObject addParamer:[NSString stringWithFormat:@"uid=%@", userInfoSingleton.userInfoModel.id]];
    [managerObject addParamer:[NSString stringWithFormat:@"pid=%@", [productDict objectForKey:@"id"]]];
    [managerObject addParamer:[NSString stringWithFormat:@"gid=%@", _gid]];
    [managerObject addParamer:[NSString stringWithFormat:@"room_num=%@", roomNum]];
    
    [managerObject addParamer:[NSString stringWithFormat:@"contact_name=%@", [_collectProductInfo objectForKey:@"contact_name"]]];
    [managerObject addParamer:[NSString stringWithFormat:@"contact_mobile=%@", [_collectProductInfo objectForKey:@"contact_mobile"]]];
    
    if ([[_collectProductInfo objectForKey:@"contact_email"] length]) {
        [managerObject addParamer:[NSString stringWithFormat:@"contact_email=%@", [_collectProductInfo objectForKey:@"contact_email"]]];
    }
    
    [managerObject addParamer:[NSString stringWithFormat:@"goods_type1=%@", _adultNum]];
    [managerObject addParamer:[NSString stringWithFormat:@"goods_type2=%@", _childNum]];
    

    NSArray *guestArr = [_collectProductInfo objectForKey:@"guest_info"];

    

    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    
    NSString *jsonString = [writer stringWithObject:guestArr];
    [managerObject addParamer:[NSString stringWithFormat:@"custom_info=%@",jsonString]];
    
    
    

    
    NSString* urlstr = [submitOrderURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *loginUrl = [NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];

    [request setHTTPMethod:@"POST"];

    [request setHTTPBody:[managerObject getAddParamer:[NSArray arrayWithObjects:[NSString stringWithFormat:@"authcode=%@", userInfoSingleton.userInfoModel.authcode], nil]]];
    
    NSLog(@"pars = %@",[managerObject getParamersWithSign]);
    NSURLConnection *historyConn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if (historyConn) {
        _orderData = [[NSMutableData alloc] init];
        [self showHub:@"提交订单中"];
        
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
    [_orderData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self hideHub];
    UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"连接服务器超时,请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alow show];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError *error1 = [[NSError alloc] init];
    _resultDict = [NSJSONSerialization JSONObjectWithData:_orderData options:NSJSONReadingMutableContainers error:&error1];
    NSLog(@"rr = %@",_resultDict);
    
    
    if ([[_resultDict objectForKey:@"result"] isEqualToString:@"ok"]) {
        
        [self hideHub];
        _orderAl = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"订单提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [_orderAl show];
        
        
        
    }
    else{
        [self hideHub];
        UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[[_resultDict objectForKey:@"data"] objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alow show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _orderAl) {
        //登出
        ConfirmOrderViewController *confirmOrderVC = [[ConfirmOrderViewController alloc] init];
        confirmOrderVC.orderId = [[_resultDict objectForKey:@"data"] objectForKey:@"order_id"];
        [self.navigationController pushViewController:confirmOrderVC animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
