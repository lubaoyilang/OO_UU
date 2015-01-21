//
//  ModificationPasswordViewController.m
//  UThing
//
//  Created by Apple on 14/11/17.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "ModificationPasswordViewController.h"
#import "WQKeyChain.h"
#import "NetworkingCenter.h"
#import "UserInfoSingleton.h"
#import "LoginAndRegisterCenter.h"

@interface ModificationPasswordViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>
{
    NSArray *titleNameArr;
    NSArray *placeHolderArr;
    
}
@property (nonatomic, strong) UIButton *activityButton;
@property (nonatomic, strong) NSMutableData *payData;
@property (nonatomic, strong) UITextField *activityTextField;
@property (nonatomic,strong) NSURLConnection *payConn;
@property (nonatomic, strong) UIAlertView *alertView;
@end

@implementation ModificationPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.quickLoginBtn setTitle:@"确认" forState:UIControlStateNormal];
    
    self.title = @"修改密码";
    
    [self setModificationInfoMemory];
    
    CGRect frame = self.functionMenutableView.frame;
    frame.size.height = HeightForCell*titleNameArr.count;
    self.functionMenutableView.frame = frame;
    self.functionMenutableView.allowsSelection = NO;
    self.functionMenutableView.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithFrame:CGRectMake(0, 0, 20, 20) title:nil image:@"icon_返回.png" target:self action:@selector(backToTheLastViewController:)]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_activityTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activityTextField = textField;
}

- (void)backToTheLastViewController:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setModificationInfoMemory
{
    titleNameArr = @[@"原始密码", @"新密码", @"确认新密码"];
    placeHolderArr = @[@"必填", @"请输入6-18位的密码", @"请重新输入6-18位密码"];
}

#pragma mark ==UITableView DataSource and UITableViewDelegate Methods==
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleNameArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        
        [self configCellWith:cell.contentView index:indexPath.row];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightForCell;
}

- (void)configCellWith:(UIView *)superView index:(NSInteger)index
{
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 160, HeightForCell)];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor blackColor];
    textLabel.text = titleNameArr[index];
    [superView addSubview:textLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, HeightForCell-1, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"f5f5f5"];
    [superView addSubview:lineView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, self.view.bounds.size.width-100-20, HeightForCell)];
    textField.placeholder = placeHolderArr[index];
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.tag = 367+index;
    textField.secureTextEntry = YES;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [superView addSubview:textField];
    
}


//重写按钮点击事件
- (void)quitLoginClick:(UIButton *)btn
{
    //验证原密码是否正确
    NSString *password = [WQKeyChain load:@"password"];
    UITextField *old_ps = (UITextField *)[self.view viewWithTag:367];
    NSLog(@"old_ps = %@", old_ps.text);
    if ([password isEqualToString:old_ps.text]) {
        NSLog(@"原密码正确");
        
        //验证两次密码是否一致
        UITextField *new_ps = (UITextField *)[self.view viewWithTag:368];
        UITextField *confirmNew_ps = (UITextField *)[self.view viewWithTag:369];
        if ([new_ps.text isEqualToString:confirmNew_ps.text]) {
            
            //请求修改密码
            [self postDataModificationPassword:new_ps.text];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"新密码两次输入不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
     
        
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"原密码填写有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}


/**
 *  请求修改密码
 */
- (void)postDataModificationPassword:(NSString *)ps
{
    ParametersManagerObject *managerObject = [[ParametersManagerObject alloc] init];
    
    UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedInstance];
    [managerObject addParamer:[NSString stringWithFormat:@"uid=%@", userInfoSingleton.userInfoModel.id]];
    [managerObject addParamer:[NSString stringWithFormat:@"old_ps=%@", [managerObject passwordEncrypt:[WQKeyChain load:@"password"]]]];
    [managerObject addParamer:[NSString stringWithFormat:@"device=IOS"]];
    [managerObject addParamer:[NSString stringWithFormat:@"ps=%@", [managerObject passwordEncrypt:ps]]];

    
    NSString* urlstr = [updatePasswordURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *loginUrl = [NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[managerObject getAddParamer:[NSArray arrayWithObject:[NSString stringWithFormat:@"authcode=%@", userInfoSingleton.userInfoModel.authcode]]]];
    
    NSLog(@"pars = %@",[managerObject getParamersWithSign]);
    NSURLConnection *historyConn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if (historyConn) {
        _payData = [[NSMutableData alloc] init];
        
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
    [_payData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"连接服务器超时,请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alow show];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError *error1 = [[NSError alloc] init];
    NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:_payData options:NSJSONReadingMutableContainers error:&error1];
    NSLog(@"rr = %@",resultsDictionary);
    
    if ([[resultsDictionary objectForKey:@"result"] isEqualToString:@"ok"]) {
        
        //登出
        LoginAndRegisterCenter *center = [[LoginAndRegisterCenter alloc] init];
        [center logout];
        
        
        _alertView = [[UIAlertView alloc] init];
        _alertView.title = @"温馨提示";
        _alertView.message = @"密码修改成功,请重新登录";
        _alertView.delegate = self;
        
        //存入
        [WQKeyChain delete:@"password"];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f
                                         target:self
                                       selector:@selector(dismissAlertView:)
                                       userInfo:nil
                                        repeats:NO];
        
        [_alertView show];
      
    }
    else{
        UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[[resultsDictionary objectForKey:@"data"] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alow show];
    }
}


- (void)dismissAlertView:(NSTimer *)timer
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == _alertView) {
        //切回登陆页
        [self.m_delegate modificationPSClick];
    }
    
}


#pragma mark - =========program UITextField delegate

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
    
    
    if ([toBeString length] > 18) {
        textField.text = [toBeString substringToIndex:18];

        return NO;
        
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
