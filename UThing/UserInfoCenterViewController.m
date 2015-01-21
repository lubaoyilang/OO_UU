//
//  UserInfoCenterViewController.m
//  Uthing
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 Wushengzhong. All rights reserved.
//

#import "UserInfoCenterViewController.h"

#import "IndividualInfoViewController.h"
#import "ModificationPasswordViewController.h"
#import "MyOrderListViewController.h"

#import "LoginAndRegisterCenter.h"
#import "UserInfoSingleton.h"
#import "UIImageView+WebCache.h"
#import "WQKeyChain.h"


#import "AboutUthingViewController.h"

/////////////uthing2.0/////////////////
//我的展示页
//销售记录
//关注我的
//旅行管家使用说明

#import "MyOrderListViewController.h" //订单
#import "ReserveViewController.h"     //预订单
//常用联系人
//我的代金券
//我的收藏
//我的关注
//关于游心
//分享游心

//设置


@class AppDelegate;

@interface UserInfoCenterViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UIImageView *u_userhHeadPortrait;
    UILabel *u_nickName;
    UITableView *u_functionMenutableView;
    NSArray *u_dataArray;
    NSArray *u_imageArr;
}

@end

@implementation UserInfoCenterViewController
@synthesize functionMenutableView;
@synthesize quickLoginBtn;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    
//    self.title = @"用户中心";
    
    [self setMemory];
    
    [self createHeaderUserIconAndNameView];
    
    [self createFunctionMenuView];
    
    //[self createQuitLoginBtnView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNickname) name:@"changeNickname" object:nil];
}
- (void)changeNickname
{
    self.nameLabel.text = [UserInfoSingleton sharedInstance].userInfoModel.nikename;
}

- (void)setMemory
{
    u_dataArray = @[@[@"我的展示页",@"销售记录",@"关注我的", @"旅行管家使用说明"], @[@"我的订单", @"我的预订单", @"常用联系人", @"我的代金券", @"我的收藏", @"我的关注", @"关于游心", @"分享游心"], @[@"设置"]];
    u_imageArr = @[@[@"app-填写完成_支付_03.png", @"app-订单填写_passenger.png", @"app_用户中心_12.png", @"app_用户中心_12.png"], @[@"app-填写完成_支付_03.png", @"app-订单填写_passenger.png", @"app_用户中心_12.png", @"app_用户中心_12.png", @"app-填写完成_支付_03.png", @"app-订单填写_passenger.png", @"app_用户中心_12.png", @"app_用户中心_12.png"], @[@"app_用户中心_12.png"]];
}


#pragma mark ==User HeaderPortrait And Name==
- (void)createHeaderUserIconAndNameView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 120)];
    
    imageView.image = IMAGE(@"app_用户中心_02.png");
    [self.view addSubview:imageView];
    
    //用户头像
    u_userhHeadPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    NSURL *url = [NSURL URLWithString:[UserInfoSingleton sharedInstance].userInfoModel.head_ico];
    
    
    [u_userhHeadPortrait sd_setImageWithURL:url placeholderImage:LOADIMAGE(@"headPortrait", @"jpg") options:SDWebImageRefreshCached];
    u_userhHeadPortrait.layer.cornerRadius = 30;
    u_userhHeadPortrait.clipsToBounds = YES;
    u_userhHeadPortrait.layer.borderColor = [UIColor whiteColor].CGColor;
    u_userhHeadPortrait.layer.borderWidth = 2.0f;
    u_userhHeadPortrait.center = CGPointMake(imageView.bounds.size.width/2, imageView.bounds.size.height/2 -10);
    [imageView addSubview:u_userhHeadPortrait];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _nameLabel.text = [UserInfoSingleton sharedInstance].userInfoModel.nikename;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.center = CGPointMake(self.view.width/2, imageView.height/2+40);
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    _nameLabel.textColor = [UIColor blackColor];
    [imageView addSubview:_nameLabel];
    
    
}

#pragma mark ==FunctionMenu View==
- (void)createFunctionMenuView
{
    self.functionMenutableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, kMainScreenWidth, kMainScreenHeight-120-44-49) style:UITableViewStyleGrouped];
    self.functionMenutableView.dataSource = self;
    self.functionMenutableView.delegate = self;
    self.functionMenutableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.functionMenutableView setSeparatorInset: UIEdgeInsetsZero];
    
    [self.view addSubview:self.functionMenutableView];
}



#pragma mark -
#pragma mark ==UITableView DataSource and UITableViewDelegate Methods==

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [u_dataArray[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 20, HeightForCell-15)];
        iconView.tag = 201;
        [cell.contentView addSubview:iconView];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 160, HeightForCell)];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textColor = [UIColor blackColor];
        textLabel.tag = 202;
        [cell.contentView addSubview:textLabel];
        
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, HeightForCell-1, self.view.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor colorFromHexRGB:@"f5f5f5"];
        [cell.contentView addSubview:lineView];
        
    }
    NSArray *array = u_imageArr[indexPath.section];
    
    UIImageView *iconView = (UIImageView *)[cell.contentView viewWithTag:201];
    iconView.image = IMAGE(array[indexPath.row]);
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:202];
    label.text = u_dataArray[indexPath.section][indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightForCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


#pragma mark ==Function Menu Click==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0: {
            
            //商家
            switch (indexPath.row) {
                    //我的展示页
                case 0:{
                    MyOrderListViewController *myOrderListViewController = [[MyOrderListViewController alloc] init];
                    [self.navigationController pushViewController:myOrderListViewController animated:YES];
                    break;
                }
                    
                    //销售记录
                case 1:{
                    IndividualInfoViewController *individualInfoViewController = [[IndividualInfoViewController alloc] init];
                    [self.navigationController pushViewController:individualInfoViewController animated:YES];
                    break;
                }
                    
                    //关注我的
                case 2:{
                    ModificationPasswordViewController *modificationPasswordViewController = [[ModificationPasswordViewController alloc] init];
                    modificationPasswordViewController.m_delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [self.navigationController pushViewController:modificationPasswordViewController animated:YES];
                    break;
                }
                    
                    //旅行管家使用说明
                case 3:{
                    IndividualInfoViewController *individualInfoViewController = [[IndividualInfoViewController alloc] init];
                    [self.navigationController pushViewController:individualInfoViewController animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
            
        }
        case 1: {
            
            //order等
            switch (indexPath.row) {
                    //订单
                case 0:{
                    MyOrderListViewController *myOrderListViewController = [[MyOrderListViewController alloc] init];
                    [self.navigationController pushViewController:myOrderListViewController animated:YES];
                    break;
                }
                    
                    //预订单
                case 1:{
                    IndividualInfoViewController *individualInfoViewController = [[IndividualInfoViewController alloc] init];
                    [self.navigationController pushViewController:individualInfoViewController animated:YES];
                    break;
                }
                    
                    //联系人
                case 2:{
                    IndividualInfoViewController *individualInfoViewController = [[IndividualInfoViewController alloc] init];
                    [self.navigationController pushViewController:individualInfoViewController animated:YES];
                    break;
                }
                    
                    //代金券
                case 3:{
                    IndividualInfoViewController *individualInfoViewController = [[IndividualInfoViewController alloc] init];
                    [self.navigationController pushViewController:individualInfoViewController animated:YES];
                    break;
                }
                    
                    //收藏
                case 4:{
                    IndividualInfoViewController *individualInfoViewController = [[IndividualInfoViewController alloc] init];
                    [self.navigationController pushViewController:individualInfoViewController animated:YES];
                    break;
                }
                    
                    //关注
                case 5:{
                    IndividualInfoViewController *individualInfoViewController = [[IndividualInfoViewController alloc] init];
                    [self.navigationController pushViewController:individualInfoViewController animated:YES];
                    break;
                }
                    
                    //关于游心
                case 6:{
                    AboutUthingViewController *individualInfoViewController = [[AboutUthingViewController alloc] init];
                    [self.navigationController pushViewController:individualInfoViewController animated:YES];
                    break;
                }
                    
                    //分享游心
                case 7:{
                    IndividualInfoViewController *individualInfoViewController = [[IndividualInfoViewController alloc] init];
                    [self.navigationController pushViewController:individualInfoViewController animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
            
        }
            
        case 2: {
            
            //设置
            IndividualInfoViewController *individualInfoViewController = [[IndividualInfoViewController alloc] init];
            [self.navigationController pushViewController:individualInfoViewController animated:YES];
            break;
            
        }
            
            
        default:
            break;
    }
    
}

- (void) viewWillAppear: (BOOL)inAnimated {
    NSIndexPath *selected = [self.functionMenutableView indexPathForSelectedRow];
    if(selected) [self.functionMenutableView deselectRowAtIndexPath:selected animated:NO];
}


/*
 *  退出按钮
 */
#pragma mark ==QuitLogin Btn View==
- (void)createQuitLoginBtnView
{
    self.quickLoginBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    self.quickLoginBtn.frame = CGRectMake(10, self.view.bounds.size.height-49-50-64, self.view.bounds.size.width-20, 40);
    [self.quickLoginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    self.quickLoginBtn.layer.cornerRadius  = 8;
    self.quickLoginBtn.clipsToBounds = YES;
    self.quickLoginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.quickLoginBtn.titleLabel.textColor = [UIColor whiteColor];
    [self.quickLoginBtn addTarget:self action:@selector(quitLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.quickLoginBtn setFaceColor:[UIColor colorFromHexRGB:@"ff9900"] forState:UIControlStateNormal];
    [self.quickLoginBtn setFaceColor:[UIColor colorFromHexRGB:@"ff6600"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.quickLoginBtn];
}
//退出按钮 点击事件
- (void)quitLoginClick:(UIButton *)btn
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginAndRegisterCenter *center = [[LoginAndRegisterCenter alloc] init];
        [center logout];
        
        //清除缓存数据
        [WQKeyChain delete:@"username"];
        [WQKeyChain delete:@"password"];
        
        //切回首页
        if (_delegate && [_delegate respondsToSelector:@selector(userInfoCenterClickIndex:)]) {
            //0----退出按钮
            [_delegate userInfoCenterClickIndex:0];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
