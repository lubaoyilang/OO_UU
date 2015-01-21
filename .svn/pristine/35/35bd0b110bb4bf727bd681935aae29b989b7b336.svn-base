//
//  AppDelegate.m
//  UThing
//
//  Created by luyuda on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "AppDelegate.h"
#import "MruMakeViewController.h"
#import "OverseasTourViewController.h"
#import "HotelPackagesViewController.h"
#import "FreeTourViewController.h"
#import "DestinationViewController.h"
#import "UthingMenuViewController.h"
#import "IIViewDeckController.h"
#import "MyOrderListViewController.h"
#import "IQKeyboardManager.h"
#import "AboutUthingViewController.h"
#import "UthingShareViewController.h"
#import "UthingFeedbackViewController.h"
#import "LoginStatusObject.h"
#import "SDImageCache.h"
#import "NetworkingCenter.h"
#import "UserInfoSingleton.h"
#import "UthingWelComeViewController.h"

/////////////uthing2.0/////////////////
#import "HomePageViewController.h"
#import "DiscoverViewController.h"
#import "MessagesViewController.h"
#import "UserInfoCenterViewController.h"
#import "MLNavigationController.h"


/////////////shareSDK/////////////////

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
//////////////////////////////////////
#import "APService.h"
#import "ParametersManagerObject.h"
#import "WQKeyChain.h"




@interface AppDelegate ()<welCallBack>

@property (nonatomic,strong)UITabBarController *tabBarController;

@property (nonatomic,strong)IIViewDeckController *vc;
@property (nonatomic,strong)UIViewController *lastViewController;
@property (nonatomic,strong)UINavigationController *homePageController;
@property (nonatomic,strong)UIAlertView *al;
@property (nonatomic,strong)UIAlertView *forceUpdateAl;
@end

@implementation AppDelegate
@synthesize tabBarController;
@synthesize viewDelegate = _viewDelegate;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    
    
  
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ];
    
    [self checkUpdate];
    
    [self initPush:launchOptions];
    
    [self initAutokeyBoard];
    
    [self initShareSDK];
    [self initWel];
    
    [self addLoginNotification];
    [self addPayBackPush];
    [self addSearchNotification];
    
    [self.window makeKeyAndVisible];
    
    return YES;
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}




- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - UserAction
//判断未登录后,跳转界面
- (void)addLoginNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pusthToLoginView) name:@"goLoginViewController" object:nil];

}
- (void)pusthToLoginView
{
    _lastViewController = _vc.centerController;
    

    
    //判断是否是tabBarController
    if (_vc.centerController == tabBarController) {
        
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:login];
        login.delegate = self;
        _vc.centerController = Nav;
        
    }
    else {
        UINavigationController *nav = (UINavigationController *)_vc.centerController;
        UIViewController *viewController = nav.visibleViewController;
        
        if ([NSStringFromClass([viewController class]) isEqualToString:@"LoginViewController"]) {
            NSLog(@"111");
        }
        else{
            NSLog(@"222");
            
            LoginViewController *login = [[LoginViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:login];
            login.delegate = self;
            _vc.centerController = Nav;
            
        }
    }
    
}



- (void)successLogin
{
    if (_lastViewController == tabBarController) {
        _vc.centerController = _lastViewController;
    }
    else {
        UINavigationController *nav = (UINavigationController *)_lastViewController;
        UIViewController *viewController = nav.visibleViewController;
        
        if (_lastViewController && ![NSStringFromClass([viewController class]) isEqualToString:@"LoginViewController"]) {
            _vc.centerController = _lastViewController;
            
        }
        else{
            [_homePageController popToRootViewControllerAnimated:NO];
            _vc.centerController = _homePageController;
        }
    }
    
    if ([_lastViewController isKindOfClass:[UITabBarController class]]) {
        int ControllerNum =[tabBarController.viewControllers count]-1;
        int selectIndex = tabBarController.selectedIndex;
        int tempIndex = ControllerNum-selectIndex;
        if (selectIndex == 2) {
            tempIndex = 0;
        }
        [tabBarController setSelectedIndex:tempIndex];
        [tabBarController setSelectedIndex:selectIndex];
        
    }
    
    
}


- (void)userInfoCenterClickIndex:(NSInteger)index
{
    [_homePageController popToRootViewControllerAnimated:NO];
    _vc.centerController = _homePageController;
}



- (void)successRegister
{
    [_homePageController popToRootViewControllerAnimated:NO];
    _vc.centerController = _homePageController;
}



#pragma mark - PayCallBack

- (void)addPayBackPush
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PayCallBackPush) name:@"payback" object:nil];
    
}

- (void)PayCallBackPush
{
    if ([LoginStatusObject isLoginStatus]) {
        MyOrderListViewController *mm = [[MyOrderListViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:mm];
        _vc.centerController = Nav;
    }
    
    [tabBarController.selectedViewController.navigationController popToRootViewControllerAnimated:NO];
    
    
}

#pragma mark - SearchCallBack

- (void)addSearchNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchCallBackPush) name:@"gosearch" object:nil];
    
}


- (void)searchCallBackPush
{
    _vc.centerController = tabBarController;
    int num =[[tabBarController viewControllers] count]-1;
    
    tabBarController.selectedIndex = num;
    [tabBarController.selectedViewController.navigationController popToRootViewControllerAnimated:NO];
    
    
}

#pragma mark - KeyBoard

- (void)initAutokeyBoard
{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}


#pragma mark - ModifiPassword

- (void)modificationPSClick
{

    if (_vc.centerController == tabBarController) {
        
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:login];
        login.delegate = self;
        _vc.centerController = Nav;
        
    }
    else {
        UINavigationController *nav = (UINavigationController *)_vc.centerController;
        UIViewController *viewController = nav.visibleViewController;
        
        if ([NSStringFromClass([viewController class]) isEqualToString:@"LoginViewController"]) {
            NSLog(@"111");
        }
        else{
            NSLog(@"222");
            
            LoginViewController *login = [[LoginViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:login];
            login.delegate = self;
            _vc.centerController = Nav;
            
        }
    }
}

#pragma mark - MenuDelegate


- (void)clickMenuIndex:(int)index
{
    
    [_vc closeLeftView];
    
    switch (index) {
        case 0:{
            
            //判断是否是tabBarController
            if (_vc.centerController == tabBarController) {
                

                [_homePageController popToRootViewControllerAnimated:NO];
                _vc.centerController = _homePageController;
                
            }
            else {
                //判定_vc的当前界面是否和首页一致
                UINavigationController *nav = (UINavigationController *)_vc.centerController;
                UIViewController *viewController = nav.visibleViewController;
                NSString *currentViewName = NSStringFromClass([viewController class]);
                if ([currentViewName isEqualToString:@"HomePageViewController"]) {
                    
                }
                else {
;
                    [_homePageController popToRootViewControllerAnimated:NO];
                    _vc.centerController = _homePageController;
                }

            }
            
            
            
            break;
        }
        case 1:{
                if ([LoginStatusObject isLoginStatus]) {
                MyOrderListViewController *mm = [[MyOrderListViewController alloc] init];
                UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:mm];
                _vc.centerController = Nav;
                }
            
            
            break;
        }
        case 2:{
            
            if ([LoginStatusObject isLoginStatus]) {
                UthingShareViewController *share = [[UthingShareViewController alloc] init];
                UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:share];
                _vc.centerController = Nav;
            }
            
            
            break;
        }
        case 3:{
            if ([LoginStatusObject isLoginStatus]) {
            UthingFeedbackViewController *feed = [[UthingFeedbackViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:feed];
            _vc.centerController = Nav;
            }
            break;
        }
        case 4:{
            
            AboutUthingViewController *about = [[AboutUthingViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:about];
            _vc.centerController = Nav;
            
            break;
        }
        case 5:{
            //去评分
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserInfoSingleton sharedInstance].scoreUrl]];
            [_homePageController popToRootViewControllerAnimated:NO];
            _vc.centerController = _homePageController;
            break;
        }
        case 6:{
            //检查更新
            
            [self checkUpdate];
            [_homePageController popToRootViewControllerAnimated:NO];
            _vc.centerController = _homePageController;
            
            break;
        }
        case 7:{
            
            SDImageCache *sc = [SDImageCache sharedImageCache];
            [sc cleanDisk];
//            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缓存清空完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [al show];
            
            [SVProgressHUD showSuccessWithStatus:@"您的缓存已经清空"];
            [_homePageController popToRootViewControllerAnimated:NO];
            _vc.centerController = _homePageController;
            
             break;
        }
        case 777:{
            if ([LoginStatusObject isLoginStatus]) {
            UserInfoCenterViewController *userInfoCenter = [[UserInfoCenterViewController alloc] init];
            userInfoCenter.delegate = self;
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:userInfoCenter];
            _vc.centerController = Nav;
            }
            break;
        }
            
        case 888:{
            
            if ([NSStringFromClass([_vc.centerController class]) isEqualToString:@"LoginViewController"]) {
                NSLog(@"111");
            }
            else{
                LoginViewController *login = [[LoginViewController alloc] init];
                UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:login];
                login.delegate = self;
                _vc.centerController = Nav;
            }
            
            break;
        }
        case 999:{
            RegisterViewController *registerVC = [[RegisterViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerVC];
            registerVC.isMenuClick = YES;
            registerVC.delegate = self;
            _vc.centerController = nav;
            
            break;
        }
            
        default:
            break;
    }
    
    
    
}

#pragma mark - HomepageDelegate

- (void)clickTabBarIndex:(NSInteger)index
{
    NSLog(@"tabBar select index %d",index);
    tabBarController.selectedIndex = index;
    _vc.centerController = tabBarController;
    
}

- (void)clickHomepageIndex:(NSInteger)index
{
    NSLog(@"Homepage select index %d",index);
    tabBarController.selectedIndex = index;
    _vc.centerController = tabBarController;
    
}


#pragma MenuNotfication

- (void)menuChange:(NSNotification*)not
{
    
    NSDictionary *dict = [not userInfo];
    BOOL ispan = [[dict objectForKey:@"ispan"] boolValue];
    
    
    if (!ispan) {
        _vc.panningMode = IIViewDeckNoPanning;
    }else {
        _vc.panningMode = IIViewDeckFullViewPanning;
    }

}



#pragma mark - initView

- (void)initWel
{
    NSString *key = [NSString getMyApplicationVersion];
    
    
    NSString *isFirst =  (NSString*)[WQKeyChain load:key];
    if ([isFirst length]) {
        [self initWithTab];
        //[self initMenu];
        
        

    }else{
        UthingWelComeViewController *uw = [[UthingWelComeViewController alloc] init];
        uw.delegate = self;
        self.window.rootViewController=uw;
        
    }

    
    
    
    
    
}


- (void)initMenu
{
    
    UthingMenuViewController *menuController = [[UthingMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    menuController.delegate = self;
    
    HomePageViewController *home = [[HomePageViewController alloc] init];
    home.delegate = self;
    
    UINavigationController *hNav = [[UINavigationController alloc] initWithRootViewController:home];
    _homePageController = hNav;
    
    //
   
    
    _vc = [[IIViewDeckController alloc] initWithCenterViewController:hNav leftViewController:menuController];
    _vc.leftSize =self.window.bounds.size.width - (320-66);
    _vc.shadowEnabled = NO;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuChange:) name:@"menuchange" object:nil];

    self.window.rootViewController=_vc;

}

- (void)initWithTab
{
    //首页
    HomePageViewController *mrU=[[HomePageViewController alloc] init];
    MLNavigationController *recomNavController=[[MLNavigationController alloc] initWithRootViewController:mrU];
    
    mrU.navigationItem.title=@"首页";
    recomNavController.tabBarItem.title = @"首页";
    //[recomNavController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"U制造"] withFinishedUnselectedImage:[UIImage imageNamed:@"U制造_active"]];
    
    
    recomNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"ico_tab_index.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ico_tab_index.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    //发现
    DiscoverViewController *ovTour=[[DiscoverViewController alloc] init];
    ovTour.navigationItem.title=@"发现";
    MLNavigationController *cataNavController=[[MLNavigationController alloc] initWithRootViewController:ovTour];
    cataNavController.tabBarItem.title = @"发现";
 
    
    cataNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[[UIImage imageNamed:@"ico_tab_find.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ico_tab_find.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    
    //消息
    MessagesViewController *hotPack =[[MessagesViewController alloc] init];
    hotPack.navigationItem.title=@"消息";
    MLNavigationController *downNavVController=[[MLNavigationController alloc] initWithRootViewController:hotPack];
    downNavVController.tabBarItem.title = @"消息";
    downNavVController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[[UIImage imageNamed:@"ico_tab_message.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ico_tab_message.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    //我
    UserInfoCenterViewController *freeTour=[[UserInfoCenterViewController alloc] init];
    freeTour.navigationItem.title=@"我的";
    
    MLNavigationController *manageNavVController=[[MLNavigationController alloc] initWithRootViewController:freeTour];
    manageNavVController.tabBarItem.title = @"我的";
   
    
    manageNavVController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"ico_tab_mine.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ico_tab_mine.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
  
    tabBarController=[[UITabBarController alloc] init] ;
    
    tabBarController.tabBar.barTintColor = RGBCOLOR(58, 183, 198);
    
    //选中状态背景
    UIImage *image = [UIImage OriginImage:IMAGE(@"toolbar_bg_active.png") scaleToSize:CGSizeMake(kMainScreenWidth/4, 49)];
    tabBarController.tabBar.selectionIndicatorImage = image;
    
    [tabBarController setViewControllers:[NSArray arrayWithObjects:recomNavController,cataNavController,downNavVController,manageNavVController,  nil]];
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil] ];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    
    
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=7.0) {
        //
        
        
        [[UINavigationBar appearance] setBarTintColor:RGBCOLOR(58, 184, 197)];
        [UINavigationBar appearance].tintColor =[UIColor whiteColor];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        
        
    }else{
        
        [recomNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"app_toolbar_bg_link"] forBarMetrics:UIBarMetricsDefault];
        [cataNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"app_toolbar_bg_link"] forBarMetrics:UIBarMetricsDefault];
        [downNavVController.navigationBar setBackgroundImage:[UIImage imageNamed:@"app_toolbar_bg_link"] forBarMetrics:UIBarMetricsDefault];
        [manageNavVController.navigationBar setBackgroundImage:[UIImage imageNamed:@"app_toolbar_bg_link"] forBarMetrics:UIBarMetricsDefault];
        
        
    }
    
    
    self.window.rootViewController=tabBarController;
    
    
    
}

#pragma mark - WelComePage Delegate

- (void)goWelBack
{
    
    NSString *key = [NSString getMyApplicationVersion];
    
    
    [WQKeyChain save:key data:@"1"];
    
    
    [self initWithTab];
    //[self initMenu];
    
}

#pragma mark - JPush


- (void)initPush:(NSDictionary*)lunOption
{

    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    
    
  
    
    
    [APService setupWithOption:lunOption];
    

}


#pragma mark - ShareSDK


- (void)initShareSDK
{
    _viewDelegate = [[AGViewDelegate alloc] init];
    
    //监听用户信息变更
    [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                               target:self
                               action:@selector(userInfoUpdateHandler:)];
    
    
    [ShareSDK registerApp:@"4acd5c187a92"];
    
    
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];

    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    //    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
                           wechatCls:[WXApi class]];
    
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    

}



- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSMutableArray *authList = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        authList = [NSMutableArray array];
    }
    
    NSString *platName = nil;
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    switch (plat)
    {
        case ShareTypeSinaWeibo:
            platName = NSLocalizedString(@"TEXT_SINA_WEIBO", @"新浪微博");
            break;
            //        case ShareType163Weibo:
            //            platName = NSLocalizedString(@"TEXT_NETEASE_WEIBO", @"网易微博");
            //            break;
        case ShareTypeDouBan:
            platName = NSLocalizedString(@"TEXT_DOUBAN", @"豆瓣");
            break;
        case ShareTypeFacebook:
            platName = @"Facebook";
            break;
        case ShareTypeKaixin:
            platName = NSLocalizedString(@"TEXT_KAIXIN", @"开心网");
            break;
        case ShareTypeQQSpace:
            platName = NSLocalizedString(@"TEXT_QZONE", @"QQ空间");
            break;
        case ShareTypeRenren:
            platName = NSLocalizedString(@"TEXT_RENREN", @"人人网");
            break;
        case ShareTypeSohuWeibo:
            platName = NSLocalizedString(@"TEXT_SOHO_WEIBO", @"搜狐微博");
            break;
        case ShareTypeTencentWeibo:
            platName = NSLocalizedString(@"TEXT_TENCENT_WEIBO", @"腾讯微博");
            break;
        case ShareTypeTwitter:
            platName = @"Twitter";
            break;
        case ShareTypeInstapaper:
            platName = @"Instapaper";
            break;
        case ShareTypeYouDaoNote:
            platName = NSLocalizedString(@"TEXT_YOUDAO_NOTE", @"有道云笔记");
            break;
        case ShareTypeGooglePlus:
            platName = @"Google+";
            break;
        case ShareTypeLinkedIn:
            platName = @"LinkedIn";
            break;
        default:
            platName = NSLocalizedString(@"TEXT_UNKNOWN", @"未知");
    }
    
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    BOOL hasExists = NO;
    for (int i = 0; i < [authList count]; i++)
    {
        NSMutableDictionary *item = [authList objectAtIndex:i];
        ShareType type = (ShareType)[[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            hasExists = YES;
            break;
        }
    }
    
    if (!hasExists)
    {
        NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 platName,
                                 @"title",
                                 [NSNumber numberWithInteger:plat],
                                 @"type",
                                 [userInfo nickname],
                                 @"username",
                                 nil];
        [authList addObject:newItem];
    }
    
    [authList writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
}





- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark ==Forbid Landscape==
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark ==check Update==
/**
 *  检查更新
 *
 *  @return 是否有更新
 */
- (BOOL)checkUpdate
{
    //接口
    ParametersManagerObject *managerObject = [[ParametersManagerObject alloc] init];
    
    [managerObject addParamer:[NSString stringWithFormat:@"system=ios"]];
    
    NSData *data = [managerObject getHeetBody];
    
    NetworkingCenter *networkingCenter = [[NetworkingCenter alloc] init];
    [networkingCenter myAsynchronousPostWithUrl:checkUpdateURL postData:data];
    
    [networkingCenter setMyResultsHandle:^(NSMutableData *resultData) {
        
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
        
        
        //
        UserInfoSingleton *userInfo = [UserInfoSingleton sharedInstance];
        userInfo.phone = [[resultDict objectForKey:@"data"] objectForKey:@"phone"];
        userInfo.goDownUrl = [[resultDict objectForKey:@"data"] objectForKey:@"url"];
        userInfo.scoreUrl = [[resultDict objectForKey:@"data"] objectForKey:@"score"];

        //验证
        if ([managerObject checkSign:[resultDict objectForKey:@"data"] Sign:[resultDict objectForKey:@"sign"]]) {
            NSLog(@"检查更新 验证成功");
            
            NSDictionary *dict = [resultDict objectForKey:@"data"];
        
            
            if ([[NSString getMyApplicationVersion] isEqualToString:[dict objectForKey:@"version"]]) {
                
                static int count = 1;
                
                if (count == 1) {
                    count++;
                }
                else {
                    
                        _al = [[UIAlertView alloc] initWithTitle:@"版本提示" message:@"已是最新版本" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                        _al.delegate = self;
                        [_al show];
                        
                        [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                         target:self
                                                       selector:@selector(dismissAlertView:)
                                                       userInfo:nil
                                                        repeats:NO];
                    
                }
                
            }
            else{
                if ([[dict objectForKey:@"is_force"] intValue] == 0) {
                    _forceUpdateAl = [[UIAlertView alloc] initWithTitle:@"版本提示" message:@"当前最新版本未更新，是否立即更新？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    _forceUpdateAl.delegate = self;
                    [_forceUpdateAl show];
                }
                else {
                    _al = [[UIAlertView alloc] initWithTitle:@"版本提示" message:@"当前最新版本未更新，是否立即更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                    _al.delegate = self;
                    [_al show];
                }
            }
        
            
        }
        
    }];
    [networkingCenter setMyError:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
    
    return YES;
}

- (void)dismissAlertView:(NSTimer *)timer
{
    [_al dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == _forceUpdateAl) {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserInfoSingleton sharedInstance].goDownUrl]];
    }
    else {
        if (buttonIndex == 1) {
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserInfoSingleton sharedInstance].goDownUrl]];
        }
        else if (buttonIndex == 0) {
            
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            
        }
    }
}

@end
