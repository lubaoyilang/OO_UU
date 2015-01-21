//
//  UthingMenuViewController.m
//  UThing
//
//  Created by luyuda on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "UthingMenuViewController.h"

#import "LoginViewController.h"
#import "UserInfoSingleton.h"
#import "UIImageView+WebCache.h"

#define cellH 44

static UIView *_noLoginView;
static UILabel *_loginLabelView;

@interface UthingMenuViewController()
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSArray *titles;


@property (nonatomic, strong) UIView *headerView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIControl *control;
@end

@implementation UthingMenuViewController
@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
        
    }

    
    
    
    _titles = @[@"首页", @"我的订单", @"分享设置",@"意见反馈", @"关于游心", @"评价我们",@"检查更新", @"清空缓存"];
    _images = @[@"app-menu_03",@"app-menu_06",@"app-menu_08",@"app-menu_08-10",@"app-menu_10",@"app-menu_10-14",@"app-menu_10-16",@"app-menu_10-18"];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    //self.tableView.bounces = NO;

    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg"]];

    self.tableView.tableHeaderView = ({
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 0, 184.0f)];
        
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-66)/2-40, 40, 80, 80)];
        _imageView.image = [UIImage imageNamed:@"headPortrait.jpg"];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 40.0;
        _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _imageView.layer.borderWidth = 3.0f;
        _imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _imageView.layer.shouldRasterize = YES;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = NO;
        
        
        [_headerView addSubview:_imageView];
        
        _noLoginView = [[UIView alloc] initWithFrame:CGRectMake((320-66)/2-75, 145, 151, 25)];
        _noLoginView.backgroundColor = [UIColor clearColor];
        
        UIImageView *loginbackl = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 25)];
        loginbackl.image =[UIImage imageNamed:@"app-menu_login"];
        [_noLoginView addSubview:loginbackl];
        UIImageView *loginbackr = [[UIImageView alloc] initWithFrame:CGRectMake(76, 0, 75, 25)];
        loginbackr.image =[UIImage imageNamed:@"app-menu_reg"];
        [_noLoginView addSubview:loginbackr];
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(75, 0, 1, 25)];
        line.image = [UIImage imageNamed:@"app-menu_login-line-reg"];
        [_noLoginView addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 25)];
        label.text = @"登录";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [_noLoginView addSubview:label];
        
        UILabel *labelreg = [[UILabel alloc] initWithFrame:CGRectMake(76, 0, 75, 25)];
        labelreg.text = @"注册";
        labelreg.textAlignment = NSTextAlignmentCenter;
        labelreg.font = [UIFont systemFontOfSize:14];
        labelreg.backgroundColor = [UIColor clearColor];
        labelreg.textColor = [UIColor whiteColor];
        [_noLoginView addSubview:labelreg];
        
        [_headerView addSubview:_noLoginView];
        
        _control = [[UIControl alloc] initWithFrame:CGRectMake((320-66)/2-50, 30, 100, 160)];
        [_control addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_control];
        
//        UIControl *contr2 = [[UIControl alloc] initWithFrame:CGRectMake(76, 0, 75, 25)];
//        [contr2 addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
//        [_noLoginView addSubview:contr2];
        
        _noLoginView.hidden = NO;
        
        _loginLabelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
        _loginLabelView.center = CGPointMake((320-66)/2, 145);
        _loginLabelView.font = [UIFont boldSystemFontOfSize:18];
        _loginLabelView.textAlignment = NSTextAlignmentCenter;
        [self.tableView addSubview:_loginLabelView];
        
        _loginLabelView.hidden = YES;
        
        _headerView;
    });
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification) name:@"loginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification) name:@"logoutNotification" object:nil];
}
//登录
- (void)loginNotification
{
    _control.enabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goUserCenter)];
    [_imageView addGestureRecognizer:tap];
    
    _loginLabelView.hidden = NO;
    
    _noLoginView.hidden = YES;
    
    _loginLabelView.text = [UserInfoSingleton sharedInstance].userInfoModel.nikename;

    
    NSLog(@"nickname = %@", _loginLabelView.text);
    
    _imageView.userInteractionEnabled = YES;
    
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:[UserInfoSingleton sharedInstance].userInfoModel.head_ico] placeholderImage:[UIImage imageNamed:@"headPortrait.jpg"] options:SDWebImageRefreshCached];
    [_imageView sz_setImageWithUrlString:[UserInfoSingleton sharedInstance].userInfoModel.head_ico imageSize:@"148x148" options:SDWebImageRefreshCached placeholderImageName:@"headPortrait.jpg"];
}
//登出
- (void)logoutNotification
{
    _control.enabled = YES;
    
    _loginLabelView.hidden = YES;
    
    [_imageView setImage:[UIImage imageNamed:@"headPortrait.jpg"]];
    
    _noLoginView.hidden = NO;
    
    _imageView.userInteractionEnabled = NO;
    
    for (UISwipeGestureRecognizer *recognizer in [_imageView gestureRecognizers]) {
        [[self view] removeGestureRecognizer:recognizer];
    }
}

#pragma mark - Action

- (void)goUserCenter
{
    NSLog(@"userCenter");
    if (delegate && [delegate respondsToSelector:@selector(clickMenuIndex:)]) {
        [delegate clickMenuIndex:777];
    }
}

- (void)goLogin
{
    NSLog(@"login");
    if (delegate && [delegate respondsToSelector:@selector(clickMenuIndex:)]) {
        [delegate clickMenuIndex:888];
    }
    
}

- (void)goRegister
{
    NSLog(@"Register");
    if (delegate && [delegate respondsToSelector:@selector(clickMenuIndex:)]) {
        [delegate clickMenuIndex:999];
    }
}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (delegate && [delegate respondsToSelector:@selector(clickMenuIndex:)]) {
        [delegate clickMenuIndex:indexPath.row];
    }
    
    
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *title;
    UIImageView *icon;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        icon = [[UIImageView alloc ] initWithFrame:CGRectMake(40, (cellH-22)/2, 22, 22)];
        icon.tag = 9001;
        icon.backgroundColor = [UIColor clearColor];
        [cell addSubview:icon];
        
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(75, (cellH-24)/2, 150, 24)];
        title.font =[UIFont fontWithName:@"HelveticaNeue" size:16];
        title.textColor = [UIColor colorFromHexRGB:@"0xffffff"];
        title.tag = 9006;
        title.backgroundColor = [UIColor clearColor];
        [cell addSubview:title];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cellH-1, self.view.bounds.size.width, 0.5)];
        line.backgroundColor = [UIColor whiteColor];
        
        [cell addSubview:line];
        
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:IMAGE(@"app-menu_02.jpg")];
        
//        //默认选择第一行
//        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView selectRowAtIndexPath:firstPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    title = (UILabel*)[cell viewWithTag:9006];
    icon = (UIImageView*)[cell viewWithTag:9001];
    
    title.font = [UIFont boldSystemFontOfSize:18];
    title.text = _titles[indexPath.row];
    icon.image = [UIImage imageNamed:_images[indexPath.row]];
    
    
    
    
    
    return cell;
}




@end
