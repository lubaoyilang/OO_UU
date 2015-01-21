//
//  UthingShareViewController.m
//  UThing
//
//  Created by luyuda on 14/11/20.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "UthingShareViewController.h"
#import <AGCommon/UIImage+Common.h>
#import "ShareCell.h"
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/UIColor+Common.h>
#import "IIViewDeckController.h"
#import <AGCommon/UIDevice+Common.h>
#import "AppDelegate.h"
#import <AGCommon/NSString+Common.h>
#import <ShareSDK/ShareSDK.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import "AGViewDelegate.h"
#import "ProductDetailViewController.h"
#import "HotelProductDetailViewController.h"
#define TARGET_CELL_ID @"targetCell"
#define BASE_TAG 100



@interface UthingShareViewController ()

@property (nonatomic,strong)AppDelegate *appDelegate;
@property (nonatomic,strong)NSString *shareStr;


- (void)userInfoUpdateHandler:(NSNotification *)notif;

@end

@implementation UthingShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
       _appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
        
        //监听用户信息变更
        [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                                   target:self
                                   action:@selector(userInfoUpdateHandler:)];
        
        _shareTypeArray = [[NSMutableArray alloc] init];
        
        NSArray *shareTypes = [ShareSDK connectedPlatformTypes];
        for (int i = 0; i < [shareTypes count]; i++)
        {
            NSNumber *typeNum = [shareTypes objectAtIndex:i];
            ShareType type = (ShareType)[typeNum integerValue];
            id<ISSPlatformApp> app = [ShareSDK getClientWithType:type];
            
            
            if ([app isSupportOneKeyShare] || type == ShareTypeInstagram || type == ShareTypeQQ || type == ShareTypeQQSpace || type == ShareTypeWeixiSession || type ==ShareTypeWeixiTimeline)
            {
                [_shareTypeArray addObject:[NSMutableDictionary dictionaryWithObject:[shareTypes objectAtIndex:i]
                                                                              forKey:@"type"]];
            }
        }
        
        NSArray *authList = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
        if (authList == nil)
        {
            [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
        }
        else
        {
            for (int i = 0; i < [authList count]; i++)
            {
                NSDictionary *item = [authList objectAtIndex:i];
                for (int j = 0; j < [_shareTypeArray count]; j++)
                {
                    if ([[[_shareTypeArray objectAtIndex:j] objectForKey:@"type"] integerValue] == [[item objectForKey:@"type"] integerValue])
                    {
                        [_shareTypeArray replaceObjectAtIndex:j withObject:[NSMutableDictionary dictionaryWithDictionary:item]];
                        break;
                    }
                }
            }
        }
    }
    return self;
}

- (void)dealloc
{
    [ShareSDK removeNotificationWithName:SSN_USER_INFO_UPDATE target:self];
    
}

- (void)hideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}


//- (void)setTitle:(NSString *)title
//{
//    [super setTitle:title];
//    ((UILabel *)self.navigationItem.titleView).text = title;
//    [self.navigationItem.titleView sizeToFit];
//}

- (void)loadView
{
    [super loadView];
    
//    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
//    {
//        [self setExtendedLayoutIncludesOpaqueBars:NO];
//        [self setEdgesForExtendedLayout:SSRectEdgeBottom | SSRectEdgeLeft | SSRectEdgeRight];
//    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
                                              style:UITableViewStylePlain];
    _tableView.rowHeight = 50.0;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self layoutView:self.interfaceOrientation];
    
    
    NSArray *array = [self.navigationController viewControllers];
    if ([array count]>1) {
        int count = [array count];
        if ([[array objectAtIndex:count-2] isKindOfClass:[ProductDetailViewController class]]) {
            ProductDetailViewController * pro = [array objectAtIndex:count-2];
            
            _shareStr = [NSString stringWithFormat:PRODUCTCONTENT,[pro getProductTitle]];
        }else if ([[array objectAtIndex:count-2] isKindOfClass:[HotelProductDetailViewController class]]){
            
            HotelProductDetailViewController *ho =[array objectAtIndex:count-2];
            _shareStr = [NSString stringWithFormat:PRODUCTCONTENT,[ho getProductTitle]];
        }
        else{
            _shareStr = SHARECONTENT;
        }
        
    }else{
        _shareStr = SHARECONTENT;
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
            
        }
    }
    
    
    NSArray *array = [self.navigationController viewControllers];
    if ([array count]<=1) {
        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"菜单"] style:UIBarButtonItemStyleDone target:self.viewDeckController action:@selector(toggleLeftView)];
        self.title = @"分享设置";
        self.navigationItem.leftBarButtonItem = menuItem;
    }else{
        self.title = @"分享";
        
    }
    
    
    
    
    

}


- (void)shareAction:(UIButton*)sender
{
    NSInteger index = sender.tag - 800;
    
    if (index < [_shareTypeArray count])
    {
        
        NSMutableDictionary *item = [_shareTypeArray objectAtIndex:index];
        ShareType type = (ShareType)[[item objectForKey:@"type"] integerValue];
        
        switch (type) {
            case ShareTypeSinaWeibo:
                [self shareToSinaWeiboClickHandler:sender];
                break;
            case ShareTypeTencentWeibo:
                [self shareToTencentWeiboClickHandler:sender];
                break;
                
            case ShareTypeQQSpace:
                [self shareToQQSpaceClickHandler:sender];
                break;
            case ShareTypeWeixiSession:
                [self shareToWeixinSessionClickHandler:sender];
                break;
                
            case ShareTypeWeixiTimeline:
                [self shareToWeixinTimelineClickHandler:sender];
                break;
            case ShareTypeQQ:
                [self shareToQQFriendClickHandler:sender];
                break;
                
            default:
                break;
        }
        
        
    }

    
    
    
    

}


- (void)authSwitchChangeHandler:(UISwitch *)sender
{
    
    NSInteger index = sender.tag - BASE_TAG;
    
    if (index < [_shareTypeArray count])
    {
        NSMutableDictionary *item = [_shareTypeArray objectAtIndex:index];
        if (sender.on)
        {
            //用户用户信息
            ShareType type = (ShareType)[[item objectForKey:@"type"] integerValue];
            
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:YES
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:nil];
            
//            //在授权页面中添加关注官方微博
//            [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                            [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                            SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                            [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                            SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                            nil]];
            
            [ShareSDK getUserInfoWithType:type
                              authOptions:authOptions
                                   result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                       if (result)
                                       {
                                           [item setObject:[userInfo nickname] forKey:@"username"];
                                           [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
                                       }
                                       NSLog(@"%ld:%@",(long)[error errorCode], [error errorDescription]);
                                       [_tableView reloadData];
                                   }];
        }
        else
        {
            //取消授权
            [ShareSDK cancelAuthWithType:(ShareType)[[item objectForKey:@"type"] integerValue]];
            [_tableView reloadData];
        }
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_shareTypeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TARGET_CELL_ID];
    if (cell == nil)
    {
        cell = [[ShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TARGET_CELL_ID] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        
//        UISwitch *switchCtrl = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, 10, 50, _tableView.rowHeight)];
//        [switchCtrl sizeToFit];
//        switchCtrl.tag = BASE_TAG + indexPath.row;
//        
//        [switchCtrl addTarget:self action:@selector(authSwitchChangeHandler:) forControlEvents:UIControlEventValueChanged];
//        [cell addSubview:switchCtrl];
        
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn setFrame:CGRectMake(self.view.bounds.size.width-60, 5, 50, 40)];
        shareBtn.tag = 800+indexPath.row;
        [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:shareBtn];
        
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.rowHeight-1, self.view.bounds.size.width, 0.5)];
        line.backgroundColor = [UIColor darkGrayColor];
        [cell addSubview:line];
        
        
        
    }
    
//    UISwitch *switchCtrl = (UISwitch *)[cell viewWithTag:BASE_TAG + indexPath.row];
    
    
    if (indexPath.row < [_shareTypeArray count])
    {
        NSDictionary *item = [_shareTypeArray objectAtIndex:indexPath.row];
        
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:
                                            @"Icon/sns_icon_%ld.png",
                                            (long)[[item objectForKey:@"type"] integerValue]]
                                bundleName:@"Resource"];
        cell.imageView.image = img;
        
        ShareType type = [[item objectForKey:@"type"] integerValue];
        if (type == 1) {
            cell.textLabel.text = @"新浪微博";
        }else if (type == 2){
            cell.textLabel.text = @"腾讯微博";
        }else if (type == 6){
            cell.textLabel.text = @"QQ空间";
        }else if (type == 22){
            cell.textLabel.text = @"微信好友";
        }else if (type == 23){
            cell.textLabel.text = @"朋友圈";
        }else if (type == 24){
            cell.textLabel.text = @"QQ";
        }
        
        
        
//        switchCtrl.on = [ShareSDK hasAuthorizedWithType:(ShareType)[[item objectForKey:@"type"] integerValue]];
        
       // ((UISwitch *)cell.accessoryView).tag = BASE_TAG + indexPath.row;
        
//        if (switchCtrl.on)
//        {
//            cell.textLabel.text = @"已授权";
//
//        }
//        else
//        {
//            cell.textLabel.text = @"尚未授权";
//        }
        
        //cell.textLabel.text = @"已授权";
    }
    
    
    
    
    return cell;
}

#pragma mark - Private





- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    
    for (int i = 0; i < [_shareTypeArray count]; i++)
    {
        NSMutableDictionary *item = [_shareTypeArray objectAtIndex:i];
        ShareType type = (ShareType)[[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            [_tableView reloadData];
        }
    }
}






/**
 *	@brief	分享到新浪微博
 *
 *	@param 	sender 	事件对象
 */
- (void)shareToSinaWeiboClickHandler:(UIButton *)sender
{
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:_shareStr
                                       defaultContent:@""
                                                image:nil
                                                title:@"游心网"
                                                  url:@"http://www.uthing.cn/"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    
    [publishContent addSinaWeiboUnitWithContent:_shareStr image:nil];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStylePopup
                                                          viewDelegate:_appDelegate.viewDelegate
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:nil
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:_appDelegate.viewDelegate
                                                       friendsViewDelegate:_appDelegate.viewDelegate
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                     [self hideKeyBoard];
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     [self hideKeyBoard];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];
}





/**
 *	@brief	分享到腾讯微博
 *
 *	@param 	sender 	事件对象
 */
- (void)shareToTencentWeiboClickHandler:(UIButton *)sender
{
    //创建分享内容
    
    id<ISSContent> publishContent = [ShareSDK content:_shareStr
                                       defaultContent:@""
                                                image:nil
                                                title:@"游心网"
                                                  url:@"http://www.uthing.cn/"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStylePopup
                                                          viewDelegate:_appDelegate.viewDelegate
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeTencentWeibo
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:nil
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:_appDelegate.viewDelegate
                                                       friendsViewDelegate:_appDelegate.viewDelegate
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [self hideKeyBoard];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     [self hideKeyBoard];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@") , [error errorCode], [error errorDescription]);
                                 }
                             }];
}

/**
 *	@brief	分享给QQ好友
 *
 *	@param 	sender 	事件对象
 */
- (void)shareToQQFriendClickHandler:(UIButton *)sender
{
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:_shareStr
                                       defaultContent:@""
                                                image:nil
                                                title:@"游心网"
                                                  url:@"http://www.uthing.cn"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStylePopup
                                                          viewDelegate:_appDelegate.viewDelegate
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeQQ
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:nil
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:_appDelegate.viewDelegate
                                                       friendsViewDelegate:_appDelegate.viewDelegate
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [self hideKeyBoard];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     [self hideKeyBoard];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];
}

/**
 *	@brief	分享到QQ空间
 *
 *	@param 	sender 	事件对象
 
 */

- (void)shareToQQSpaceClickHandler:(UIButton *)sender
{
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:_shareStr
                                       defaultContent:@""
                                                image:nil
                                                title:@"游心网"
                                                  url:@"http://www.uthing.cn"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    
    
    
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:@"游心网"
                                        url:@"http://www.uthing.cn"
                                       site:INHERIT_VALUE
                                    fromUrl:INHERIT_VALUE
                                    comment:_shareStr
                                    summary:_shareStr
                                      image:INHERIT_VALUE
                                       type:[NSNumber numberWithInt:4]
                                    playUrl:@"http://www.uthing.cn"
                                       nswb:[NSNumber numberWithInt:66]];

    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStylePopup
                                                          viewDelegate:_appDelegate.viewDelegate
                                               authManagerViewDelegate:nil];
    
//    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeQQSpace
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:nil
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:_appDelegate.viewDelegate
                                                       friendsViewDelegate:_appDelegate.viewDelegate
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [self hideKeyBoard];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     [self hideKeyBoard];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];
}

/**
 *	@brief	分享给微信好友
 *
 *	@param 	sender 	事件对象
 */
- (void)shareToWeixinSessionClickHandler:(UIButton *)sender
{
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:_shareStr
                                       defaultContent:@""
                                                image:nil
                                                title:@"游心网"
                                                  url:@"http://www.uthing.cn/"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStylePopup
                                                          viewDelegate:_appDelegate.viewDelegate
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeWeixiSession
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:nil
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:_appDelegate.viewDelegate
                                                       friendsViewDelegate:_appDelegate.viewDelegate
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [self hideKeyBoard];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     [self hideKeyBoard];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];
}

/**
 *	@brief	分享给微信朋友圈
 *
 *	@param 	sender 	事件对象
 */
- (void)shareToWeixinTimelineClickHandler:(UIButton *)sender
{
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:_shareStr
                                       defaultContent:@""
                                                image:nil
                                                title:@"游心网"
                                                  url:@"http://www.uthing.cn/"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStylePopup
                                                          viewDelegate:_appDelegate.viewDelegate
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:nil
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:_appDelegate.viewDelegate
                                                       friendsViewDelegate:_appDelegate.viewDelegate
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [self hideKeyBoard];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     [self hideKeyBoard];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];
}








@end
