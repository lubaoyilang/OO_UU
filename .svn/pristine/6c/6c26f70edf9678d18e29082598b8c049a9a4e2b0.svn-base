//
//  TextFieldAndSelectedView.m
//  UThing
//
//  Created by Apple on 14/12/3.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "TextFieldAndSelectedView.h"

@interface TextFieldAndSelectedView ()<UITextFieldDelegate>

@property (nonatomic, strong) NSString *textFieldValueChange;

@end

@implementation TextFieldAndSelectedView
@synthesize button;
@synthesize textField;


- (void)initView
{
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-20, 20)];
    textField.textColor = [UIColor blackColor];
    textField.enabled = NO;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont systemFontOfSize:12];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.layer.borderColor = [UIColor colorFromHexRGB:@"666666"].CGColor;
    textField.layer.borderWidth = 1.0f;
    textField.delegate = self;
    [self addSubview:textField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.frame.size.width-20, 0, 20, 20);
    [btn setBackgroundImage:LOADIMAGE(@"app-订单填写_11", @"png") forState:UIControlStateNormal];
    btn.enabled = NO;
    btn.tag = 9991;
    [self addSubview:btn];
    
    button = [[UIControl alloc] initWithFrame:self.bounds];
    [self addSubview:button];
    
    _alertView  = [[UthingAlertView alloc] init];
    
    
    
    [textField addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _alertView.currentString = textField.text;
}


- (void)dealloc
{
    [textField removeObserver:self forKeyPath:@"text"];
}

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = 20;
    if (self = [super initWithFrame:frame])
    {
        [self initView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
