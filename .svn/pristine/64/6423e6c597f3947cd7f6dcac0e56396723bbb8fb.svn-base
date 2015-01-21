//
//  DiscoverViewController.m
//  UThing
//
//  Created by luyuda on 15/1/14.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "DiscoverViewController.h"


#import "PriceSectionView.h"

#import "TourStewardDetailViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    PriceSectionView *priceSectionView = [[PriceSectionView alloc] initWithFrame:CGRectMake(30, 200, kMainScreenWidth-60, 20) maxNum:1000 minNum:100];
    priceSectionView.tag = 1000;
    [self.view addSubview:priceSectionView];
    

    UIButton *SZBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SZBtn.frame = CGRectMake(100, 100, 30, 20);
    [SZBtn setTitle:@"按我" forState:UIControlStateNormal];
    SZBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    SZBtn.titleLabel.textColor = [UIColor whiteColor];
    [SZBtn addTarget:self action:@selector(nameClick:) forControlEvents:UIControlEventTouchUpInside];
    SZBtn.backgroundColor = [UIColor colorFromHexRGB:@"<#HexRGB#>"];
    [self.view addSubview:SZBtn];
    
}

- (void)nameClick:(UIButton *)button
{
    PriceSectionView *view = (PriceSectionView *)[self.view viewWithTag:1000];
    NSLog(@"view = %f, %f", view.currentMax, view.currentMin);
    
    TourStewardDetailViewController *tsdc = [[TourStewardDetailViewController alloc] init];
    [self.navigationController pushViewController:tsdc animated:YES];
}


/**
 *  价格区间视图
 */
- (void)initPriceSectionView
{
    
}




@end
