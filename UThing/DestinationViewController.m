//
//  DestinationViewController.m
//  UThing
//
//  Created by luyuda on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "DestinationViewController.h"
#import "NetworkingCenter.h"

#import "pinyin.h"

#import "DestinationListViewController.h"

#define TableViewRate 0.36
#define TableViewCellHeight 48.0f

/**
 *  当前选中的行数,默认选择第一行
 */
static int selectRow = 0;

@interface DestinationViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *d_countryBackView;
    UIImageView *d_continentBackView;
    
    UITableView *d_countryTableView;
    UITableView *d_continentTableView;
    
    NSMutableArray *arrCountryDataArray;
    NSMutableArray *arrContinentDataArray;
    NSArray *arrData;
}
@property (nonatomic, strong) NSString *currentContinent;
@property (nonatomic) int indexRow;
@end

@implementation DestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
  
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backView.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app-search_02" ofType:@"png"]];
    [self.view addSubview:backView];
    
    [self downloadData];
    
    [self createContinentTableView];
    
    [self createCountryTableView];
    
    
    
}



/*
 * 下载数据
 */
#pragma mark - download Data
- (void)downloadData
{
    //continent
    ParametersManagerObject *managerObject = [[ParametersManagerObject alloc] init];
    
    
    NSString *sign = [NSString stringWithFormat:@"sign=%@", [managerObject getSign]];

    //id、pid、name

    NSData *data = [sign dataUsingEncoding:NSUTF8StringEncoding
                      allowLossyConversion:YES];
    
    NetworkingCenter *networkingCenter = [[NetworkingCenter alloc] init];
    
    [networkingCenter setMyProgressHUD:^{
        [self showHub:@"数据加载中"];
    }];
    [networkingCenter setMyProgressHUDHid:^{
        [self hideHub];
    }];
    
    [networkingCenter myAsynchronousPostWithUrl:getDesURL postData:data];
    
    [networkingCenter setMyResultsHandle:^(NSMutableData *resultData) {
        [self hideHub];
        
        //返回结果
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
        
        //验证
        if ([managerObject checkSign:[resultDict objectForKey:@"data"] Sign:[resultDict objectForKey:@"sign"]]) {
            NSLog(@"修改密码 验证成功");
            
            
            [self handleTheResultData:[resultDict objectForKey:@"data"]];
            
        }
        
        
    }];
    [networkingCenter setMyError:^(NSError *error) {
        [self hideHub];
        NSLog(@"error = %@", error);
    }];
}


/**
 *  返回数据结构解析
 *
 *  @param resultDict data里面数据结构为字典
 */
- (void)handleTheResultData:(NSDictionary *)resultDict
{

    
    for (NSDictionary *dict in [resultDict allValues]) {
        
        //存储洲的数据
        [arrContinentDataArray addObject:[[dict objectForKey:@"continent"] objectForKey:@"name"]];

        
        //存储国家的数据
        NSDictionary *countryDict = [dict objectForKey:@"country"];
        NSMutableArray *countryArray = [[NSMutableArray alloc] init];
        for (NSDictionary *subCountryDict in [countryDict allValues]) {
            [countryArray addObject:subCountryDict];
        }
    
        NSLog(@"sortArray = %@", countryArray);
        NSArray *sortArray = [self sortArrayWithPinyin:countryArray];
        NSLog(@"sortArray = %@", sortArray);
        
        [arrCountryDataArray addObject:sortArray];
    }
    [d_countryTableView reloadData];
    [d_continentTableView reloadData];
}


- (void)createContinentTableView
{
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*TableViewRate, self.view.bounds.size.height-44)];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    
    arrContinentDataArray = [[NSMutableArray alloc] init];
//    arrContinentData = @[@"亚洲",@"欧洲",@"非洲",@"北美洲",@"南美洲",@"大洋洲",@"南极洲"];
    d_continentTableView = [self createTableViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*TableViewRate, self.view.bounds.size.height-64-49)];
    
    
    
    [backView addSubview:d_continentTableView];
    
}

- (void)createCountryTableView
{
    arrCountryDataArray = [[NSMutableArray alloc] init];
    //arrCountryData = @[@"日本",@"越南",@"缅甸",@"韩国",@"泰国",@"老挝",@"菲律宾", @"马来西亚"];
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width *TableViewRate, 0, self.view.bounds.size.width*(1-TableViewRate), self.view.bounds.size.height-44)];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];

    d_countryTableView = [self createTableViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*(1-TableViewRate), self.view.bounds.size.height-64-49)];

    [backView addSubview:d_countryTableView];
}

- (UITableView *)createTableViewWithFrame:(CGRect)frame
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableView;
}


#pragma mark ==tableView Delegate==
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == d_continentTableView) {
        return arrContinentDataArray.count;
    }
    else if(tableView == d_countryTableView){
        if (arrCountryDataArray.count) {
            NSArray *array = arrCountryDataArray[_indexRow];
            return array.count;
        }
        return 0;
    }
    else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    static NSString *cellID2 = @"cell2";
    static NSString *cellName;

    if (tableView == d_continentTableView) {
        cellName = cellID;
        arrData = arrContinentDataArray;
    }
    else{
        cellName = cellID2;
        NSArray *array = arrCountryDataArray[_indexRow];
        arrData = array;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        [self configTheCell:tableView with:cell];
        
       
        if ([cellName isEqualToString:@"cell"]) {
            UIButton *pointBtn = [[UIButton alloc] initWithFrame:CGRectMake(d_continentTableView.bounds.size.width*0.8, 12, 12, 20)];
            
            [pointBtn setBackgroundImage:[UIImage imageNamed:@"desR_normal.png"] forState:UIControlStateNormal];
            [pointBtn setBackgroundImage:[UIImage imageNamed:@"desR_selected.png"] forState:UIControlStateSelected];
            pointBtn.tag = indexPath.row+210;
            [cell.contentView addSubview:pointBtn];
            
            if (indexPath.row == selectRow ) {
                pointBtn.selected = YES;
            }
            
            
            //cell选中背景
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
            cell.selectedBackgroundView.backgroundColor = [UIColor colorFromHexRGB:@"eeeced"];
            cell.selectedBackgroundView.alpha = 1;
            
            //默认选择第一行
            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [d_continentTableView selectRowAtIndexPath:firstPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
    }

    [self configTheView:cell tableView:tableView with:indexPath.row];
    
    return cell;
}

//cell evaluation
- (void)configTheView:(UITableViewCell *)cell tableView:(UITableView *)tableView with:(NSInteger)index
{
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    if (tableView == d_continentTableView) {
        cell.textLabel.highlightedTextColor = [UIColor colorFromHexRGB:@"1ba2ae"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = arrData[index];
    }
    else{
        NSDictionary *dict = arrData[index];
        cell.textLabel.text = [dict objectForKey:@"name"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableViewCellHeight;
}

- (void)configTheCell:(UITableView *)tableView with:(UITableViewCell *)superView
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, TableViewCellHeight-0.5, self.view.bounds.size.width, 0.5)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"cccccc"];
    [superView.contentView addSubview:lineView];
    
    if (tableView == d_continentTableView) {
        superView.backgroundView = [[UIView alloc] initWithFrame:superView.frame];
        superView.selectedBackgroundView.backgroundColor = [UIColor colorFromHexRGB:@"ffffff"];
        
        
    }
}

#pragma mark == Continent And Country Click ==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (tableView == d_continentTableView) {
        _indexRow = indexPath.row;
         NSLog(@"indexPath = %i", indexPath.row);
        [self continentClickAtIndex:indexPath.row];
        
        //continent accessoryView
        
        UIButton *button = (UIButton *)[self.view viewWithTag:selectRow+210];
        button.selected = NO;
        button = (UIButton *)[self.view viewWithTag:indexPath.row+210];
        button.selected = YES;
        selectRow = indexPath.row;
        
    }
    else if(tableView == d_countryTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self countryClickAtIndex:indexPath.row];
    }
}


/**
 *  大洲 点击事件处理
 *
 *  @param index 点击第几个
 */
- (void)continentClickAtIndex:(NSInteger)index
{
    NSLog(@"continent == %i", index);
    
    
    
    [d_countryTableView reloadData];
    
    
}
/**
 *  大洲 点击---进入国家产品页
 *
 *  @param index 点击第几个
 */
- (void)countryClickAtIndex:(NSInteger)index
{
    NSLog(@"country == %i", index);
    
    
    DestinationListViewController *desListViewController = [[DestinationListViewController alloc] init];
    NSDictionary *countryDict = [[arrCountryDataArray objectAtIndex:_indexRow] objectAtIndex:index];
    desListViewController.countryId = [countryDict objectForKey:@"id"];
    [self.navigationController pushViewController:desListViewController animated:YES];
}

- (NSArray *)sortArrayWithPinyin:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[array count]; i++) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[array objectAtIndex:i]];
        NSString *string = [[array objectAtIndex:i] objectForKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%c",pinyinFirstLetter([string characterAtIndex:0])] forKey:@"key"];
        
        [tempArray addObject:dict];
    }
    
    NSArray *sortArray = [self sortDataArr:tempArray forKey:@"key"];
    
    for (NSMutableDictionary *dict in sortArray) {
        [dict removeObjectForKey:@"key"];
    }
    
    return sortArray;
}

- (NSArray *)sortDataArr:(NSArray *)dataArr forKey:(NSString *)key
{
    //方式二(单条件排序)
    NSMutableArray *array = [NSMutableArray arrayWithArray:dataArr];
    /* @param ascending  YES//升序   NO//降序 */
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES];
    /* array 就是返回值 */
    [array sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    
    return array;
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
