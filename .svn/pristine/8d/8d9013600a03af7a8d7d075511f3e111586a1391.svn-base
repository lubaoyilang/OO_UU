//
//  TourStewardDetailViewController.m
//  UThing
//
//  Created by Apple on 15/1/15.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "TourStewardDetailViewController.h"

@interface TourStewardDetailViewController ()

@property (nonatomic, strong) UIScrollView *backSView; //滚动

@end

@implementation TourStewardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //背景色
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"eeeeee"];
    
    
    
    [self initView];
    
    
}



/*
 * 视图控件
 */
#pragma mark -
#pragma mark ==view==
- (void)initView
{
    //滚动视图
    _backSView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _backSView.showsVerticalScrollIndicator = NO;
    _backSView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_backSView];
    
    
    //头像基本信息
    UIView *headInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 250)];
    headInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headInfoView];
    
      //大视图背景
    UIImageView *bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 180)];
    bigImageView.image = LOADIMAGE(@"app-详情页_40", @"png");
    [headInfoView addSubview:bigImageView];
    
      //头像
    UIImageView *headIconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 150, 60, 60)];
    headIconView.image = LOADIMAGE(@"headPortrait", @"jpg");
    headIconView.clipsToBounds = YES;
    headIconView.layer.cornerRadius = 30;
    [headInfoView addSubview:headIconView];
    
      //所属机构
    UILabel *organizationLabel = [UILabel labelWithFrame:CGRectMake(70, 210, 200, 20) text:[NSString stringWithFormat:@"所属机构: %@", @""]];
    organizationLabel.font = [UIFont systemFontOfSize:12];
    [headIconView addSubview:organizationLabel];
    
      //认证状态
    UILabel *statusLabel = [UILabel labelWithFrame:CGRectMake(70, 230, 200, 20) text:[NSString stringWithFormat:@"认证状态: %@", @""]];
    statusLabel.font = [UIFont systemFontOfSize:12];
    [headIconView addSubview:statusLabel];
    
      //关注按钮
    UIButton *attentionButton = [UIButton systemButtonWithFrame:CGRectMake(kMainScreenWidth-60, 200, 50, 20) title:@"+关注" image:nil action:^(UIButton *button) {
        
        if (attentionButton.selected) {
            attentionButton.selected = NO;
        } else {
            attentionButton.selected = YES;
        }
        
    }];
    attentionButton.selected = NO;
    attentionButton.backgroundColor = [UIColor colorFromHexRGB:@"ff6600"];
    [attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [attentionButton setTitle:@"已关注" forState:UIControlStateSelected];
    attentionButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:attentionButton];
    
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
