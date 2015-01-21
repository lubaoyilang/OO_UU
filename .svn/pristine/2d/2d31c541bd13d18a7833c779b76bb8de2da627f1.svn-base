//
//  HomePageViewController.m
//  UThing
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "HomePageViewController.h"

#import "HomePageTableViewCell.h"
#import "ParametersManagerObject.h"
#import "HomeModel.h"
#import "BroadModel.h"
#import "NetworkingCenter.h"
#import "CycleScrollView.h"
#import "MJRefresh.h"

#import "MyOrderFillInViewController.h"
#import "ProductDetailViewController.h"
#import "LoginStatusObject.h"
#import "HotelProductDetailViewController.h"

#import "CategorySlideViewController.h"
#import "SubjectViewController.h"

@class AppDelegate;



static CGFloat const selectedViewHeight = 60;
static NSInteger const selectedNum = 5; //每行放置几个按钮

@interface HomePageViewController ()<UITableViewDataSource, UITableViewDelegate, HomePageTableViewCellDelegate, UITabBarControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic) NSMutableArray *broadInfoArr;
@property (nonatomic) NSMutableArray *bottomBroadInfoArr;
@property (nonatomic) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *proArr;

@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) CycleScrollView *mainScrollView;
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) UIView *productView;
@property (nonatomic, strong) UIImageView *footerView;

@property (nonatomic, strong) ParametersManagerObject *managerObject;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   

    

    
    //headerView
    _broadInfoArr = [[NSMutableArray alloc] init];
    
    _bottomBroadInfoArr = [[NSMutableArray alloc] init];
    _titleArr = [[NSMutableArray alloc] init];
    _proArr = [[NSMutableArray alloc] init];
    [self getBroad];
    
    
}

- (void)getBroad
{
    [self getBroadWithMyResultsHandle:^(NSMutableData *resultData) {
        __block NSError *error1 = [[NSError alloc] init];
        NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error1];
        
        NSArray *dataArray = [resultsDictionary objectForKey:@"data"];
        
        if ([_managerObject checkSign:[resultsDictionary objectForKey:@"data"] Sign:[resultsDictionary objectForKey:@"sign"]]) {
            
            NSLog(@"result = %@", resultsDictionary);
            NSMutableArray *dataArr = [[NSMutableArray alloc] init];
            if ([[resultsDictionary objectForKey:@"result"] isEqualToString:@"ok"]) {
                
                
                //创建中部产品
                for (NSDictionary *dict in [[dataArray objectAtIndex:1] objectForKey:@"data"]) {
                    
                    [_proArr addObject:dict];
                }
                
                //标题
                [_titleArr addObject:[[dataArray objectAtIndex:3] objectForKey:@"data"]];
                [_titleArr addObject:[[dataArray objectAtIndex:4] objectForKey:@"data"]];
                
                //新
                [self mainView];
                
                //创建顶部轮播
                for (NSDictionary *dict in [[dataArray firstObject] objectForKey:@"data"]) {
                    BroadModel *model = [[BroadModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [_broadInfoArr addObject:model];
                }
                if (_broadInfoArr.count) {
                    
                    [self createCycleScrollViewWithArray:_broadInfoArr frame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth*401/640)];
                }
                
                
                
                
                for (NSDictionary *dict in [[dataArray objectAtIndex:2]  objectForKey:@"data"]) {
                    BroadModel *model = [[BroadModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [_bottomBroadInfoArr addObject:model];
                }
                if (_bottomBroadInfoArr.count) {
                    
                    [self createCycleScrollViewWithArray:_bottomBroadInfoArr frame:CGRectMake(0, 0, kMainScreenWidth-10, 150)];
                }
                
                
            }
            
            
        }
    }];
}




#pragma mark -
#pragma mark ==新==
- (void)mainView
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIImageView imageViewWithFrame:CGRectMake(0, 0, 70, 26) image:@"ico_nav_logo.png"]];
    
    
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-49-44)];
    _backScrollView.backgroundColor = [UIColor colorFromHexRGB:@"f1fbfc"];
    _backScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_backScrollView];
    
    //中部选择栏
    
    _selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, selectedViewHeight)];
    _selectedView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:_selectedView];
    
    
    
    NSArray *nameArray = @[@"定制旅行", @"当地游", @"自由行", @"酒店套餐", @"规划师"];
    NSArray *imageArray = @[@"ico_cont_ctgr_01.png", @"ico_cont_ctgr_02.png", @"ico_cont_ctgr_03.png", @"ico_cont_ctgr_04.png", @"ico_cont_ctgr_05.png"];
    
    CGFloat w = kMainScreenWidth/selectedNum;
    CGFloat h = selectedViewHeight;
    for (NSInteger i=0; i<nameArray.count; i++) {
        
        CGFloat x = w*(i%selectedNum);
        CGFloat y = selectedViewHeight*(i/selectedNum);
        
        QBFlatButton *button = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(x, y, w, h)];
        button.tag = 1200 + i;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imageView.center = CGPointMake(w/2, (h-20)/2);
        imageView.image = IMAGE(imageArray[i]);
        [button addSubview:imageView];
        
        button.titleEdgeInsets = UIEdgeInsetsMake(selectedViewHeight-23, 0, 0, 0);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor colorFromHexRGB:@"989898"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setFaceColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setFaceColor:[UIColor colorFromHexRGB:@"f7f7f7"] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(selectedViewTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [_selectedView addSubview:button];
        
    }
    
    
    
    //产品
    CGFloat top = _selectedView.bottom;
    CGFloat w1 = (kMainScreenWidth-15)/2;
    CGFloat h1 = w1 * .95;
    
    _productView = [[UIImageView alloc] initWithFrame:CGRectMake(0, top, kMainScreenWidth, (2*h1+45))];
    _productView.userInteractionEnabled = YES;
    _productView.backgroundColor = [UIColor colorFromHexRGB:@"f1fbfc"];
    [_backScrollView addSubview:_productView];
    
    
    UIView *proTitleView = [self titleViewWithFrame:CGRectMake(0, 5, kMainScreenWidth, 30) Title:[[_titleArr safeObjectIndex:0] objectForKey:@"config_value"] color:[UIColor colorFromHexRGB:@"ff9900"]];
    [_productView addSubview:proTitleView];
       //产品推荐

    
    for (NSInteger i = 0; i < 4; i++) {
        CGFloat x = 5 + i % 2 * (w1+5);
        CGFloat y = proTitleView.bottom + 5 + (h1+5) * (i/2);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, w1, h1)];
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        view.tag = 1300 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productViewTap:)];
        [view addGestureRecognizer:tap];
        
        [_productView addSubview:view];
        
        
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w1, w1*0.7)];
        
        NSString *url = [[_proArr safeObjectIndex:i] objectForKey:@"photourl"];
        [imageView sz_setImageWithUrlString:url imageSize:@"290x192" options:SDWebImageLowPriority placeholderImageName:@"placeHolderImage_small.png"];
        
        [view addSubview:imageView];
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(5, imageView.bottom, w1-10, w1*.25) text:[[_proArr safeObjectIndex:i] objectForKey:@"photourl"]];
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 2;
        [view addSubview:label];
    }
    
    _backScrollView.contentSize = CGSizeMake(kMainScreenWidth, _productView.bottom+10);
    
    
    
    
    
}

- (UIView *)titleViewWithFrame:(CGRect)frame Title:(NSString *)title color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UILabel *proLabel = [UILabel labelWithFrame:CGRectMake(0, 5, 200, frame.size.height-10) text:title];
    proLabel.textColor = color;
    proLabel.font = [UIFont systemFontOfSize:18];
    proLabel.textAlignment = NSTextAlignmentCenter;
    proLabel.center = CGPointMake(kMainScreenWidth/2, 15);
    [view addSubview:proLabel];
//
    //IMAGEVIEW
    CGFloat width = [QuickControl widthForString:title andHeigh:20 Font:[UIFont systemFontOfSize:16]];
    UIImageView *leftImageView = [UIImageView imageViewWithFrame:CGRectMake(5, 8, (kMainScreenWidth-width)/2-20, 14) image:@""];
    UIImage *image = IMAGE(@"ico_cont_line.png");
    image = [self scaleToSize:image size:CGSizeMake(image.size.width, 14)];
    leftImageView.backgroundColor = [UIColor colorWithPatternImage:image];
    [view addSubview:leftImageView];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-5-leftImageView.width, 8, leftImageView.width, 14)];
    rightImageView.backgroundColor = [UIColor colorWithPatternImage:IMAGE(@"ico_cont_line.png")];
    [view addSubview:rightImageView];
    
    return view;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
     // 创建一个bitmap的context
     // 并把它设置成为当前正在使用的context
     UIGraphicsBeginImageContext(size);
     // 绘制改变大小的图片
     [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
     // 从当前context中创建一个改变大小后的图片
     UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
     // 使当前的context出堆栈
     UIGraphicsEndImageContext();
     return scaledImage;
 }

#pragma mark -
#pragma mark ==产品类型选择 点击事件==
- (void)selectedViewTap:(UIButton *)button
{
    NSInteger index = button.tag - 1200;
    
    CategorySlideViewController *csc = [[CategorySlideViewController alloc] init];
    csc.currentIndex = index;
    [self.navigationController pushViewController:csc animated:YES];
    
    //选择
    NSLog(@"产品类型选择index = %i", index);
}

#pragma mark -
#pragma mark ==产品 点击事件==
- (void)productViewTap:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag - 1300;
    
    NSLog(@"产品选择index = %i", index);
}

#pragma mark -
#pragma mark ==Broad==
/**
 *  头部滚动视图
 */
- (void)getBroadWithMyResultsHandle:(myResultsHandle)myResultsHandle
{
    [self hideHub];
    
    _managerObject = [[ParametersManagerObject alloc] init];

    NSArray *arr = @[@"1", @"2", @"3"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<5; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        
        if (i>=3) {
            
            [dict setObject:@"/console/appconfig/getbyid" forKey:@"path"];
            [dict setObject:@"post" forKey:@"method"];
            if (i==3) {
                [dict setObject:@{@"config_id":@"2"} forKey:@"params"];
            } else {
                [dict setObject:@{@"config_id":@"3"} forKey:@"params"];
            }
            
        } else {
            
            [dict setObject:@"/product/broad" forKey:@"path"];
            [dict setObject:@"post" forKey:@"method"];
            [dict setObject:@{@"type":arr[i]} forKey:@"params"];
            
        }
        
        [array addObject:dict];
    }
    
    
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *jsonString = [writer stringWithObject:array];
    NSLog(@"jsonString = %@", jsonString);
    
    [_managerObject addParamer:[NSString stringWithFormat:@"actiongroup=%@",jsonString]];
    
    
    
    NSData *data = [_managerObject getHeetBody];
    
    NetworkingCenter *networkingCenter = [[NetworkingCenter alloc] init];
    
    [networkingCenter setMyProgressHUD:^{
        [self showHub:@"数据加载中。。。"];
    }];
    
    [networkingCenter setMyProgressHUDHid:^{
        [self hideHub];
    }];
    
    [networkingCenter setMyResultsHandle:myResultsHandle];
    
    [networkingCenter setMyError:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
    [networkingCenter myAsynchronousPostWithUrl:mergereQuestURL postData:data];
    
}


- (void)createCycleScrollViewWithArray:(NSArray *)dataArr frame:(CGRect)frame
{
    
    //创建图片数组
    NSMutableArray *viewsArray = [[NSMutableArray alloc] init];
    for (BroadModel *model in dataArr) {
        
        [viewsArray addObject:model.photourl];
    }
    
    //初始化
    _mainScrollView = [[CycleScrollView alloc] initWithFrame:frame animationDuration:5 imageUrlArray:viewsArray];
    
    //点击了哪个view
    __weak __typeof(&*self) weakSelf = self;
    _mainScrollView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%li个",(long)pageIndex);
        
#pragma mark -
#pragma mark -轮播图点击
        BroadModel *model = dataArr[pageIndex];
        
        if ([model.url length]) {
            
            SubjectViewController *svc = [[SubjectViewController alloc] init];
            svc.url = model.url;
            [weakSelf.navigationController pushViewController:svc animated:YES];
            
        } else {
            ProductDetailViewController *myOrderFillInViewController = [[ProductDetailViewController alloc] init];
            myOrderFillInViewController.ProductId = model.pid;
            [weakSelf.navigationController pushViewController:myOrderFillInViewController animated:YES];
        }
        
        
        
    };
    
    
    //新
    if (dataArr == _broadInfoArr) {
        [_backScrollView addSubview:_mainScrollView];
        [self setViewFrame];
    } else if (dataArr == _bottomBroadInfoArr) {
        
        //底部专题
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, _productView.bottom, kMainScreenWidth, 190)];
        _footerView.userInteractionEnabled = YES;
        _footerView.backgroundColor = [UIColor colorFromHexRGB:@"f1fbfc"];
        [_backScrollView addSubview:_footerView];
        
        UIView *packageTitleView = [self titleViewWithFrame:CGRectMake(0, 5, kMainScreenWidth+5, 30) Title:[[_titleArr safeObjectIndex:1] objectForKey:@"config_value"] color:[UIColor colorFromHexRGB:@"21bb7b"]];
        [_footerView addSubview:packageTitleView];
        
        
        [_mainScrollView setFrame:CGRectMake(0, 40, kMainScreenWidth-10, 150)];
        [_footerView addSubview:_mainScrollView];
        _backScrollView.contentSize = CGSizeMake(kMainScreenWidth, _footerView.bottom+10);
    }
    
    
}

- (void)setViewFrame
{
    [self setViewFrameWithView:_selectedView Y:_mainScrollView.bottom];
    [self setViewFrameWithView:_productView Y:_selectedView.bottom];
    [self setViewFrameWithView:_footerView Y:_productView.bottom];
    
    _backScrollView.contentSize = CGSizeMake(kMainScreenWidth, _footerView.bottom+10);
}

- (void)setViewFrameWithView:(UIView *)view Y:(CGFloat)y
{
    CGRect frame = view.frame;
    frame.origin.y = y;
    [view setFrame:frame];
}


@end
