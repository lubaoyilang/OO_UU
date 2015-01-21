//
//  BaseViewController.m
//  UThing
//
//  Created by luyuda on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "BaseViewController.h"
#import "IIViewDeckController.h"
#import "UthingShareViewController.h"
//#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "UserInfoSingleton.h"

#define   IOS7_NAVI_SPACE   -10


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;

    }
    
    [self initBaritems];
    
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma InitView

- (void)initBaritems
{

    
    
    UIViewController *topController =self.navigationController.topViewController;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22*3+14, 32)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton *telButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 22, 22)];
    
    [telButton setBackgroundImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [telButton addTarget:self action:@selector(telAction) forControlEvents:UIControlEventTouchUpInside];
    [telButton setBackgroundImage:[UIImage imageNamed:@"电话"] forState:UIControlStateHighlighted];
    
   
    
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(29, 5, 22, 22)];
    
    [searchButton setBackgroundImage:[UIImage imageNamed:@"搜索1"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"搜索1"] forState:UIControlStateHighlighted];
    
    
    
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(58, 5, 22, 22)];
    
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateHighlighted];
    
    
    
    
    if ([[[topController class] description] isEqualToString:@"MruMakeViewController"]      ||
        [[[topController class] description] isEqualToString:@"HotelPackagesViewController"] ||
        [[[topController class] description] isEqualToString:@"FreeTourViewController"]     ||
        [[[topController class] description] isEqualToString:@"DestinationViewController"] ||
        [[[topController class] description] isEqualToString:@"OverseasTourViewController"] ||
        [[[topController class] description] isEqualToString:@"HomePageViewController"]||
        [[[topController class] description] isEqualToString:@"ProductDetailViewController"] ||
        [[[topController class] description] isEqualToString:@"HotelProductDetailViewController"]
        )
    {
            telButton.frame =CGRectMake(0, 5, 22, 22);
            searchButton.frame =CGRectMake(29+8, 5, 22, 22);
            shareButton.frame =CGRectMake(58+15, 5, 22, 22);
            [rightView addSubview:telButton];
            [rightView addSubview:shareButton];
            [rightView addSubview:searchButton];
        rightView.frame = CGRectMake(0, 0, 22*3+30, 32);
        UIBarButtonItem *allRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        
        
        UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:self
                                                                                   action:nil];
        flexSpacer.width = IOS7_NAVI_SPACE;
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:flexSpacer,allRight, nil]];
        
        
        
    }else{
        
        
        telButton.frame =CGRectMake(0, 5, 22, 22);
        searchButton.frame =CGRectMake(29+10, 5, 22, 22);
        [rightView addSubview:telButton];
        [rightView addSubview:searchButton];
        
        rightView.frame = CGRectMake(0, 0, 22*2+20, 32);
        
        
        UIBarButtonItem *allRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        
        
        UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:self
                                                                                   action:nil];
        flexSpacer.width = IOS7_NAVI_SPACE;
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:flexSpacer,allRight, nil]];
        
    
    }
    
    
    

    
    
    
    
//    if ([[[topController class] description] isEqualToString:@"MruMakeViewController"] ||
//        [[[topController class] description] isEqualToString:@"HotelPackagesViewController"] ||
//        [[[topController class] description] isEqualToString:@"FreeTourViewController"] ||
//        [[[topController class] description] isEqualToString:@"DestinationViewController"] ||
//        [[[topController class] description] isEqualToString:@"OverseasTourViewController"] ||
//        [[[topController class] description] isEqualToString:@"HomePageViewController"] ||
//        [[[topController class] description] isEqualToString:@"AboutUthingViewController"]||
//        [[[topController class] description] isEqualToString:@"UserInfoCenterViewController"]||
//        [[[topController class] description] isEqualToString:@"UthingFeedbackViewController"]
//        ){
//        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"菜单"] style:UIBarButtonItemStyleDone target:self.viewDeckController action:@selector(toggleLeftView)];
//        
//        self.navigationItem.leftBarButtonItem = menuItem;
//        
//    }
    

}




#pragma mark - Action


- (void)telAction
{
    
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要拨打客服电话吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    al.tag = 8991;
    [al show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 8991) {
        if (buttonIndex == 1) {
            NSString *phone = [UserInfoSingleton sharedInstance].phone;
            if ([phone length]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];

            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000798790"]];

            }
        }
        
    }
    

}


- (void)searchAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gosearch" object:nil];
}



- (void)shareAction
{
    
    if ([LoginStatusObject isLoginStatus]) {
        
        UthingShareViewController *sha = [[UthingShareViewController alloc] init];
        [self.navigationController pushViewController:sha animated:YES];
    
    }
    
    
}


- (void)changeMenu:(BOOL)isPan
{
    //YES  可以滑动出菜单   NO --NO
    
    if (isPan) {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"ispan"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"menuchange" object:self userInfo:dict];
    }else{
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"ispan"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"menuchange" object:self userInfo:dict];
    }
    
    
    

}


- (void)showHub:(NSString*)text
{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = text;
    
    
    [SVProgressHUD showWithStatus:text maskType:SVProgressHUDMaskTypeGradient];
    
}
- (void)hideHub
{

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
    
}



@end