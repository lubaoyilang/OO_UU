//
//  UthingFeedbackViewController.m
//  UThing
//
//  Created by luyuda on 14/11/21.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "UthingFeedbackViewController.h"
#import "QBFlatButton.h"
#import "ParametersManagerObject.h"
#import "ProductDetailViewController.h"
#import "WQKeyChain.h"

@interface UthingFeedbackViewController ()

@property (nonatomic,strong)UILabel *pLabel;
@property (nonatomic,strong)NSMutableData *receivedData;
@property (nonatomic,strong)UITextView *textV;
@end

@implementation UthingFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    [self initView];
    
}
- (void) viewDidLayoutSubviews {
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    viewBounds.origin.y = topBarOffset * -1;
    self.view.bounds = viewBounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    
    _pLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 160, 20)];
    _pLabel.textColor = RGBCOLOR(195, 195, 195);
    _pLabel.font = [UIFont systemFontOfSize:14];
    _pLabel.backgroundColor = [UIColor clearColor];
    _pLabel.text = @"请留下您的宝贵建议";
    [self.view addSubview:_pLabel];
    
    _textV = [[UITextView alloc] initWithFrame:CGRectMake(15, 20, self.view.width-30, 200)];
    _textV.font = [UIFont systemFontOfSize:14];
    _textV.delegate = self;
    [_textV.layer setBorderWidth:1];
    _textV.returnKeyType = UIReturnKeyDone;
    _textV.backgroundColor = [UIColor clearColor];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 237/255.0, 237/255.0, 237/255.0, 1 });
    
    [_textV.layer setBorderColor:colorref];
    [self.view addSubview:_textV];

    
    
    [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
    [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
    
    
    QBFlatButton *payBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(15, 250, self.view.width-30, 40);
    payBtn.faceColor =[UIColor colorWithRed:244.0/255.0 green:135.0/255.0 blue:12.0/255.0 alpha:1.0];
    payBtn.sideColor = [UIColor colorWithRed:203.0/255.0 green:87.0/255.0 blue:0.0/255.0 alpha:1.0];
    payBtn.radius = 0.0;
    payBtn.margin = 0.0;
    payBtn.depth = 2.0;
    payBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setTitle:@"提交" forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(updateFeedBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payBtn];
    
    

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    
    
    return YES;
}




- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length]) {
        _pLabel.text = @"";
    }else{
        _pLabel.text = @"请留下您的宝贵建议";
    }

}




- (void)updateFeedBack
{
    
    
    ParametersManagerObject *pObject = [[ParametersManagerObject alloc] init];
    
    if (![_textV.text length]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"警告"
                                                        message: @"请输入反馈内容"
                                                       delegate: nil
                                              cancelButtonTitle: @"确定"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    
    NSString *name = @"system=ios"; //key username
    NSString *pwd =[NSString stringWithFormat:@"sn=%@",[NSString getUuid]] ; //key = password
    NSString *text = [NSString stringWithFormat:@"feedback=%@",_textV.text];

    
    [pObject addParamer:name];
    [pObject addParamer:pwd];
    [pObject addParamer:text];
    
    

    
    
    
    NSString* urlstr = [feedBackURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *loginUrl = [NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[pObject getHeetBody]];
    NSURLConnection *historyConn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if (historyConn) {
        _receivedData = [[NSMutableData alloc] initWithData:nil];
        [self showHub:@"反馈上传中..."];
        
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
    [_receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self hideHub];
    
    
    UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"连接服务器超时,请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alow show];
    
    
    
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    SBJsonParser *sbp = [[SBJsonParser alloc] init];
    
    NSDictionary *dict = [sbp objectWithData:_receivedData];
    
    NSString *resultCode = [dict objectForKey:@"result"];
    if ([resultCode isEqualToString:@"ok"]) {
        
        id dataDict = [dict objectForKey:@"data"];
        NSString *sign = [dict objectForKey:@"sign"];
        NSLog(@"%@",dataDict);
        ParametersManagerObject *p = [[ParametersManagerObject alloc] init];
        BOOL isSign = [p checkSign:dataDict Sign:sign];
        
        if (isSign) {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的需求我们已经获知，我们的工作人员会尽快与您取得联系" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            
        }else{
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"警告" message:@"上传数据出错，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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


















@end
