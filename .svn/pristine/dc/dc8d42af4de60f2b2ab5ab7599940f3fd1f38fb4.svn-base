//
//  RegisterViewController.m
//  UThing
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "RegisterViewController.h"

#import "IIViewDeckController.h"
#import "CustomTextField.h"
#import "QBFlatButton.h"
#import "LoginAndRegisterCenter.h"

#import "UserClauseViewController.h"
#import "UserInfoSingleton.h"
#import "WQKeyChain.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    UIImageView *r_backView;
    CustomTextField *r_nameTextField;
    CustomTextField *r_passwordTextField;
    CustomTextField *r_confirmPasswordTextField;
    
    QBFlatButton *r_registerBtn;
    
    BOOL isAgreeTheClause;
    
    NSTimer *_myTimer;
}
@property (nonatomic, strong) UITextField *activityTextField;
@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic, strong) NSMutableData *registerReceiveData;
@property (nonatomic, strong) ParametersManagerObject *registerManagerObject;
@property (nonatomic, strong) NSURLConnection *registerConnection;

@property (nonatomic, strong) NSMutableData *loginReceiveData;
@property (nonatomic, strong) ParametersManagerObject *loginManagerObject;
@property (nonatomic, strong) NSURLConnection *loginConnection;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"游心会员注册";
    isAgreeTheClause = NO;
    

    
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        //self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    
    [self createRegisterView];
    
    if (_isMenuClick) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"菜单"] style:UIBarButtonItemStyleDone target:self.viewDeckController action:@selector(toggleLeftView)];;
    }
    else {
        //tabBar返回按钮
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithFrame:CGRectMake(0, 0, 20, 20) title:nil image:@"icon_返回.png" target:self action:@selector(backToTheLastViewController:)]];
    }
    
    
    
}



- (void)viewWillAppear:(BOOL)animated
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    view.backgroundColor = [UIColor lightGrayColor];
    view.alpha = 0.3;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromView:view] forBarMetrics:UIBarMetricsDefault];
    
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        self.navigationController.navigationBar.translucent = YES;
        self.tabBarController.tabBar.translucent = NO;
    }
}

//tabBar返回按钮 返回按钮点击事件
- (void)backToTheLastViewController:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ==View UI==
- (void)createRegisterView
{
    //backImageView
    r_backView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    r_backView.image = [UIImage imageNamed:@"bg.jpg"];
    r_backView.userInteractionEnabled = YES;
    [self.view addSubview:r_backView];
    
    //
    //nameTextField
    r_nameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(30, 150, self.view.bounds.size.width-60, 40)];
    [r_nameTextField setBorderStyle:UITextBorderStyleRoundedRect];
    r_nameTextField.placeholder = @"请输入邮箱或手机号"; //默认显示的字
    r_nameTextField.font = [UIFont systemFontOfSize:16];
    r_nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    r_nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    r_nameTextField.returnKeyType = UIReturnKeyDone;
    r_nameTextField.layer.cornerRadius  = 21;
    r_nameTextField.clipsToBounds = YES;
    r_nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    r_nameTextField.layer.borderWidth = 2;
    r_nameTextField.backgroundColor = [UIColor clearColor];
    r_nameTextField.layer.borderColor = [UIColor colorFromHexRGB:@"bdaba1"].CGColor;
    r_nameTextField.placeHolderFont = [UIFont systemFontOfSize:18];
    r_nameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    r_nameTextField.delegate = self;
    [self.view addSubview:r_nameTextField];
    
    //passwordTextField
    r_passwordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(30, 200, self.view.bounds.size.width-60, 40)];
    [r_passwordTextField setBorderStyle:UITextBorderStyleRoundedRect];
    r_passwordTextField.placeholder = @"请输入密码"; //默认显示的字
    r_passwordTextField.font = [UIFont systemFontOfSize:18];
    r_passwordTextField.secureTextEntry = YES; //密码
    r_passwordTextField.layer.cornerRadius  = 21;
    r_passwordTextField.clipsToBounds = YES;
    r_passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    r_passwordTextField.layer.borderWidth = 2;
    r_passwordTextField.backgroundColor = [UIColor clearColor];
    r_passwordTextField.layer.borderColor = [UIColor colorFromHexRGB:@"bdaba1"].CGColor;
    r_passwordTextField.placeHolderFont = [UIFont systemFontOfSize:18];
    r_passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    r_passwordTextField.returnKeyType = UIReturnKeyDone;
    r_passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    r_passwordTextField.delegate = self;
    [self.view addSubview:r_passwordTextField];
    
    //confirmPasswordTextField
    r_confirmPasswordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(30, 250, self.view.bounds.size.width-60, 40)];
    [r_confirmPasswordTextField setBorderStyle:UITextBorderStyleRoundedRect];
    r_confirmPasswordTextField.placeholder = @"请确认密码";
    r_confirmPasswordTextField.font = [UIFont systemFontOfSize:18];
    r_confirmPasswordTextField.secureTextEntry = YES; //密码
    r_confirmPasswordTextField.layer.cornerRadius  = 21;
    r_confirmPasswordTextField.clipsToBounds = YES;
    r_confirmPasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    r_confirmPasswordTextField.layer.borderWidth = 2;
    r_confirmPasswordTextField.backgroundColor = [UIColor clearColor];
    r_confirmPasswordTextField.layer.borderColor = [UIColor colorFromHexRGB:@"bdaba1"].CGColor;
    r_confirmPasswordTextField.placeHolderFont = [UIFont systemFontOfSize:18];
    r_confirmPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    r_confirmPasswordTextField.returnKeyType = UIReturnKeyDone;
    r_confirmPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    r_confirmPasswordTextField.delegate = self;
    [self.view addSubview:r_confirmPasswordTextField];
    
    //
    UIButton *agreeTheClauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeTheClauseBtn.frame = CGRectMake(self.view.bounds.size.width*.22, 298, 14, 14);
    agreeTheClauseBtn.selected = YES;
    [agreeTheClauseBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checkbox_true" ofType:@"png"]] forState:UIControlStateSelected];
    [agreeTheClauseBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checkbox" ofType:@"png"]] forState:UIControlStateNormal];
    [agreeTheClauseBtn addTarget:self action:@selector(agreeTheClauseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeTheClauseBtn];
    
    UILabel *clauseLabel = [[UILabel alloc] initWithFrame:CGRectMake(agreeTheClauseBtn.frame.origin.x+agreeTheClauseBtn.frame.size.width+10, 295, 120, 14)];
    clauseLabel.text = @"我已阅读并同意";
    [clauseLabel sizeToFit];
    clauseLabel.font = [UIFont systemFontOfSize:12];
    clauseLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:clauseLabel];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"《用户隐私条款》"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    UILabel *clause = [[UILabel alloc] initWithFrame:CGRectMake(clauseLabel.frame.origin.x+78+10, 298, 100, 14)];
    clause.attributedText = content;
    clause.font = [UIFont systemFontOfSize:12];
    clause.textColor = [UIColor blueColor];
    clause.userInteractionEnabled = YES;
    
    //tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userClauseClick)];
    [clause addGestureRecognizer:tap];
    
    [self.view addSubview:clause];
    
    
    //registerBtn
    r_registerBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    r_registerBtn.frame = CGRectMake(30, 340, self.view.bounds.size.width-60, 40);
    r_registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [r_registerBtn setFaceColor:[UIColor colorFromHexRGB:@"24b8c4"]];
    [r_registerBtn setFaceColor:[UIColor colorFromHexRGB:@"24b8f4"] forState:UIControlStateHighlighted];
    [r_registerBtn setFaceColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    r_registerBtn.layer.cornerRadius = 18;
    r_registerBtn.clipsToBounds = YES;
    [r_registerBtn setTitle:@"注  册" forState:UIControlStateNormal];
    r_registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [r_registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:r_registerBtn];
}

/*
 *用户隐私协议 查看
 */
#pragma mark ==User Clause==
- (void)userClauseClick
{
    UserClauseViewController *userClauseViewController = [[UserClauseViewController alloc] init];
    [self.navigationController pushViewController:userClauseViewController animated:YES];
}

#pragma mark ==register Btn Click==
- (void)registerBtnClick:(UIButton *)btn
{
    [_activityTextField resignFirstResponder];
    
    
    if (r_nameTextField.text.length == 0 || r_passwordTextField.text.length == 0 || r_confirmPasswordTextField.text.length == 0) {
        if (r_nameTextField.text.length == 0) {
            [self showAlertView:@"请正确输入邮箱或手机号"];
        }
        else {
            [self showAlertView:@"请正确输入密码"];
        }
        
    }
    else {
        if ([r_confirmPasswordTextField.text isEqualToString:r_passwordTextField.text]) {
            
            if ([NSString isValidateEmail:r_nameTextField.text] || [NSString isValidateMobile:r_nameTextField.text]) {
                //加密上传
                NSLog(@"loginClick:");
                [self registerWithUsername:r_nameTextField.text password:r_passwordTextField.text];
            }
            else {
                [self showAlertView:@"请正确输入邮箱或手机号"];
            }
            

        }
        else{
            [self showAlertView:@"两次密码输入不一致"];
        }
    }
    
}


/*
 *用户注册
 */
- (void)registerWithUsername:(NSString *)username password:(NSString *)password
{
    _registerManagerObject = [[ParametersManagerObject alloc] init];
    [_registerManagerObject addParamer:[NSString stringWithFormat:@"username=%@",username]];
    [_registerManagerObject addParamer:[NSString stringWithFormat:@"password=%@",[_registerManagerObject passwordEncrypt:password]]];
    [_registerManagerObject addParamer:@"src=IOS"];
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:registerURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[_registerManagerObject getHeetBody]];
    
    
    _registerConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (_registerConnection) {
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"警告" message: @"不能连接到服务器,请检查您的网络" delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
        [alert show];
    }
}




#pragma mark ==Receive Data==
//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"%@",[res allHeaderFields]);

    
    if (connection == _loginConnection) {
        _loginReceiveData = [[NSMutableData alloc] init];
    }
    else if (connection == _registerConnection){
        _registerReceiveData = [[NSMutableData alloc] init];
    }

}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == _loginConnection) {
        [self.loginReceiveData appendData:data];
    }
    else if (connection == _registerConnection){
        [self.registerReceiveData appendData:data];
    }
    
    
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection == _loginConnection) {
        __block NSError *error1 = [[NSError alloc] init];
        if ([self.loginReceiveData length]>0) {
            NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:_loginReceiveData options:NSJSONReadingMutableLeaves error:&error1];
            
            NSDictionary *infoDict = [resultsDictionary objectForKey:@"data"];
            NSLog(@"infoDict = %@", infoDict);
            
            
            //存储用户信息
            UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedInstance];
            [userInfoSingleton.userInfoModel setValuesForKeysWithDictionary:infoDict];
            
            userInfoSingleton.isLogin = YES;
            
            //通知菜单页改变数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginNotification" object:nil];
        }

    }
    else if (connection == _registerConnection){
        __block NSError *error1 = [[NSError alloc] init];
        if ([self.registerReceiveData length]>0) {
            NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:_registerReceiveData options:NSJSONReadingMutableLeaves error:&error1];
            
//            NSLog(@"resultsDict = %@", resultsDictionary);
            
            [self handleTheResultsDictionary:resultsDictionary];
            
            if ([_registerManagerObject checkSign:[resultsDictionary objectForKey:@"data"] Sign:[resultsDictionary objectForKey:@"sign"]]) {
                NSLog(@"注册 验证成功");
                
                
                
            }
            else{
                NSLog(@"注册 验证失败");
            }
            
            
            
        }
    }
    
    
    
}
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
}



- (void)handleTheResultsDictionary:(NSDictionary *)resultsDictionary
{
    int error_code = [[resultsDictionary objectForKey:@"error_code"] intValue];
    NSString *msg = [[resultsDictionary objectForKey:@"data"] objectForKey:@"msg"];
    switch (error_code) {
        case 0:
        {
            NSLog(@"注册成功");
            
            _alertView = [[UIAlertView alloc] init];
            _alertView.message = @"注册成功";
            _alertView.delegate = self;
            
            
            _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(dismissAlertView:)
                                           userInfo:nil
                                            repeats:NO];
            
            [_alertView show];
            
            //存储用户信息
            UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedInstance];
            userInfoSingleton.isLogin = YES;
            
            
            //
            [WQKeyChain delete:@"username"];
            [WQKeyChain delete:@"password"];
            [WQKeyChain save:@"username" data:r_nameTextField.text];
            [WQKeyChain save:@"password" data:r_passwordTextField.text];
            
            //
            [self downloadUserInfoData];
            
            
            break;
        }
        case 700:
        case 500:
        case 501:
        case 502:
        case 503:
        case 504:
        {
            NSLog(@"stuts = %@", msg);
           
            [self showAlertView:msg];
            
            break;
        }
        
        default:
            break;
    }

}
- (void)showAlertView:(NSString *)string
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.title = @"温馨提示";
    alertView.message = string;
    [alertView addButtonWithTitle:@"确定"];
    alertView.delegate = self;
    [alertView show];
}


-(void)viewDidDisappear:(BOOL)animated
{
    //取消定时器
    [_myTimer invalidate];
}


- (void)downloadUserInfoData
{
    _loginManagerObject = [[ParametersManagerObject alloc] init];
    [_loginManagerObject addParamer:[NSString stringWithFormat:@"username=%@",r_nameTextField.text]];
    [_loginManagerObject addParamer:[NSString stringWithFormat:@"password=%@",[_loginManagerObject passwordEncrypt:r_passwordTextField.text]]];
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[_loginManagerObject getHeetBody]];
    
    
    _loginConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if (_loginConnection) {

        
    } else {
        
    }
}

- (void)dismissAlertView:(NSTimer *)timer
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    
    //切回首页
    if (_delegate && [_delegate respondsToSelector:@selector(successRegister)]) {
        NSLog(@"_delegat");
        [self.delegate successRegister];
    }
}

/*
 *是否同意 用户隐私协议
 */
- (void)agreeTheClauseClick:(UIButton *)btn
{
    if (btn.selected == YES) {
        btn.selected = NO;
        r_registerBtn.enabled = NO;
    }
    else {
        btn.selected = YES;
        r_registerBtn.enabled = YES;
    }
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//限制输入个数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == r_nameTextField) {
        if ([toBeString length] > 20) {
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
    }
    else {
        if ([toBeString length] > 18) {
            textField.text = [toBeString substringToIndex:18];
            return NO;
        }
    }
    
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_activityTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activityTextField = textField;
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /**
     *  判断是否是邮箱或手机号
     */
    if (textField == r_nameTextField) {
        if ([NSString isValidateEmail:r_nameTextField.text] || [NSString isValidateMobile:r_nameTextField.text]) {
            
        }
        else{
            [self showAlertView:@"请填写正确的邮箱或手机号"];
        }
        
    }
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
