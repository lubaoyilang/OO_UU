//
//  LoginViewController.m
//  UThing
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "LoginViewController.h"

#import "QBFlatButton.h"
#import "CustomTextField.h"
#import "IIViewDeckController.h"
#import "RegisterViewController.h"
#import "FindPasswordViewController.h"
#import "LoginAndRegisterCenter.h"
#import "UserInfoSingleton.h"
#import "WQKeyChain.h"
#import "SVProgressHUD.h"

#import "AppDelegate.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UIImageView *m_backView;
    
    CustomTextField *m_nameTextField;
    CustomTextField *m_passwordTextField;
    
    QBFlatButton *m_loginBtn;
    UIAlertView *m_alertView;
    NSTimer *_myTimer;
}
@property (nonatomic, strong) UITextField *activityTextField;
@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"游心会员登录";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    view.backgroundColor = [UIColor lightGrayColor];
    view.alpha = 0.3;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromView:view] forBarMetrics:UIBarMetricsDefault];
    
    
    NSArray *array = [self.navigationController viewControllers];
    if ([array count]<=1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"菜单"] style:UIBarButtonItemStyleDone target:self.viewDeckController action:@selector(toggleLeftView)];
        
    }else{
        
    }
    
    [self createViewUI];
    
    
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

/*
 * 键盘外点击回收
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //[_activityTextField resignFirstResponder];
    
    [self.view endEditing:YES];
}

#pragma mark ==View UI==
- (void)createViewUI
{
    m_backView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    m_backView.image = [UIImage imageNamed:@"bg.jpg"];
    m_backView.userInteractionEnabled = YES;
    [self.view addSubview:m_backView];

    
    
    
    
    
    
    // textField
    [self createTheTextField];
}


/*
 * 创建视图
 */
- (void)createTheTextField
{
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*1.5/8, 30+64, self.view.bounds.size.width*5/8, self.view.bounds.size.width*5*75/(8*200))];
    logoView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app-登陆_logo" ofType:@"png"]];
    [m_backView addSubview:logoView];
    
    //nameTextField
    m_nameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(30, 200, self.view.bounds.size.width-60, 40)];
    [m_nameTextField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    m_nameTextField.placeholder = @"请输入邮箱或手机号"; //默认显示的字
    m_nameTextField.font = [UIFont systemFontOfSize:16];
    m_nameTextField.layer.cornerRadius = 20;
    m_nameTextField.clipsToBounds = YES;
    m_nameTextField.layer.borderWidth = 2;
    m_nameTextField.backgroundColor = [UIColor clearColor];
    m_nameTextField.layer.borderColor = [UIColor colorFromHexRGB:@"bdaba1"].CGColor;
    m_nameTextField.placeHolderFont = [UIFont systemFontOfSize:18];
    m_nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    m_nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    m_nameTextField.returnKeyType = UIReturnKeyDone;
    m_nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    m_nameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    m_nameTextField.delegate = self;
    
    
    NSString *username = [WQKeyChain load:@"username"];
    if (username.length) {
        m_nameTextField.text = username;
    }
    
    [self.view addSubview:m_nameTextField];
    
    //passwordTextField
    m_passwordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(30, 250, self.view.bounds.size.width-60, 40)];
    [m_passwordTextField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    m_passwordTextField.placeholder = @"请输入密码"; //默认显示的字
    m_passwordTextField.font = [UIFont systemFontOfSize:16];
    m_passwordTextField.secureTextEntry = YES; //密码
    m_passwordTextField.layer.cornerRadius = 20;
    m_passwordTextField.clipsToBounds = YES;
    m_passwordTextField.layer.borderWidth = 2;
    m_passwordTextField.backgroundColor = [UIColor clearColor];
    m_passwordTextField.layer.borderColor = [UIColor colorFromHexRGB:@"bdaba1"].CGColor;
    m_passwordTextField.placeHolderFont = [UIFont systemFontOfSize:18];
    m_passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    m_passwordTextField.clearsOnBeginEditing = YES;
    m_passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    m_passwordTextField.returnKeyType = UIReturnKeyDone;
    m_passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_passwordTextField.delegate = self;
    
    NSString *password = [WQKeyChain load:@"password"];
    if (password.length) {
        m_passwordTextField.text = password;
    }
    [self.view addSubview:m_passwordTextField];
    
    
    //loginBtn
    m_loginBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    m_loginBtn.frame = CGRectMake(30, m_passwordTextField.frame.origin.y+m_passwordTextField.frame.size.height+30, self.view.bounds.size.width-60, 40);
    [m_loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    m_loginBtn.layer.cornerRadius  = 18;
    m_loginBtn.clipsToBounds = YES;
    m_loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    m_loginBtn.titleLabel.textColor = [UIColor whiteColor];
    [m_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_loginBtn setFaceColor:[UIColor colorFromHexRGB:@"24b8c6"] forState:UIControlStateNormal];
    [m_loginBtn setFaceColor:[UIColor colorFromHexRGB:@"24b8f9"] forState:UIControlStateHighlighted];
    [self.view addSubview:m_loginBtn];
    
    //registerBtn
    NSMutableAttributedString *content1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"立即注册"]];
    NSRange contentRange1 = {0,[content1 length]};
    [content1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange1];
    UILabel *m_register = [[UILabel alloc] initWithFrame:CGRectMake(30, m_loginBtn.frame.origin.y+m_loginBtn.frame.size.height+15, 80, 20)];
    m_register.attributedText = content1;
    m_register.font = [UIFont systemFontOfSize:14];
    m_register.textColor = [UIColor whiteColor];
    m_register.userInteractionEnabled = YES;
    UITapGestureRecognizer *registerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerBtnClick:)];
    [m_register addGestureRecognizer:registerTap];
    
    [self.view addSubview:m_register];
    
    //findPasssword
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"忘记密码?"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    UILabel *m_findPassword = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-110, m_loginBtn.frame.origin.y+m_loginBtn.frame.size.height+15, 80, 20)];
    m_findPassword.attributedText = content;
    m_findPassword.userInteractionEnabled = YES;
    m_findPassword.font = [UIFont systemFontOfSize:14];
    m_findPassword.textColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *findPasswordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findPassword)];
    [m_findPassword addGestureRecognizer:findPasswordTap];
    
    [self.view addSubview:m_findPassword];
    
    
    m_findPassword.hidden = YES;
}

/*
 *登 录
 */
#pragma mark ==Login In==
- (void)loginBtnClick:(UIButton *)btn
{
    [_activityTextField resignFirstResponder];
    
    if (m_passwordTextField.text.length == 0 || m_nameTextField.text.length == 0){
        _alertView = [[UIAlertView alloc] init];
        _alertView.title = @"温馨提示";
        [_alertView setMessage:@"请填写完整用户名和密码"];
        [_alertView addButtonWithTitle:@"确定"];
        _alertView.delegate = self;
        [_alertView show];
    }
    else {
        
        
        [WQKeyChain delete:@"username"];
        [WQKeyChain delete:@"password"];
        [WQKeyChain save:@"username" data:m_nameTextField.text];
        [WQKeyChain save:@"password" data:m_passwordTextField.text];
        
        LoginAndRegisterCenter *center = [[LoginAndRegisterCenter alloc] init];
        
        [center setMyProgressHUD:^{
            _alertView = [[UIAlertView alloc] init];
            _alertView.message = @"登录中...";
            _alertView.delegate = self;
            [_alertView show];
        }];
        
        [center setLoginBlock:^(NSDictionary *resultsDictionary) {
            
            [self dismissLoggingHUDView];
            //验证
            
            [self handleTheResultsDictionary:resultsDictionary];
            
        }];
        
        [center loginWithUsername:m_nameTextField.text password:m_passwordTextField.text];

    }
    
}

- (void)dismissLoggingHUDView
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
}

//返回结果解析
#pragma mark ==Login Result==
- (void)handleTheResultsDictionary:(NSDictionary *)resultsDictionary
{
    int error_code = [[resultsDictionary objectForKey:@"error_code"] intValue];
    NSString *msg = [[resultsDictionary objectForKey:@"data"] objectForKey:@"msg"];
    switch (error_code) {
        case 0:
        {
            NSLog(@"用户数据解析成功");
            
            NSDictionary *infoDict = [resultsDictionary objectForKey:@"data"];
            NSLog(@"infoDict = %@", infoDict);
            
            
            //存储用户信息
            UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedInstance];
            [userInfoSingleton.userInfoModel setValuesForKeysWithDictionary:infoDict];
            
            userInfoSingleton.isLogin = YES;
            
            
            _alertView = [[UIAlertView alloc] init];
            [_alertView setMessage:@"登录成功"];
            _alertView.delegate = self;
            [_alertView show];
            
            
            _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(dismissAlertView:)
                                           userInfo:nil
                                            repeats:NO];
            
            
            
            
            
            //通知菜单页改变数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginNotification" object:nil];
            
            break;
        }
        case 500:
        case 501:
        case 502:
        case 505: {
            //清除缓存数据
            [WQKeyChain delete:@"username"];
            [WQKeyChain delete:@"password"];
        
        
            UIAlertView *alertView = [[UIAlertView alloc] init];
            alertView.message = msg;
            [alertView addButtonWithTitle:@"取消"];
            [alertView show];
            break;
        }
        default:
            break;
    }
}

- (void)dismissAlertView:(NSTimer *)timer
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    
    //切回首页
    
    if (_delegate && [_delegate respondsToSelector:@selector(successLogin)]) {
        NSLog(@"_delegat");
        [self.delegate successLogin];
    }
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    //取消定时器
    [_myTimer invalidate];
}

- (void)dealloc
{
    NSLog(@"delloc");
}

/*
 *忘记密码
 */
#pragma mark ==find Password==
- (void)findPassword
{
    FindPasswordViewController *findPasswordViewController = [[FindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findPasswordViewController animated:YES];
}

/*
 *立即注册
 */
#pragma mark ==Register==
- (void)registerBtnClick:(UIButton *)btn
{
    RegisterViewController *rvc = [[RegisterViewController alloc] init];
    rvc.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.navigationController pushViewController:rvc animated:YES];
}


#pragma mark - ==textField Delegate==

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == m_nameTextField) {
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
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activityTextField = textField;
}



@end
