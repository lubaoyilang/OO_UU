//
//  ReserveOrderViewController.m
//  UThing
//
//  Created by luyuda on 15/1/7.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "ReserveOrderViewController.h"
#import "ReserveOrderTableViewCell.h"

#import "HotelOrderDetailViewController.h"

#import "CommonFunc.h"
#import "DateOutViewController.h"
#import "IIViewDeckController.h"
#import "UserInfoSingleton.h"
#import "Umpay.h"
#import "MJRefresh.h"
#import "ConfirmOrderViewController.h"
#import "JSONKit.h"
#import "Umpay.h"

@interface ReserveOrderViewController ()<UITableViewDataSource,UITableViewDelegate,myReseOrderProtocal,UmpayDelegate>

@property (nonatomic,strong)NSMutableData *userOrderData;
@property (nonatomic,strong)NSMutableData *payData;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong)NSURLConnection *payConn;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSURLConnection *orderConn;

@end

#define CELLH 130.0

@implementation ReserveOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的预订单";
    NSArray *array = [self.navigationController viewControllers];
    if ([array count]<=1) {
        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"菜单"] style:UIBarButtonItemStyleDone target:self.viewDeckController action:@selector(toggleLeftView)];
        
        self.navigationItem.leftBarButtonItem = menuItem;
    }
    
    [self getUserOrder];
    
}



- (void)getUserOrder
{
    
    ParametersManagerObject *pObject = [[ParametersManagerObject alloc] init];
    
    UserInfoSingleton *uInfo =[UserInfoSingleton sharedInstance];
    
    
    NSString *uid =[NSString stringWithFormat:@"uid=%@",uInfo.userInfoModel.id] ; //key = password
    NSString *authcode = [NSString stringWithFormat:@"authcode=%@",uInfo.userInfoModel.authcode];
    [pObject addParamer:uid];
    
    [pObject addParamer:[NSString stringWithFormat:@"device=%@", @"ios"]];
    
    NSString* urlstr = [getReseOrderURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *loginUrl = [NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[pObject getAddParamer:[NSArray arrayWithObject:authcode]]];
    
    NSLog(@"pars = %@",[pObject getParamersWithSign]);
    _orderConn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if (_orderConn) {
        _userOrderData = [[NSMutableData alloc] initWithData:nil];
        
        [self showHub:@"订单加载中"];
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"警告"
                                                        message: @"不能连接到服务器,请检查您的网络"
                                                       delegate: nil
                                              cancelButtonTitle: @"确定"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    
    
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == _payConn) {
        [_payData appendData:data];
    }else{
        [_userOrderData appendData:data];
    }
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    
    
    UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"连接服务器超时,请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alow show];
    
    
    
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (connection == _payConn) {
        
        id dict = [_payData objectFromJSONData];
        
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
                    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"警告" message:@"订单超时未生成，请重新购买" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
        
        
        
    }else{
        
        SBJsonParser *sbp = [[SBJsonParser alloc] init];
        NSDictionary *dict = [sbp objectWithData:_userOrderData];
        
        
        NSString *resultCode = [dict objectForKey:@"result"];
        if ([resultCode isEqualToString:@"ok"]) {
            
            _listArray = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"data"]];
            NSString *sign = [dict objectForKey:@"sign"];
            
            ParametersManagerObject *p = [[ParametersManagerObject alloc] init];
            BOOL isSign = [p checkSign:_listArray Sign:sign];
            
            if (isSign) {
                
                [self initTableview];
                
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
        
        
    }
    
    
    
    
    
    
    
    
    
    
    [self hideHub];
    
    
    
    
    
    
    
}



#pragma mark - Action

- (void)clickPay:(NSDictionary*)dict
{
    
    
    
//    //判断是否不是U支付
//    if ([[dict objectForKey:@"is_icbc"] intValue] == 1) {
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[dict objectForKey:@"link"]]];
//        
//    }
    //else {
        
        id pay_id = [dict objectForKey:@"pay_order_id"];
        
        if (![pay_id isKindOfClass:[NSNull class]]) {
            
            if ([pay_id length]) {
                [Umpay pay:pay_id payType:@"9" rootViewController:self delegate:self];
            }
            
        }else{
            
            
            NSLog(@"dict = %@",dict);
            
            ParametersManagerObject *pObject = [[ParametersManagerObject alloc] init];
            
            
            
            NSString *uid =[NSString stringWithFormat:@"paymentid=%@",@"10000"] ; //key = password
            [pObject addParamer:uid];
            NSString *orderid = [NSString stringWithFormat:@"orderid=%@",[dict objectForKey:@"id"]];
            [pObject addParamer:orderid];
            NSString *total_fee = [NSString stringWithFormat:@"total_fee=%@",[dict objectForKey:@"price"]];
            [pObject addParamer:total_fee];
            
            NSString *it_b_pay = [NSString stringWithFormat:@"it_b_pay=%@",[dict objectForKey:@"time_out"]];
            [pObject addParamer:it_b_pay];
            NSString *order_creattime = [NSString stringWithFormat:@"order_creattime=%@",[dict objectForKey:@"create_time"]];
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
        
        
        
        
        
        
        
        
        
        
        
   // }
    
    
    
    
    
}
- (void)clickInfo:(NSDictionary*)dict
{
    
    HotelOrderDetailViewController *hodvc = [[HotelOrderDetailViewController alloc] init];
    hodvc.orderID = dict[@"id"];
    NSLog(@"dict = %@", dict);
    [self.navigationController pushViewController:hodvc animated:YES];
    
    
}



#pragma mark - Init View

- (void)initTableview
{
    if (_tableView != nil) {
        [_tableView reloadData];
        if ([_tableView isHeaderRefreshing]) {
            [_tableView headerEndRefreshing];
        }
    }else{
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tag =8777;
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mjCell"];
        
        [_tableView addHeaderWithTarget:self action:@selector(refreshTableview) dateKey:@"table"];
        
        //[self.tableView headerBeginRefreshing];
        
        
        // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
        _tableView.headerPullToRefreshText = @"下拉可以刷新了";
        _tableView.headerReleaseToRefreshText = @"松开马上刷新了";
        _tableView.headerRefreshingText = @"正在玩命加载中...";
        
    }
    
    
    
    
    
}

- (void)refreshTableview
{
    [_orderConn cancel];
    _orderConn = nil;
    [self getUserOrder];
    
}

#pragma mark - PayDelegate

- (void)onPayResult:(NSString*)orderId resultCode:(NSString*)resultCode resultMessage:(NSString*)resultMessage
{
    if ([resultCode isEqualToString:@"0000"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
                                                        message: @"支付成功"
                                                       delegate: nil
                                              cancelButtonTitle: @"确定"
                                              otherButtonTitles: nil];
        [alert show];
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
                                                        message: @"支付失败"
                                                       delegate: nil
                                              cancelButtonTitle: @"确定"
                                              otherButtonTitles: nil];
        [alert show];
        
    }
    [self getUserOrder];
    
    
}


#pragma mark - Tableview Delegate

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLH;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"ReserveOrderTableViewCell";
    ReserveOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    
    
    
    if (cell == nil) {
        
        cell = [[ReserveOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier cellHeight:CELLH];
        cell.delegate = self;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
    [cell refreshViewWithObject:dict];
    
    
    
    return cell;
}










@end
