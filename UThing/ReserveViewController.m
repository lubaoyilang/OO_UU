//
//  ReserveViewController.m
//  UThing
//
//  Created by wushengzhong on 14/12/22.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "ReserveViewController.h"

#import "FillInTextField.h"

#import "UserInfoSingleton.h"

#define padding 40

@interface ReserveViewController ()<UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSArray *textFieldArray;

@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) NSMutableData *orderData;

@end

@implementation ReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"data = %@", self.proInfo);
    self.title = @"预定咨询";
    
    
    [self initView];
    
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_textField resignFirstResponder];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


/**
 *  创建视图
 */
- (void)initView
{
    
    UIScrollView *baceView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    baceView.contentSize = self.view.bounds.size;
    [self.view addSubview:baceView];
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, 16)];
    titleLabel.text = [NSString stringWithFormat:@"%@", self.proInfo[@"name"]];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [baceView addSubview:titleLabel];
    

    
    //
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+10, kMainScreenWidth, .5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [baceView addSubview:lineView];
    
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.image = LOADIMAGE(@"xing", @"png");
    [baceView addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.image = LOADIMAGE(@"xing", @"png");
    [baceView addSubview:imageView2];
    
    //联系人:
    UILabel *contactLabel = [self createLabelWithText:@"联系人:"];
    [baceView addSubview:contactLabel];
    
    UITextField *contactTextField = [self createTextField];
    contactTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [baceView addSubview:contactTextField];
    
    
    //电话:
    UILabel *phoneLabel = [self createLabelWithText:@"电    话:"];
    [baceView addSubview:phoneLabel];
    
    UITextField *phoneTextField = [self createTextField];
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [baceView addSubview:phoneTextField];
    
    //邮箱:
    UILabel *emailLabel = [self createLabelWithText:@"邮    箱:"];
    [baceView addSubview:emailLabel];
    
    UITextField *emailTextField = [self createTextField];
    [baceView addSubview:emailTextField];
    
    

    
    //autoLayout
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(lineView.mas_bottom).offset(padding-10);
        make.left.equalTo(baceView.mas_left).offset(padding);
        make.right.equalTo(contactTextField.mas_left).offset(-10);
        
        make.size.equalTo(CGSizeMake(60, 20));
        
        
    }];
    
    [contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(lineView.mas_bottom).offset(12);
        make.left.equalTo(contactLabel.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-padding);

        make.height.equalTo(@26);
        make.centerY.equalTo(contactLabel.mas_centerY);
        make.height.equalTo(@[phoneTextField.mas_height, emailTextField.mas_height]);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactLabel.mas_bottom).offset(20);
        make.left.equalTo(baceView.mas_left).offset(padding);

    }];

    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-padding);
        make.left.equalTo(contactTextField.mas_left);
        make.centerY.equalTo(phoneLabel.mas_centerY);
    }];

    
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).offset(20);
        make.left.equalTo(contactLabel.mas_left);
        
    }];

    [emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-padding);
        make.left.equalTo(phoneTextField.mas_left);
        make.centerY.equalTo(emailLabel.mas_centerY);
    }];
    
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(contactTextField.mas_top).offset(4);
        make.right.equalTo(contactLabel.mas_left).offset(-2);
        
        make.size.equalTo(CGSizeMake(7, 7));
    }];
    
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(phoneTextField.mas_top).offset(4);
        make.right.equalTo(contactLabel.mas_left).offset(-2);
        
        make.size.equalTo(CGSizeMake(7, 7));
    }];
    
    //
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:14];
    textView.delegate = self;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 1.0f;
    textView.tag = 200;
    textView.returnKeyType = UIReturnKeyDone;
    textView.backgroundColor = [UIColor clearColor];
    [baceView addSubview:textView];
    
    UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, kMainScreenWidth-90, 40)];
    placeholderLabel.text = @"请输入您得需求，我们会尽快与您取得联系，方便您得出行。(10~200字)";
    placeholderLabel.textColor = [UIColor lightGrayColor];
    placeholderLabel.font = [UIFont systemFontOfSize:14];
    
    placeholderLabel.tag = 201;
    placeholderLabel.enabled = NO;
    placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    placeholderLabel.backgroundColor = [UIColor clearColor];
    placeholderLabel.numberOfLines = 0;
    [textView addSubview:placeholderLabel];
    
    
    _textFieldArray = @[contactTextField, phoneTextField, emailTextField, textView];
    
    //
    QBFlatButton *submitButton = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    [submitButton setFaceColor:[UIColor colorFromHexRGB:@"F89902"] forState:UIControlStateNormal];
    [submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    submitButton.layer.cornerRadius = 5;
    submitButton.clipsToBounds = YES;
    [baceView addSubview:submitButton];
    
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailTextField.mas_bottom).offset(30);
        make.left.equalTo(baceView.mas_left).offset(padding);
        make.right.equalTo(self.view).offset(-padding);
        
        make.height.equalTo(@150);
    }];
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(20);
        make.left.equalTo(baceView.mas_left).offset(padding);
        make.right.equalTo(self.view).offset(-padding);
        make.bottom.equalTo(baceView.mas_bottom).offset(-50);
        
        make.height.equalTo(@35);
    }];
}


#pragma mark ==快速创建View==
/**
 *  快速创建label
 */
- (UILabel *)createLabelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:18];
    return label;
}


/**
 *  快速创建textField
 */
- (UITextField *)createTextField
{
    FillInTextField *textField = [[FillInTextField alloc] init];
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont systemFontOfSize:16];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 1.0f;
    textField.delegate = self;
    return textField;
}


#pragma mark ==textField Delegate==

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _textField = textField;
}

#pragma mark ==textView Delegate==
/**
 *  textView 显示默认文字
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    

    if ([toBeString length] > 200) {
        textView.text = [toBeString substringToIndex:200];
        return NO;
    }

    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    UILabel *pLabel = (UILabel *)[self.view viewWithTag:201];
    if ([textView.text length]) {
        pLabel.text = @"";
    }else{
        pLabel.text = @"请输入您得需求，我们会尽快与您取得联系，方便您得出行。(10~200字)";
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


#pragma mark - 
#pragma mark Action

//提交
- (void)submitButtonClick:(UIButton *)button
{
    UITextField *contactTF = _textFieldArray.firstObject;
    UITextField *phoneTF = [_textFieldArray objectAtIndex:1];
    UITextField *emailTF = [_textFieldArray objectAtIndex:2];
    UITextView *textView = [_textFieldArray objectAtIndex:3];
    
    //判断
    if (contactTF.text.length == 0) {
        
        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请填写正确的联系人信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        
    } else {
        
        if (![NSString isValidateMobile:phoneTF.text]) {
            
            [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请填写正确的电话信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
        } else {
            
            if (emailTF.text.length && ![NSString isValidateEmail:emailTF.text]) {
                
                [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请填写正确的邮箱信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                
            } else {
                
                if (textView.text.length < 10) {
                    
                    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"咨询信息长度不够哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                    
                } else {
                    
                    [self submitOrder];
                    
                }
                
                
            }
        }
        
    }
    

    
}

- (void)submitOrder
{
    UITextField *contactTF = _textFieldArray.firstObject;
    UITextField *phoneTF = [_textFieldArray objectAtIndex:1];
    UITextField *emailTF = [_textFieldArray objectAtIndex:2];
    UITextView *textView = [_textFieldArray objectAtIndex:3];
    
    ParametersManagerObject *managerObject = [[ParametersManagerObject alloc] init];
    

    UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedInstance];
    [managerObject addParamer:[NSString stringWithFormat:@"uid=%@", userInfoSingleton.userInfoModel.id]];
    [managerObject addParamer:@"device=ios"];
    [managerObject addParamer:[NSString stringWithFormat:@"pid=%@", self.proID]];
    
    [managerObject addParamer:[NSString stringWithFormat:@"contact_name=%@", contactTF.text]];
    [managerObject addParamer:[NSString stringWithFormat:@"contact_mobile=%@", phoneTF.text]];
    [managerObject addParamer:[NSString stringWithFormat:@"contact_content=%@", textView.text]];

    if ([emailTF.text length]) {
        [managerObject addParamer:[NSString stringWithFormat:@"contact_email=%@", emailTF.text]];
    }

//    
    NSString* urlstr = [consultURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *loginUrl = [NSURL URLWithString:urlstr];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[managerObject getAddParamer:[NSArray arrayWithObjects:[NSString stringWithFormat:@"authcode=%@", userInfoSingleton.userInfoModel.authcode], nil]]];
    
    NSURLConnection *historyConn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if (historyConn) {
        _orderData = [[NSMutableData alloc] init];
        [self showHub:@"信息提交中"];
        
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

    
    if ([[_resultDict objectForKey:@"result"] isEqualToString:@"ok"]) {
        
        //FIXME:
        _alertView = [[UIAlertView alloc] initWithTitle:@"提交成功" message:@"请您保持手机畅通, 我们会尽快与您取得联系" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [_alertView show];
        
        
    }
    else{
        
        [self showAlertViewWithString:@"提交失败"];//[[_resultDict objectForKey:@"data"] objectForKey:@"msg"]];
        
    }
    
    [self hideHub];
}

- (void)showAlertViewWithString:(NSString *)string
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_alertView == alertView) {
        if (buttonIndex == 0) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
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
