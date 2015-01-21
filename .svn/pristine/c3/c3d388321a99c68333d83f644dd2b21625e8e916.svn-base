//
//  FindPasswordViewController.m
//  UThing
//
//  Created by Apple on 14/11/19.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "QBFlatButton.h"
#import "CodeView.h"
#import "NetworkingCenter.h"

@interface FindPasswordViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *checkCodeTextField;
@property (nonatomic, strong) UILabel *checkCodeNumberLabel;
@property (nonatomic, strong) NSString *code;

//成功登录后显示
@property (nonatomic, strong) UIAlertView *alert;

@property (nonatomic, strong) QBFlatButton *commitBtn;
@property (nonatomic, strong) CodeView *codeView;
@property (nonatomic, strong) UITextField *activityTextField;

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"忘记密码";
    
    //
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    
    
    //tabBar返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithFrame:CGRectMake(0, 0, 20, 20) title:nil image:@"icon_返回.png" target:self action:@selector(backToTheLastViewController:)]];
    
    
    //
    _emailTextField = [self textFieldWihtFrame:CGRectMake(self.view.bounds.size.width*0.15, 0, self.view.bounds.size.width*0.7, 44) placeholder:@"请输入手机号或邮箱地址"];
    [self.view addSubview:_emailTextField];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 30, 20)];
    imageView.image = LOADIMAGE(@"app-忘记密码_03", @"png");
    [self.view addSubview:imageView];
    
    [self.view addSubview:[self lineViewWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 1) color:[UIColor lightGrayColor]]];
    
    
    _checkCodeTextField = [self textFieldWihtFrame:CGRectMake(self.view.bounds.size.width*0.15, 45, self.view.bounds.size.width*0.4, 44) placeholder:@"请输入验证码"];
    [self.view addSubview:_checkCodeTextField];
    
    
    
    
    //验证码框
    _codeView = [[CodeView alloc] initWithFrame:CGRectMake(_checkCodeTextField.frame.origin.x+_checkCodeTextField.frame.size.width+10, 51, 70, 30)];
    [self.view addSubview:_codeView];
    
    UIButton *button = [UIButton systemButtonWithFrame:CGRectMake(_codeView.frame.origin.x+_codeView.frame.size.width, 51, 60, 30) title:@"换一张" image:nil action:^(UIButton *button) {
        [_codeView changeCode];
        
    }];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [self.view addSubview:[self lineViewWithFrame:CGRectMake(0, _checkCodeTextField.frame.origin.y+_checkCodeTextField.frame.size.height, self.view.bounds.size.width, 1) color:[UIColor lightGrayColor]]];
    
    
    _commitBtn = [[QBFlatButton alloc] initWithFrame:CGRectMake(10, _checkCodeTextField.frame.origin.y+_checkCodeTextField.frame.size.height+15, self.view.bounds.size.width-20, 44)];
    [_commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_commitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [_commitBtn setFaceColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_commitBtn setFaceColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:_commitBtn];
}

//
- (void)backToTheLastViewController:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 * 键盘外点击回收
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_activityTextField resignFirstResponder];
}

#pragma mark ==Commit Btn Click==
- (void)commitBtnClick
{
    [_checkCodeTextField resignFirstResponder];
    [_checkCodeNumberLabel resignFirstResponder];
    
    
    if ([NSString isValidateEmail:_emailTextField.text] || [NSString isValidateMobile:_emailTextField.text]) {
        
        if ([[_checkCodeTextField.text lowercaseString] isEqualToString:[self.codeView.changeString lowercaseString]]) {
            
            //post 忘记密码
            [self postForgetPassword];
        }
        else
        {
            CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
            anim.repeatCount = 1;
            anim.values = @[@-20, @20, @-20];
            [self.codeView.layer addAnimation:anim forKey:nil];
            [self.view.layer addAnimation:anim forKey:nil];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"验证码输入错误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alertView show];
        }
        
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.title = @"温馨提示";
        alertView.message = @"请输入正确的邮箱或手机号";
        [alertView addButtonWithTitle:@"确定"];
        [alertView show];
    }
}

//忘记密码
- (void)postForgetPassword
{
    ParametersManagerObject *managerObject = [[ParametersManagerObject alloc] init];
    

    [managerObject addParamer:[NSString stringWithFormat:@"uname=%@", _emailTextField.text]];

    
    NSData *data = [managerObject getHeetBody];
    NSLog(@"heetBody = %@", [managerObject getParamersWithSign]);
    
    NetworkingCenter *networkingCenter = [[NetworkingCenter alloc] init];
    [networkingCenter myAsynchronousPostWithUrl:forgetPSURL postData:data];
    
    [networkingCenter setMyResultsHandle:^(NSMutableData *resultData) {
        
        
        //返回结果
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"resultDict = %@", resultDict);
        
        //验证
        if ([managerObject checkSign:[resultDict objectForKey:@"data"] Sign:[resultDict objectForKey:@"sign"]]) {
            NSLog(@"找回密码 验证成功");
            
            
            
            _alert = [[UIAlertView alloc] initWithTitle: @"温馨提示"
                                                            message: @"密码已发至手机号或邮箱"
                                                           delegate: self
                                                  cancelButtonTitle: @"确定"
                                                  otherButtonTitles: nil];
            [_alert show];
            
        }
        
        
    }];
    [networkingCenter setMyError:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertView *alert = (UIAlertView *)[self.view viewWithTag:177];
    if (alert == alertView) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"======");
    if (buttonIndex == 0) {
        if (_alert == alertView) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (UIView *)lineViewWithFrame:(CGRect)frame color:(UIColor *)color
{
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = color;
    return lineView;
}

- (UITextField *)textFieldWihtFrame:(CGRect)frame placeholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placeholder;
    textField.autocapitalizationType = NO;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    return textField;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activityTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([[_checkCodeTextField.text lowercaseString] isEqualToString:[self.codeView.changeString lowercaseString]]) {
    }
    else
    {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-20, @20, @-20];
        [self.codeView.layer addAnimation:anim forKey:nil];
        [self.view.layer addAnimation:anim forKey:nil];
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _checkCodeTextField)
    {
        if ([toBeString length] > 4) {
            _checkCodeTextField.text = [toBeString substringToIndex:4];
            return NO;
        }
    }
    return YES;
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
