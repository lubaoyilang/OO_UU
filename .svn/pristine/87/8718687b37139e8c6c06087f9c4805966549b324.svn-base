//
//  ListViewController.m
//  UThing
//
//  Created by Apple on 14/11/18.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "ListViewController.h"
#import "ListViewTableViewCell.h"
#import <CoreText/CoreText.h>
#import "MJRefresh.h"
#import "ParametersManagerObject.h"
#import "NetworkingCenter.h"
#import "ProductModel.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailViewController.h"


@interface ListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *m_tableView;
}
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) NSInteger type;
@property (nonatomic, assign, getter=isLoading) BOOL loading;
@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic, strong) NSTimer *myTimer;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"eae9e9"];
    
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    
    _dataArr = [[NSMutableArray alloc] init];
    _pageIndex = 1;
    _loading = NO;
    
    [self createTableView];
}

#pragma mark ==DownLoad Data And View==
- (void)downLoadDataWithType:(NSInteger)tpyeIndex
{
    _type = tpyeIndex;
    [self downLoadDataWithType:tpyeIndex page:1 isRefresh:NO];
}

- (void)downLoadDataWithType:(NSInteger)tpyeIndex page:(NSInteger)page isRefresh:(BOOL)isRefresh
{
    _pageIndex = page;
    
    ParametersManagerObject *managerObject = [[ParametersManagerObject alloc] init];
    
    [managerObject addParamer:[NSString stringWithFormat:@"type=%i", tpyeIndex]];
    [managerObject addParamer:[NSString stringWithFormat:@"page=%i", page]];

    
    NSData *data = [managerObject getHeetBody];
    
    NetworkingCenter *networkingCenter = [[NetworkingCenter alloc] init];
    
    if (!isRefresh) {
        [networkingCenter setMyProgressHUD:^{
            [self showHub:@"数据加载中"];
        }];
    }
    
    
    
    [networkingCenter myAsynchronousPostWithUrl:listURL postData:data];

    [networkingCenter setMyResultsHandle:^(NSMutableData *resultData) {
        
        if (page==1) {
            [_dataArr removeAllObjects];
        }
        
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"ddd = %@",resultDict);
        
        [self hideHub];
        
        
        //验证
        if ([managerObject checkSign:[resultDict objectForKey:@"data"] Sign:[resultDict objectForKey:@"sign"]]) {
            NSLog(@"验证成功");
            
            NSString *dataString = [NSString stringWithFormat:@"%@", [[resultDict objectForKey:@"data"] objectForKey:@"data"]];
            NSArray *dataArray = [[resultDict objectForKey:@"data"] objectForKey:@"data"];
            NSLog(@"data = %@", dataString);
            if (![dataString isEqualToString:@"0"]) {
                
                [self initHeaderViewWithDictionary:[dataArray firstObject]];
                
                if ([dataArray count]) {
                    for (NSDictionary *productDict in dataArray) {
                        ProductModel *productModel = [[ProductModel alloc] init];
                        [productModel setValuesForKeysWithDictionary:productDict];
                        [_dataArr addObject:productModel];
                    }
                    
                    [m_tableView reloadData];
                }
                
                
            }
            else if([dataString isEqualToString:@"0"]) {
            
                
                _alertView = [[UIAlertView alloc] init];
                _alertView.message = @"产品已全部加载";
                _alertView.delegate = self;
                

                
                _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                 target:self
                                               selector:@selector(dismissAlertView:)
                                               userInfo:nil
                                                repeats:NO];
                
                [_alertView show];
                
   
            }
        
            
            
        }
        [m_tableView footerEndRefreshing];
        [m_tableView headerEndRefreshing];
        
    }];
    [networkingCenter setMyError:^(NSError *error) {
        
        [self hideHub];
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark-
#pragma mark -头部大视图－
- (void)initHeaderViewWithDictionary:(NSDictionary *)dict
{
    UIImageView *headProView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 200)];
    [headProView sz_setImageWithUrlString:[dict objectForKey:@""] imageSize:@"676x449" options:SDWebImageLowPriority placeholderImageName:@""];
}


- (void)dismissAlertView:(NSTimer *)timer
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    
}

#pragma mark - ========Table View========
- (void)createTableView
{
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49-64) style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_tableView.showsVerticalScrollIndicator = NO;

    //////////////////////
    
    [m_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mjCell"];
    
    [m_tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];

    //[self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [m_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    m_tableView.headerPullToRefreshText = @"下拉可以刷新了";
    m_tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    m_tableView.headerRefreshingText = @"正在玩命加载中...";
    
    m_tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    m_tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    m_tableView.footerRefreshingText = @"正在玩命加载中...";
    
    
    ////////////////////
    
    
    
    
    [self.view addSubview:m_tableView];
}

- (void)headerRereshing
{
    [self downLoadDataWithType:_type page:1 isRefresh:YES];
}
- (void)footerRereshing
{
    _pageIndex++;
    [self downLoadDataWithType:_type page:_pageIndex isRefresh:YES];
}

/*
 * table View Delegate
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    ListViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ListViewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:cell.bounds];
        backgroundView.image = [UIImage imageNamed:@"bg_link.png"];
        cell.backgroundView = backgroundView;
        
        UIImageView *selectedBackgroundView = [[UIImageView alloc] initWithFrame:cell.bounds];
        selectedBackgroundView.image = [UIImage imageNamed:@"bg_active.png"];
        cell.selectedBackgroundView = selectedBackgroundView;

    }
    
    ProductModel *model = _dataArr[indexPath.row];
    [cell.iconView sz_setImageWithUrlString:model.cover_photo_url imageSize:@"212x140" options:SDWebImageLowPriority placeholderImageName:@"placeHolderImage.png"];
    cell.cellTitleLabel.text = model.title;
    cell.cellSubTitleLabel.text = model.subtitle;
    cell.priceLabel.text = [NSString moneyFromThousand:[NSString stringWithFormat:@"%@",model.low_price]];
    
    [cell.priceLabel sizeToFit];
    [cell.unitLabel setFrame:CGRectMake(15+cell.priceLabel.bounds.size.width+3, 6, 7, 16)];
    [cell.unitLabel sizeToFit];
    CGFloat w = 15+cell.priceLabel.bounds.size.width+3+cell.unitLabel.bounds.size.width;
    [cell.priceBackView setFrame:CGRectMake(self.view.bounds.size.width-w-2, 99-22, w, 22)];
    //config cell
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
    
    ProductModel *productModel = _dataArr[indexPath.row];
    
    ProductDetailViewController *myOrderFillInViewController = [[ProductDetailViewController alloc] init];
    myOrderFillInViewController.ProductId = [NSString stringWithFormat:@"%i",productModel.id];
    [self.navigationController pushViewController:myOrderFillInViewController animated:YES];
}







- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    //取消定时器
    [_myTimer invalidate];
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
