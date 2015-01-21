//
//  TextFieldAndSelectedView.h
//  UThing
//
//  Created by Apple on 14/12/3.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UthingAlertView.h"


@interface TextFieldAndSelectedView : UIView

@property (nonatomic, strong) UIControl *button;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UthingAlertView *alertView;


- (id)initWithFrame:(CGRect)frame;

@end
