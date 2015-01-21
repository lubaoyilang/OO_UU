//
//  MruMakeViewController.m
//  UThing
//
//  Created by luyuda on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "MruMakeViewController.h"
#import "MyOrderListViewController.h"


@interface MruMakeViewController ()

@end

@implementation MruMakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self downLoadDataWithType:1];
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
