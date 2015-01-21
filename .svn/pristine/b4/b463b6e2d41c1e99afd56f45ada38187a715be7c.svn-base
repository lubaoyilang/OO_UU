//
//  MyOrderFillInView.m
//  UThing
//
//  Created by Apple on 14/11/20.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "MyOrderFillInView.h"
#import <QuartzCore/QuartzCore.h>

#import "TextFieldAndSelectedView.h"
#import "QBFlatButton.h"
#import "FillInTextField.h"

#define IS_CH_SYMBOL(chr) ((int)(chr)>127)

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface MyOrderFillInView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UIView *passengerInfoBackView;
@property (nonatomic, strong) UIView *orderPeopleInfoBackView;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *nationalityTextField;
@property (nonatomic, strong) UITextField *documentTypeTextField;
@property (nonatomic, strong) UITextField *documentNumberTextField;
@property (nonatomic, strong) UITextField *contactNumberTextField;

@property (nonatomic, strong) UITextField *orderNameTextField;
@property (nonatomic, strong) UITextField *orderContactNumberTextField;
@property (nonatomic, strong) UITextField *orderEmailTextField;
@property (nonatomic, strong) UITextField *orderTimeTextField;

@property (nonatomic, strong) NSArray *peopleCountArr;

@property (nonatomic, strong) QBFlatButton *commitOrderBtn;

@property (nonatomic, strong) NSMutableArray *orderInfoArr;
@property (nonatomic, strong) NSMutableDictionary *orderInfoDict;
@property (nonatomic, strong) UITextField *activityTextField;

@property (nonatomic, strong) UthingAlertView *alertView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGr;

@property (nonatomic, strong) NSMutableArray *genderArray;

@end

@implementation MyOrderFillInView

- (id)initWithFrame:(CGRect)frame productInfo:(NSMutableDictionary *)proInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        int people_no = [[proInfo objectForKey:@"adultNum"] intValue] + [[proInfo objectForKey:@"childNum"] intValue];
        
        _genderArray = [[NSMutableArray alloc] init];
        
        NSLog(@"people_no = %i", people_no);
        for (int i=0; i<people_no; i++) {
            [_genderArray addObject:@"男"];
        }
        
        self.productInfo = proInfo;
        self.userInteractionEnabled = YES;
        
        [self createMainView];
    }
    return self;
}

- (void)createMainView
{
    [self settingMemory];
    
    [self createBackScrollView];
    
    [self passengerInfoView];
    
    [self theOrderPeopleInfoView];
    
    [self createTheCommitOrderBtn];
    
    _backScrollView.contentSize = CGSizeMake(kMainScreenWidth, _commitOrderBtn.frame.origin.y+_commitOrderBtn.frame.size.height+10);
    
    //
    _tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    _tapGr.cancelsTouchesInView = NO;
    [self addGestureRecognizer:_tapGr];
}

/**
 *  键盘外点击回收键盘
 *
 *  @param tapGr 点击手势
 */
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_activityTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activityTextField = textField;
    
    [_alertView hide:YES];
}


- (void)settingMemory
{
    _peopleCountArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
}


- (void)createBackScrollView
{
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.bounds];
    backView.image = [UIImage imageNamed:@"list-bg.png"];
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    
    _backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [backView addSubview:_backScrollView];
}

#pragma mark ==Passenger Info View==
- (void)passengerInfoView
{
    int people_no = [[_productInfo objectForKey:@"adultNum"] intValue]+[[_productInfo objectForKey:@"childNum"] intValue];
    _passengerInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 31+ people_no*200)];
    _passengerInfoBackView.userInteractionEnabled = YES;
    [_backScrollView addSubview:_passengerInfoBackView];
    
    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 30)];
    titleBackView.backgroundColor = [UIColor whiteColor];
    [_passengerInfoBackView addSubview:titleBackView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    iconView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app-订单填写_passenger" ofType:@"png"]];
    [_passengerInfoBackView addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 30)];
    titleLabel.text = @"旅客信息";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [_passengerInfoBackView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kMainScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"6c554f"];
    [_passengerInfoBackView addSubview:lineView];
    
    for (int i=0; i<people_no; i++) {
        UIView *view = [self singlePassengerInfoViewWith:i];
        [_passengerInfoBackView addSubview:view];
    }
    
}

- (UIView *)singlePassengerInfoViewWith:(NSInteger)index
{
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 31+(200)*index, kMainScreenWidth, 200)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, kMainScreenWidth*.25, 6)];
    leftView.image = [[UIImage imageNamed:@"app-订单填写_02.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [view addSubview:leftView];
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth*.75, 15, kMainScreenWidth*.25, 6)];
    rightView.image = [[UIImage imageNamed:@"app-订单填写_04.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [view addSubview:rightView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"第%i位旅客", index+1];
                       //_peopleCountArr[index]];
    [titleLabel sizeToFit];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.bounds.size.width-5, 0, kMainScreenWidth*0.27, 25)];
    subTitleLabel.text = @"(成人/儿童)";
    [subTitleLabel sizeToFit];
    subTitleLabel.font = [UIFont systemFontOfSize:12];
    subTitleLabel.textColor = [UIColor lightGrayColor];
    [titleView addSubview:subTitleLabel];
    
    [titleView setFrame:CGRectMake(0, 0, titleLabel.bounds.size.width+subTitleLabel.bounds.size.width, 30)];
    titleView.center = CGPointMake(kMainScreenWidth/2+15, 25);
    [view addSubview:titleView];
    
    
    //name
    UIImageView *imageView1 = [UIImageView imageViewWithFrame:CGRectMake(kMainScreenWidth*0.25-33, 48, 5, 5) image:nil];
    imageView1.image = LOADIMAGE(@"xing", @"png");
    [view addSubview:imageView1];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth*0.25, 25)];
    nameLabel.text = @"姓名";
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:nameLabel];
    
    _nameTextField = [self createTextFieldWithFrame:CGRectMake(kMainScreenWidth*0.27, 40, kMainScreenWidth-kMainScreenWidth*0.27-30, 25)];
    _nameTextField.tag = 200 + index*10 +1;
    _nameTextField.keyboardType  = UIKeyboardTypeNamePhonePad;
    [view addSubview:_nameTextField];
    
    
    //gender
    UIImageView *imageView2 = [UIImageView imageViewWithFrame:CGRectMake(kMainScreenWidth*0.25-33, 78, 5, 5) image:nil];
    imageView2.image = LOADIMAGE(@"xing", @"png");
    [view addSubview:imageView2];
    
    
    UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, kMainScreenWidth*0.25, 25)];
    genderLabel.text = @"性别";
    genderLabel.font = [UIFont systemFontOfSize:12];
    genderLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:genderLabel];
    
    
    UILabel *manAndWomenLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth*0.33, 70, 150, 25)];
    manAndWomenLabel.text = @"男      女";
    manAndWomenLabel.font = [UIFont systemFontOfSize:12];
    manAndWomenLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:manAndWomenLabel];
    
    
    UIImage *image1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"radio-2" ofType:@"png"]];
    UIImage *image2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"radio-1" ofType:@"png"]];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(kMainScreenWidth*0.29, 77.5, 10, 10);
    button1.tag = 900+index*10;
    [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(theGenderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(kMainScreenWidth*0.39, 77.5, 10, 10);
    button2.tag = 901+index*10;
    [button2 setBackgroundImage:image2 forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(theGenderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button2];
    
    
    //nationality
    //证件类型
    UILabel *documentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kMainScreenWidth*0.25, 25)];
    documentLabel.text = @"证件类型";
    documentLabel.font = [UIFont systemFontOfSize:12];
    documentLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:documentLabel];

//    _documentTypeTextField = [self createTextFieldWithFrame:CGRectMake(kMainScreenWidth*0.27, 100, kMainScreenWidth-kMainScreenWidth*0.27-30-20, 25)];
//    _documentTypeTextField.tag = 200 + index*10 + 3;
//    _documentTypeTextField.text = @"身份证";
//    _documentTypeTextField.font = [UIFont systemFontOfSize:10];
//    _documentTypeTextField.textColor = [UIColor colorFromHexRGB:@"666666"];
//    _documentTypeTextField.enabled = NO;
//    _documentTypeTextField.textAlignment = NSTextAlignmentLeft;
//    [view addSubview:_documentTypeTextField];
//    
//    UIButton *_selectedTypeBtn = [UIButton systemButtonWithFrame:CGRectMake(kMainScreenWidth-50, 102, 20, 21) title:nil image:@"app-订单填写_11" action:^(UIButton *button) {
//        
//        [self alertViewWithIndex:index];
//        
//    }];
//    [view addSubview:_selectedTypeBtn];
    
    TextFieldAndSelectedView *_arriveView = [[TextFieldAndSelectedView alloc] initWithFrame:CGRectMake(kMainScreenWidth*0.27, 100, kMainScreenWidth-kMainScreenWidth*0.27-30, 25)];
    _arriveView.tag = 200 +index*10+3;
    _arriveView.textField.text = @"身份证";
    _arriveView.textField.layer.borderColor = [UIColor colorFromHexRGB:@"efefef"].CGColor;
    _arriveView.textField.backgroundColor = [UIColor whiteColor];
    _arriveView.button.tag = 9000;
    [_arriveView.button addTarget:self action:@selector(clickShowView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_arriveView];
    
    
    
    
    //证件号码
    UILabel *documentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, kMainScreenWidth*0.25, 25)];
    documentNumberLabel.text = @"证件号码";
    documentNumberLabel.font = [UIFont systemFontOfSize:12];
    documentNumberLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:documentNumberLabel];
    

    
    _documentNumberTextField = [self createTextFieldWithFrame:CGRectMake(kMainScreenWidth*0.27, 130, kMainScreenWidth-kMainScreenWidth*0.27-30, 25)];
    _documentNumberTextField.tag = 200 + index*10 +4;
    _documentNumberTextField.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
    [view addSubview:_documentNumberTextField];
    
    
    
    //contactNumber
    UILabel *contactNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, kMainScreenWidth*0.25, 25)];
    contactNumberLabel.text = @"联系电话";
    contactNumberLabel.font = [UIFont systemFontOfSize:12];
    contactNumberLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:contactNumberLabel];
    
    _contactNumberTextField = [self createTextFieldWithFrame:CGRectMake(kMainScreenWidth*0.27, 160, kMainScreenWidth-kMainScreenWidth*0.27-30, 25)];
    _contactNumberTextField.tag = 200 + index*10 +5;
    _contactNumberTextField.keyboardType  = UIKeyboardTypeNumberPad;
    [view addSubview:_contactNumberTextField];
    
    
    return view;
}


- (void)clickShowView:(id)sender
{
    
    UthingAlertView *alertView = [(TextFieldAndSelectedView *)[sender superview] alertView];
    __block NSArray *array = @[@"身份证", @"因私护照(P)", @"因公护照(I)", @"外交护照(D)", @"港澳通行证", @"台湾通行证", @"签证身份证"];
    alertView.selections = array;
    [alertView showFromView:self  animated:YES];
    
    
    alertView.selectedHandle = ^(NSInteger selectedIndex){
        TextFieldAndSelectedView *ts = (TextFieldAndSelectedView *)[sender superview];
        ts.textField.text = array[selectedIndex];
    };
    
    
}

- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[FillInTextField alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+2, frame.size.width, frame.size.height-4)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont systemFontOfSize:12];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.layer.borderColor = [UIColor colorFromHexRGB:@"efefef"].CGColor;
    textField.layer.borderWidth = 1.0f;
    textField.delegate = self;
    
    return textField;
}


#pragma mark ==The Gender Btn==
/**
 *  性别选择
 *
 *  男 tag  900+index*10
 *  女 tag  901+index*10
 *
 *  @param button 点击按钮
 */
- (void)theGenderBtn:(UIButton *)button
{
    UIImage *image1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"radio-2" ofType:@"png"]];
    UIImage *image2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"radio-1" ofType:@"png"]];
    
    [button setBackgroundImage:image1 forState:UIControlStateNormal];
    
    int index = (button.tag-900)/10;
    if ((button.tag-900)%10 == 1) {
        NSLog(@"  gender = %d", index);
        [_genderArray replaceObjectAtIndex:index withObject:@"女"];

    }
    else if((button.tag-900)%10 == 0){
        [_genderArray replaceObjectAtIndex:index withObject:@"男"];
    }
    
    
    [(UIButton *)[self viewWithTag:button.tag-1] setBackgroundImage:image2 forState:UIControlStateNormal];
    [(UIButton *)[self viewWithTag:button.tag+1] setBackgroundImage:image2 forState:UIControlStateNormal];
}

#pragma mark ==Book People Info View==
- (void)theOrderPeopleInfoView
{
    _orderPeopleInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _passengerInfoBackView.bounds.size.height+10, kMainScreenWidth, 140)];
    _orderPeopleInfoBackView.userInteractionEnabled = YES;
    [_backScrollView addSubview:_orderPeopleInfoBackView];
    
    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 30)];
    titleBackView.backgroundColor = [UIColor whiteColor];
    [_orderPeopleInfoBackView addSubview:titleBackView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    iconView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app-订单填写_10" ofType:@"png"]];
    [titleBackView addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 30)];
    titleLabel.text = @"预订人信息";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleBackView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kMainScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"6c554f"];
    [_orderPeopleInfoBackView addSubview:lineView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 31, kMainScreenWidth, 109)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    [_orderPeopleInfoBackView addSubview:view];
    
    
    UIImageView *imageView1 = [UIImageView imageViewWithFrame:CGRectMake(kMainScreenWidth*0.27-33, 13, 5, 5) image:nil];
    imageView1.image = LOADIMAGE(@"xing", @"png");
    [view addSubview:imageView1];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, kMainScreenWidth*0.27, 25)];
    nameLabel.text = @"姓名";
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:nameLabel];
    
    _orderNameTextField = [self createTextFieldWithFrame:CGRectMake(kMainScreenWidth*0.3, 5, kMainScreenWidth-kMainScreenWidth*0.3-40, 25)];
    _orderNameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [view addSubview:_orderNameTextField];
    
    UIImageView *imageView2 = [UIImageView imageViewWithFrame:CGRectMake(kMainScreenWidth*0.27-57, 43, 5, 5) image:nil];
    imageView2.image = LOADIMAGE(@"xing", @"png");
    [view addSubview:imageView2];
    
    UILabel *contactNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, kMainScreenWidth*0.27, 25)];
    contactNumberLabel.text = @"联系电话";
    contactNumberLabel.font = [UIFont systemFontOfSize:12];
    contactNumberLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:contactNumberLabel];
    
    _orderContactNumberTextField = [self createTextFieldWithFrame:CGRectMake(kMainScreenWidth*0.3, 35, kMainScreenWidth-kMainScreenWidth*0.3-40, 25)];
    _orderContactNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    [view addSubview:_orderContactNumberTextField];
    
    UILabel *EmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, kMainScreenWidth*0.27, 25)];
    EmailLabel.text = @"Email";
    EmailLabel.font = [UIFont systemFontOfSize:12];
    EmailLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:EmailLabel];
    
    _orderEmailTextField = [self createTextFieldWithFrame:CGRectMake(kMainScreenWidth*0.3, 65, kMainScreenWidth-kMainScreenWidth*0.3-40, 25)];
    _orderEmailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [view addSubview:_orderEmailTextField];
    
}

#pragma mark - ====UITextField delegate=====
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag%10 == 5) {
        if (![NSString isValidateMobile:textField.text]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"联系电话填写错误,请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
            textField.text = @"";
        }
    }
    
    //
    if (textField == _orderContactNumberTextField) {
        NSLog(@"textFieldEndEditing");
        if ([NSString isValidateMobile:_orderContactNumberTextField.text]==NO) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请填入正确的联系电话" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
            //[_orderContactNumberTextField becomeFirstResponder];
        }
    }
}


//#pragma mark ==Identity Card==
///**
// *  证件类型 选择
// *
// *  @param singleIndex 选择第几项
// */
//- (void)alertViewWithIndex:(NSInteger)singleIndex
//{
//    
//    NSArray *array = @[@"身份证", @"因私护照(P)", @"因公护照(I)", @"外交护照(D)", @"港澳通行证", @"台湾通行证", @"签证身份证"];
//
//    _alertView = [[UthingAlertView alloc] init];
//    
// 
//    _alertView.selections = array;
//    [_alertView showFromView:self  animated:YES];
//
//    WS(ws);
//    
//    _alertView.selectedHandle = ^(NSInteger selectedIndex){
//        
//        
//
//    };
//    
//}

/**
 *  提交按钮
 */
- (void)createTheCommitOrderBtn
{
    _commitOrderBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    _commitOrderBtn.frame = CGRectMake(0, _orderPeopleInfoBackView.frame.origin.y+_orderPeopleInfoBackView.frame.size.height+20, kMainScreenWidth, 40);
    _commitOrderBtn.faceColor =[UIColor colorWithRed:244.0/255.0 green:135.0/255.0 blue:12.0/255.0 alpha:1.0];
    _commitOrderBtn.sideColor = [UIColor colorWithRed:203.0/255.0 green:87.0/255.0 blue:0.0/255.0 alpha:1.0];
    _commitOrderBtn.radius = 0.0;
    _commitOrderBtn.margin = 0.0;
    _commitOrderBtn.depth = 2.0;
    _commitOrderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_commitOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [_commitOrderBtn addTarget:self action:@selector(commitTheOrder) forControlEvents:UIControlEventTouchUpInside];
    
    [_backScrollView addSubview:_commitOrderBtn];
}

/**
 *  提交订单 点击事件
 */
- (void)commitTheOrder
{
    //判断预订人信息 联系人 和 联系方式是否已填 或填写正确
    if (_orderNameTextField.text.length!=0 && _orderContactNumberTextField.text.length!=0) {
        //收集信息
        [self collectTheOrderInfo];
        
        
        //判断是否乘客信息填写不完整
        int people_no = [[_productInfo objectForKey:@"adultNum"] intValue] + [[_productInfo objectForKey:@"childNum"] intValue];
        int i;
        for (i=0; i<people_no; i++) {
            UITextField *textField = (UITextField *)[self viewWithTag:200+i*10+1];
            if (textField.text.length == 0) {
                break;
            }
        }

        if (i == people_no) {
            //
            
            
            //判断乘客信息是否重复
            NSMutableArray *guestArray = [[NSMutableArray alloc] init];
            for (int j=0; j<people_no; j++) {
                
                NSString *singleGuestInfoString = [NSString stringWithFormat:@"%@",[[_proInfo objectForKey:@"guest_info"] objectAtIndex:j]];
                [guestArray addObject:singleGuestInfoString];
            }
            int breakNum = 0;
            for (int j=0; j<guestArray.count; j++) {
                for (int m=j+1; m<guestArray.count; m++) {
                    if ([[guestArray objectAtIndex:j] isEqualToString:[guestArray objectAtIndex:m]]) {
                        breakNum++;
                        break;
                        
                    }
                }
                
            }
            NSLog(@"guestArray = %d", breakNum);
            if (!breakNum || guestArray.count==1) {
                if ([NSString isValidateMobile:_orderContactNumberTextField.text]) {
                    [self.m_delegate commitTheOrderFillInInfo:_proInfo];
                }
                else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"预订人联系方式填写有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"旅客信息重复" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            
            
            
            
            
            
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请填写完整旅客信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
        
        
        
        
        
        
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"预订人信息填写有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
    
}



#pragma mark ==Collect The Order Info==
/**
 *  收集用户填写信息
 *
 *  旅客信息中控件tag值(textField) index代表第几位乘客
 *    姓名       name         200+index*10+1
 *    证件类型    credential   200+index*10+3
 *    证件号     id           200+index*10+4
 *    联系电话    mobile       200+index*10+5
 *
 */
- (void)collectTheOrderInfo
{
    _proInfo = [[NSMutableDictionary alloc] init];
    
    [_proInfo setObject:@"1" forKey:@"status"];
    
    int people_no = [[_productInfo objectForKey:@"adultNum"] intValue] + [[_productInfo objectForKey:@"childNum"] intValue];
    [_proInfo setObject:[NSString stringWithFormat:@"%d", people_no] forKey:@"people_no"];
    
    NSLog(@"_people_no = %i", [[_proInfo objectForKey:@"people_no"] intValue]);
    //旅客信息 guest Info
    NSMutableArray *passengerInfoArr = [[NSMutableArray alloc] init];
    for (int i=0; i<[[_proInfo objectForKey:@"people_no"] intValue]; i++) {
        
        //单个旅客信息
        NSMutableDictionary *singleGuestInfoDict = [[NSMutableDictionary alloc] init];
        
        UITextField *textField;
        for (int j=1; j<=5; j++) {
            if (j == 3) {
                TextFieldAndSelectedView *ts = (TextFieldAndSelectedView *)[self.passengerInfoBackView viewWithTag:200+i*10+j];
                textField = ts.textField;
            }
            else {
                textField = (UITextField *)[self.passengerInfoBackView viewWithTag:(200+i*10+j)];
            }

            switch (j) {
                case 1:
                    [singleGuestInfoDict setObject:textField.text forKey:@"name"];
                    break;
                case 3:
                    [singleGuestInfoDict setObject:textField.text forKey:@"credential"];
                    break;
                case 4:
                    [singleGuestInfoDict setObject:textField.text forKey:@"id"];
                    break;
                case 5:
                    [singleGuestInfoDict setObject:textField.text forKey:@"mobile"];
                    break;
                    
                default:
                    break;
            }
            
        }
        //性别
        [singleGuestInfoDict setObject:_genderArray[i] forKey:@"sex"];
        
        //乘客信息
        [passengerInfoArr addObject:singleGuestInfoDict];
        
    }
    [_proInfo setObject:passengerInfoArr forKey:@"guest_info"];
    
    //预订人信息
    [_proInfo setObject:_orderNameTextField.text forKey:@"contact_name"];
    [_proInfo setObject:_orderContactNumberTextField.text forKey:@"contact_mobile"];
    [_proInfo setObject:_orderEmailTextField.text forKey:@"contact_email"];
    
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

@end
