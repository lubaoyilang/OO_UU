//
//  IndividualInfoViewController.m
//  UThing
//
//  Created by Apple on 14/11/15.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "IndividualInfoViewController.h"
#import "UserInfoSingleton.h"
#import "NetworkingCenter.h"

@interface IndividualInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *titleNameArr;
    NSArray *indvidualInfoArr;
}
@property (nonatomic, strong) UIButton *activityEditButton;
@property (nonatomic, strong) UITextField *activityTextField;
@property (nonatomic, strong) NSMutableData *infoData;
//保存修改之前的数据
@property (nonatomic, strong) NSString *lastString;
@end

@implementation IndividualInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人信息";
    
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    
    [self setIndividualInfoMemory];
    
    CGRect frame = self.functionMenutableView.frame;
    frame.size.height = HeightForCell*titleNameArr.count;
    self.functionMenutableView.frame = frame;
    self.functionMenutableView.allowsSelection = NO;
    self.functionMenutableView.delegate = self;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithFrame:CGRectMake(0, 0, 20, 20) title:nil image:@"icon_返回.png" target:self action:@selector(backToTheLastViewController:)]];
}

- (void)backToTheLastViewController:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setIndividualInfoMemory
{
    self.quickLoginBtn.hidden = YES;
    
    
    titleNameArr = @[@"昵称", @"联系电话", @"Email"];
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
    
    //给cell赋值
    [self evaluationCellWith:cell index:indexPath.row];
    
    return cell;
}

//给cell赋值
- (void)evaluationCellWith:(UITableViewCell *)cell index:(NSInteger)index
{
    UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedInstance];
    
    
    UITextField *textField = (UITextField *)[cell viewWithTag:350 + index];
    switch (index) {
        case 0:
            //昵称
            textField.text = userInfoSingleton.userInfoModel.nikename;
            NSLog(@"textField.text = %@", textField.text);
            break;
        case 1:
            //联系
            textField.text = userInfoSingleton.userInfoModel.telephone;
            NSLog(@"textField.text = %@", textField.text);
            break;
        case 2:
            //邮箱
            textField.text = userInfoSingleton.userInfoModel.email;
            NSLog(@"textField.text = %@", textField.text);
            break;
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightForCell;
}
- (void)configCellWith:(UIView *)superView index:(NSInteger)index
{
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(superView.width-32, (HeightForCell-18)/2, 18, 18);
    editBtn.backgroundColor = [UIColor clearColor];
    [editBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"修改link" ofType:@"png"]] forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"修改active" ofType:@"png"]] forState:UIControlStateSelected];
    editBtn.tag = 250 + index;
    [superView addSubview:editBtn];
    
    UIControl *contr = [[UIControl alloc] initWithFrame:CGRectMake(superView.width-32, 0, HeightForCell, HeightForCell)];
    contr.tag = 150+index;
    [contr addTarget:self action:@selector(editContr:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:contr];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 160, HeightForCell)];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
    textLabel.text = titleNameArr[index];
    [superView addSubview:textLabel];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.width*0.3, 0, self.view.width*.6, HeightForCell)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.text = indvidualInfoArr[index];
    textField.font = [UIFont systemFontOfSize:14];
    textField.textColor = [UIColor colorFromHexRGB:@"666666"];
    textField.enabled = NO;
    textField.tag = 350 + index;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeySend;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    if (index==0) {
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    else if(index==1){
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    else if(index==2){
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    
    [superView addSubview:textField];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, HeightForCell-1, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"f5f5f5"];
    [superView addSubview:lineView];
}

#pragma mark ==Edit Btn==
- (void)editContr:(UIControl *)control
{
    static NSInteger index = 1000;
    NSLog(@"control.tag = %i", control.tag-150);
    
    UIButton *button = (UIButton *)[self.view viewWithTag:control.tag+100];
    _activityEditButton = button;
    button.selected = YES;
    
    UITextField *textField = (UITextField *)[self.view viewWithTag:(button.tag+100)];
    textField.enabled = YES;
    [textField becomeFirstResponder];
    
    if (control.tag != index) {
        
        UIButton *lastButton = (UIButton *)[self.view viewWithTag:index+100];
        lastButton.selected = NO;
        
        UITextField *lastTextField = (UITextField *)[self.view viewWithTag:(index+200)];
        lastTextField.enabled = NO;
        
        index = control.tag;
    }
    
    
}

/**
 *  键盘回收 事件处理
 *
 *  @param 键盘回收
 *
 *
 *  @return YES
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    textField.enabled = NO;
    UIButton *button = (UIButton *)[self.view viewWithTag:textField.tag-100];
    
    button.selected = NO;
    
    //传送请求修改数据
//    [self requestUpdateInfo];
    
    
    return YES;
}

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

/**
 *  请求修改数据
 */
- (void)requestUpdateInfo
{
    ParametersManagerObject *managerObject = [[ParametersManagerObject alloc] init];
    
    UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedInstance];
    //uid、authcode、nickname、mobile、email
    [managerObject addParamer:[NSString stringWithFormat:@"uid=%@", userInfoSingleton.userInfoModel.id]];
    
    UITextField *nameText = (UITextField *)[self.view viewWithTag:350];
    if (nameText.text.length) {
        [managerObject addParamer:[NSString stringWithFormat:@"nickname=%@", nameText.text]];
        NSLog(@"nameText = %@", nameText.text);
    }
    
    UITextField *mobileText = (UITextField *)[self.view viewWithTag:351];
    if (mobileText.text.length) {
        [managerObject addParamer:[NSString stringWithFormat:@"mobile=%@", mobileText.text]];
    }
    
    UITextField *emailText = (UITextField *)[self.view viewWithTag:352];
    if (emailText.text.length) {
        [managerObject addParamer:[NSString stringWithFormat:@"email=%@", emailText.text]];
    }
    

    
    NSString* urlstr = [updateInfoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *loginUrl = [NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[managerObject getAddParamer:[NSArray arrayWithObject:[NSString stringWithFormat:@"authcode=%@", userInfoSingleton.userInfoModel.authcode]]]];
    
    
    NSURLConnection *historyConn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if (historyConn) {
        _infoData = [[NSMutableData alloc] init];
        
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
    [_infoData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"连接服务器超时,请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alow show];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError *error1 = [[NSError alloc] init];
    NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:_infoData options:NSJSONReadingMutableContainers error:&error1];
    NSLog(@"rr = %@",resultsDictionary);
    
    if ([[resultsDictionary objectForKey:@"result"] isEqualToString:@"ok"]) {
        
        //存储修改的数据到单例类
        UserInfoSingleton *userInfo = [UserInfoSingleton sharedInstance];
        
        UITextField *nameText = (UITextField *)[self.view viewWithTag:350];
        userInfo.userInfoModel.nikename = nameText.text;
        
        UITextField *mobileText = (UITextField *)[self.view viewWithTag:351];
        userInfo.userInfoModel.telephone = mobileText.text;
        
        UITextField *emailText = (UITextField *)[self.view viewWithTag:352];
        userInfo.userInfoModel.email = emailText.text;
        
        //通知菜单页改变数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginNotification" object:nil];
        
        //通知用户中心修改昵称
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNickname" object:nil];
        
        self.nameLabel.text = [UserInfoSingleton sharedInstance].userInfoModel.nikename;
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.title = @"温馨提示";
        alertView.message = @"用户信息修改成功";
        [alertView addButtonWithTitle:@"确定"];
        alertView.delegate = self;
        
        [alertView show];
        
        
        
    }
    else{
        
        UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[[resultsDictionary objectForKey:@"data"] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alow show];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [_activityTextField resignFirstResponder];
    
    //回收键盘,改变编辑按钮图片
    _activityEditButton.selected = NO;
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

    if (![_lastString isEqualToString:_activityTextField.text]) {
        
        if (_activityTextField.tag == 351 ) {
            
            if ([NSString isValidateMobile:_activityTextField.text]) {
                [self requestUpdateInfo];
            }
            else {
                
                _activityTextField.text = _lastString;
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请填写正确的联系电话" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            
        }
        else if(_activityTextField.tag == 352) {
            if ([NSString isValidateEmail:_activityTextField.text]) {
                [self requestUpdateInfo];
            }
            else {
                _activityTextField.text = _lastString;
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请填写正确的Email" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
        }
        else if(_activityTextField.tag == 350) {
            if (_activityTextField.text != _lastString) {
                
                //判断是否为空
                if (_activityTextField.text.length) {
                    [self requestUpdateInfo];
                }
                else {
                    _activityTextField.text = _lastString;
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"昵称不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    _activityTextField = textField;
    _lastString = _activityTextField.text;
    
}

#pragma mark ==Function Menu Click==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
