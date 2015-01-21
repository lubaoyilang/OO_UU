//
//  HotelPackagesViewController.m
//  UThing
//
//  Created by luyuda on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "HotelPackagesViewController.h"

#import "UIImageView+WebCache.h"
#import "HotelPackagesTableViewCell.h"
#import "NetworkingCenter.h"
#import "ProductModel.h"
#import "CWStarRateView.h"
#import "MJRefresh.h"
#import "PriceView.h"
#import "HotelProductDetailViewController.h"
#import "ReserveViewController.h"
#import "DepositPayViewController.h"


@interface HotelPackagesViewController ()<UITableViewDelegate, UITableViewDataSource, HotelPackagesDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic) CGFloat cellHeight;

@property (nonatomic, strong) NSTimer *myTimer;

//刷新数据
@property (nonatomic) NSInteger page;

@end

@implementation HotelPackagesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _cellHeight = ((kMainScreenWidth-30)/2)*400/640+40;
    
    //instantiation 实例化
    _page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    
    //ios7适配
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    
    //下载网络数据
    [self downloadDataWithPage:_page];
    
    //列表页创建
    [self initView];
    
    
    
}

#pragma mark ==Network Data==
/**
 *  下载网络数据
 */
- (void)downloadDataWithPage:(NSInteger)page
{
    _page = page;
    
    ParametersManagerObject *managerObject = [[ParametersManagerObject alloc] init];
    
    //test
    NSInteger typeIndex = 5;
    [managerObject addParamer:[NSString stringWithFormat:@"type=%i", typeIndex]];
    
    if (_page) {
        [managerObject addParamer:[NSString stringWithFormat:@"length=11"]];
    }
    
    [managerObject addParamer:[NSString stringWithFormat:@"page=%i", page]];
    
    NSData *data = [managerObject getHeetBody];
    
    NetworkingCenter *networkingCenter = [[NetworkingCenter alloc] init];
    
    [networkingCenter setMyProgressHUD:^{
        [self showHub:@"酒店套餐加载中"];
    }];
    
    [networkingCenter myAsynchronousPostWithUrl:hotelListURL postData:data];
    
    
    
    
    [networkingCenter setMyResultsHandle:^(NSMutableData *resultData) {
        
        [self hideHub];
        
        
        if (page==1) {
            [_dataArray removeAllObjects];
        }
        
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
        
        //验证
        if ([managerObject checkSign:[resultDict objectForKey:@"data"] Sign:[resultDict objectForKey:@"sign"]]) {
            NSLog(@"验证成功");
            
            NSString *dataString = [NSString stringWithFormat:@"%@", [[resultDict objectForKey:@"data"] objectForKey:@"data"]];
            NSArray *dataArray = [[resultDict objectForKey:@"data"] objectForKey:@"data"];
            NSLog(@"hotel data = %@", dataString);
            if (![dataString isEqualToString:@"0"]) {
                
                
                if ([dataArray count]) {
                    for (NSDictionary *productDict in dataArray) {
                        ProductModel *productModel = [[ProductModel alloc] init];
                        [productModel setValuesForKeysWithDictionary:productDict];
                        [_dataArray addObject:productModel];
                    }
                    
                    [_tableView reloadData];
                    
                    [self headerView];
                }
                
                
                
            }
            else if([dataString isEqualToString:@"0"]) {
                
                
                _alertView = [[UIAlertView alloc] init];
                //                _alertView.title = @"温馨提示";
                _alertView.message = @"产品已全部加载";
                _alertView.delegate = self;
                
                
                
                _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                 target:self
                                               selector:@selector(dismissAlertView:)
                                               userInfo:nil
                                                repeats:NO];
                
                [_alertView show];
                
                
                
            }
            [_tableView footerEndRefreshing];
            [_tableView headerEndRefreshing];
        }
        
        
    }];
    [networkingCenter setMyError:^(NSError *error) {
        [self hideHub];
        NSLog(@"error = %@", error);
    }];

}

- (void)dismissAlertView:(NSTimer *)timer
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    
}


- (void)headerView
{
    //头部视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth-20, kMainScreenWidth*400/640+50)];
    headerView.backgroundColor = [UIColor whiteColor];
    //图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth-20, kMainScreenWidth*400/640)];
    imageView.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClick:)];
    [imageView addGestureRecognizer:tap];
    
    ProductModel *model = [_dataArray firstObject];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[model.cover_photo_url replaceCharcter:@"index" withCharcter:@"320x215"]] placeholderImage:LOADIMAGE(@"placeHolderImage_small", @"png") options:SDWebImageLowPriority];
    [headerView addSubview:imageView];
    
    //Price
    NSString *str = [NSString stringWithFormat:@"￥%@/人起", [NSString moneyFromThousand:model.low_price]];
    CGFloat width = [QuickControl widthForString:str andHeigh:20 Font:[UIFont boldSystemFontOfSize:18]];
    UILabel *priceLabel = [UILabel labelWithFrame:CGRectMake(imageView.width-width-10, imageView.height -60, width+10, 25) text:str];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.font = [UIFont boldSystemFontOfSize:18];
    priceLabel.alpha = .9;
    priceLabel.backgroundColor = [UIColor colorFromHexRGB:@"ee8f00"];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    
    [imageView addSubview:priceLabel];

    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kMainScreenWidth*400/640+5, kMainScreenWidth-20, 18)];
    titleLabel.text = model.title;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:titleLabel];
    //酒店标题
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kMainScreenWidth*400/640+5+23, kMainScreenWidth-20, 18)];
    subTitleLabel.text = @"酒店星级: ";
    subTitleLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:subTitleLabel];
    
    CWStarRateView *starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(90, kMainScreenWidth*400/640+5+23, 100, 18) numberOfStars:5];
    starView.userInteractionEnabled = NO;
    starView.scorePercent = [model.star intValue]/5;
    [headerView addSubview:starView];
    
    _tableView.tableHeaderView =  headerView;
}


#pragma mark ==View==
/**
 *  列表页创建
 */
- (void)initView
{
    //列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, self.view.bounds.size.height-49-64-10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    
    
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mjCell"];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    
    //[self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.headerPullToRefreshText = @"下拉可以刷新了";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _tableView.headerRefreshingText = @"正在玩命加载中...";
    
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"正在玩命加载中...";
    
    
    
    
    [self.view addSubview:_tableView];
}


- (void)headerRereshing
{
    [self downloadDataWithPage:1];
}
- (void)footerRereshing
{
    _page++;
    [self downloadDataWithPage:_page];
}



/**
 *  酒店套餐列表显示
 *
 *  @return delegate
 */
#pragma mark ==TableView Delegate==
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count/2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HotelPackagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HotelPackagesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    cell.indexRow = indexPath.row;
    
    if (_dataArray.count != 0) {
        cell.leftModel = _dataArray[indexPath.row*2+1];
        
        cell.rightModel = nil;
        if ((indexPath.row*2+2) < _dataArray.count) {
            
            cell.rightModel = _dataArray[indexPath.row*2+2];
        }
        
        
        //重新显示数据
        [cell reloadCellData];
    }
    
    
    return cell;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    //取消定时器
    [_myTimer invalidate];
}


#pragma mark ==HotelPackagesCell Delegate==
/**
 *  酒店套餐 产品点击回调函数
 *
 *  @param index  值为第几个产品
 */
- (void)hotelPackagesClickIndex:(NSInteger)index
{
    NSLog(@"HomePackages index = %i", index);
    
    
    HotelProductDetailViewController *hp = [[HotelProductDetailViewController alloc] init];
    ProductModel *model =[_dataArray safeObjectIndex:(index+1)];
    
    hp.ProductId = [NSString stringWithFormat:@"%d",model.id];

    [self.navigationController pushViewController:hp animated:YES];
}

/**
 *  酒店套餐  第一个产品视图点击事件
 */
- (void)headerViewClick:(UITapGestureRecognizer *)tap
{
    [self hotelPackagesClickIndex:-1];
}

@end
