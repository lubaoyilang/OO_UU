//
//  DepositPayViewController.m
//  UThing
//
//  Created by Apple on 14/12/23.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "DepositPayViewController.h"

#import "FillInTextField.h"
#import "HotelOrderDetailViewController.h"

#import "ReserveViewController.h"

@interface DepositPayViewController ()<UITextFieldDelegate, UIAlertViewDelegate>


@property (nonatomic, strong) UITextField *orderNameTextField;
@property (nonatomic, strong) UITextField *orderContactNumberTextField;
@property (nonatomic, strong) UITextField *orderEmailTextField;

@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) NSDictionary *dictData;

@property (nonatomic, strong) NSMutableData *orderData;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSString *productString;

@end

@implementation DepositPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"支付订金";
    
    
    [self initView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_textField resignFirstResponder];
}


#pragma mark ==View==
/**
 *  UI界面
 */
- (void)initView
{
    
    NSDictionary *prodict = self.obj;
    NSLog(@"obj = %@", prodict);
    
    UIScrollView *baceView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    baceView.contentSize = self.view.bounds.size;
    [self.view addSubview:baceView];
    
    UILabel *proTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 30)];
    proTitle.text = [prodict objectForKey:@"title"];
    proTitle.textAlignment = NSTextAlignmentCenter;
//    [proTitle sizeToFit];
    proTitle.center = CGPointMake(kMainScreenWidth/2, 35);
    proTitle.font = [UIFont boldSystemFontOfSize:18];
    proTitle.textColor = [UIColor blackColor];
    [baceView addSubview:proTitle];
    
    UILabel *referencePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, kMainScreenWidth*.4, 30)];
    referencePriceLabel.text = @"参考价格:";
    referencePriceLabel.textAlignment = NSTextAlignmentRight;
    referencePriceLabel.font = [UIFont boldSystemFontOfSize:18];
    referencePriceLabel.textColor = [UIColor blackColor];
    [baceView addSubview:referencePriceLabel];

    UILabel *referencePrice = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth*.4+10, 67, kMainScreenWidth*.4, 23)];
    referencePrice.text = self.priceNum;
    referencePrice.textAlignment = NSTextAlignmentLeft;
    referencePrice.font = [UIFont boldSystemFontOfSize:16];
    referencePrice.textColor = [UIColor grayColor];
    [baceView addSubview:referencePrice];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kMainScreenWidth*.4, 30)];
    priceLabel.text = @"订金价格:";
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont boldSystemFontOfSize:18];
    priceLabel.textColor = [UIColor blackColor];
    [baceView addSubview:priceLabel];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth*.4+10, 100, kMainScreenWidth*.4, 30)];
    price.text = [NSString stringWithFormat:@"¥ %@", [NSString moneyFromThousand:[prodict objectForKey:@"booking"]]];
    price.textAlignment = NSTextAlignmentLeft;
    price.font = [UIFont boldSystemFontOfSize:18];
    price.textColor = [UIColor colorFromHexRGB:@"F89902"];
    [baceView addSubview:price];
    
    
    

    
    
    //预定人信息
    UIView *orderPeopleInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kMainScreenWidth, 170)];
    orderPeopleInfoBackView.userInteractionEnabled = YES;
    [baceView addSubview:orderPeopleInfoBackView];
    
    
    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 30)];
    titleBackView.backgroundColor = [UIColor whiteColor];
    [orderPeopleInfoBackView addSubview:titleBackView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    iconView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app-订单填写_10" ofType:@"png"]];
    [titleBackView addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 30)];
    titleLabel.text = @"预订人信息";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleBackView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kMainScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"6c554f"];
    [orderPeopleInfoBackView addSubview:lineView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 31, kMainScreenWidth, 139)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    [orderPeopleInfoBackView addSubview:view];
    
    
    UIImageView *imageView1 = [UIImageView imageViewWithFrame:CGRectMake(kMainScreenWidth*0.27-40, 30, 5, 5) image:nil];
    imageView1.image = LOADIMAGE(@"xing", @"png");
    [view addSubview:imageView1];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, kMainScreenWidth*0.27, 25)];
    nameLabel.text = @"姓名";
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:nameLabel];
    
    _orderNameTextField = [self createTextFieldWithFrame:CGRectMake(kMainScreenWidth*0.3, 25, kMainScreenWidth-kMainScreenWidth*0.3-40, 25)];
    _orderNameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [view addSubview:_orderNameTextField];
    
    UIImageView *imageView2 = [UIImageView imageViewWithFrame:CGRectMake(kMainScreenWidth*0.27-72, 70, 5, 5) image:nil];
    imageView2.image = LOADIMAGE(@"xing", @"png");
    [view addSubview:imageView2];
    
    UILabel *contactNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, kMainScreenWidth*0.27, 25)];
    contactNumberLabel.text = @"联系电话";
    contactNumberLabel.font = [UIFont boldSystemFontOfSize:16];
    contactNumberLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:contactNumberLabel];
    
    _orderContactNumberTextField = [self createTextFieldWithFrame:CGRectMake(kMainScreenWidth*0.3, 65, kMainScreenWidth-kMainScreenWidth*0.3-40, 25)];
    _orderContactNumberTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [view addSubview:_orderContactNumberTextField];
    
    UILabel *EmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, kMainScreenWidth*0.27, 25)];
    EmailLabel.text = @"Email";
    EmailLabel.font = [UIFont boldSystemFontOfSize:16];
    EmailLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:EmailLabel];
    
    _orderEmailTextField = [self createTextFieldWithFrame:CGRectMake(kMainScreenWidth*0.3, 105, kMainScreenWidth-kMainScreenWidth*0.3-40, 25)];
    _orderEmailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [view addSubview:_orderEmailTextField];
    
    

    
    
    //最终支付价格
//    UILabel *finalPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, orderPeopleInfoBackView.frame.origin.y+orderPeopleInfoBackView.frame.size.height+40, kMainScreenWidth*.3, 30)];
//    //
//    finalPrice.text = [NSString stringWithFormat:@"¥ %@", [NSString moneyFromThousand:[prodict objectForKey:@"booking"]]];
//    finalPrice.textAlignment = NSTextAlignmentRight;
//    finalPrice.font = [UIFont boldSystemFontOfSize:24];
//    finalPrice.textColor = [UIColor colorFromHexRGB:@"F89902"];
//    [baceView addSubview:finalPrice];
    
    
    
    
    
    //提交订单按钮
    QBFlatButton *submitBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0, orderPeopleInfoBackView.bottom+40, kMainScreenWidth, 30);
    [submitBtn setFaceColor:[UIColor colorFromHexRGB:@"F89902"]];
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    submitBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [baceView addSubview:submitBtn];
    
    

}


- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[FillInTextField alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y-3, frame.size.width, frame.size.height+6)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont systemFontOfSize:16];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.layer.borderColor = [UIColor colorFromHexRGB:@"efefef"].CGColor;
    textField.layer.borderWidth = 1.0f;
    textField.delegate = self;
    
    return textField;
}


#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif



#pragma mark ==提交按钮 点击事件==
/**
 *  提交按钮 点击事件
 */
- (void)submitBtnClick:(NSString *)btn
{
    //判断 联系人
    if (_orderNameTextField.text.length == 0) {
        [self showAlertViewWithString:@"请正确填写联系人信息"];
    }
    else {
        
        //判断电话是否填写正确
        if ([NSString isValidateMobile:_orderContactNumberTextField.text]) {
            
            //判断email是否为空或者填写是否正确
            if (!_orderEmailTextField.text.length || [NSString isValidateEmail:_orderEmailTextField.text]) {
                
                //上传数据
                
                
                
                
                
                //判断用户订单是否已提交
                if ( !_productString || ![_productString isEqual:[NSString stringWithFormat:@"%@%@%@", _orderNameTextField.text, _orderContactNumberTextField.text, _orderEmailTextField.text]]) {
                    
                    _productString = [NSString stringWithFormat:@"%@%@%@", _orderNameTextField.text, _orderContactNumberTextField.text, _orderEmailTextField.text];
                    
                    [self requestSubmitOrderInfo];
                    
                }
                else {
                    
                    
                    HotelOrderDetailViewController *hodvc = [[HotelOrderDetailViewController alloc] init];
                    hodvc.orderID = [[_dictData objectForKey:@"data"] objectForKey:@"order_id"];
                    [self.navigationController pushViewController:hodvc animated:YES];
                    
                }
                
                
                
            }
            else {
                [self showAlertViewWithString:@"请正确填写邮件信息"];
            }
            
        }
        else {
            [self showAlertViewWithString:@"请正确填写电话号码"];
        }
        
    }
}

- (void)showAlertViewWithString:(NSString *)string
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}




#pragma mark ==提交酒店套餐订单==
- (void)requestSubmitOrderInfo
{
    ParametersManagerObject *managerObject = [[ParametersManagerObject alloc] init];
    

    
    UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedInstance];
    [managerObject addParamer:[NSString stringWithFormat:@"uid=%@", userInfoSingleton.userInfoModel.id]];
    [managerObject addParamer:[NSString stringWithFormat:@"pid=%@", [self.obj objectForKey:@"id"]]];
    [managerObject addParamer:[NSString stringWithFormat:@"contact_name=%@", _orderNameTextField.text]];
    [managerObject addParamer:[NSString stringWithFormat:@"contact_mobile=%@", _orderContactNumberTextField.text]];
    [managerObject addParamer:[NSString stringWithFormat:@"device=ios"]];
    
    if ([_orderEmailTextField.text length]) {
        [managerObject addParamer:[NSString stringWithFormat:@"contact_email=%@", _orderEmailTextField.text]];
    }
    
    
    NSString* urlstr = [submitHotelOrderURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *loginUrl = [NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];

    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[managerObject getAddParamer:[NSArray arrayWithObjects:[NSString stringWithFormat:@"authcode=%@", userInfoSingleton.userInfoModel.authcode], nil]]];
    
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


#pragma mark ==网络请求结果==

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
    NSDictionary *_resultDict = [NSJSONSerialization JSONObjectWithData:_orderData options:NSJSONReadingMutableContainers error:&error1];
    NSLog(@"rr = %@",_resultDict);
    
    _dictData = [NSDictionary dictionaryWithDictionary:_resultDict];
    
    
    if ([[_resultDict objectForKey:@"result"] isEqualToString:@"ok"]) {
        
        
        [self hideHub];

        
        _alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"订单提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [_alertView show];
        
        
        
    }
    else{
        
        [self hideHub];
        
        [self showAlertViewWithString:[[_resultDict objectForKey:@"data"] objectForKey:@"msg"]];
        
    }
    
    [self hideHub];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (_alertView == alertView) {
        
        if (buttonIndex == 0) {
            
            
            HotelOrderDetailViewController *hodvc = [[HotelOrderDetailViewController alloc] init];
            hodvc.orderID = [[_dictData objectForKey:@"data"] objectForKey:@"order_id"];
            [self.navigationController pushViewController:hodvc animated:YES];
        }
        
    }
}


#pragma mark - ====UITextField delegate=====
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _textField = textField;
}
//限制输入个数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    if ([toBeString length] > 20) {
        textField.text = [toBeString substringToIndex:20];
        return NO;
    }
    
    
    return YES;
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
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
