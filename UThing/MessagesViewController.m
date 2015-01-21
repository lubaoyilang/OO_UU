//
//  MessagesViewController.m
//  UThing
//
//  Created by luyuda on 15/1/14.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "MessagesViewController.h"
#import "HYSegmentedControl.h"
#import "MJRefresh.h"
#import "APRoundedButton.h"

@interface MessagesViewController ()<HYSegmentedControlDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)HYSegmentedControl *segControl;
@property (nonatomic,strong)UITableView *tableView;


@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    [self initSegBar];
    
    CGRect re = RECTMAKE(30, self.view.height-170, self.view.width-60, 50);

    [self.view addSubview:[QuickControl customButtonTitle:@"发送新消息" Frame:re Color:RGBCOLOR(246, 102, 7) Action:@selector(sendNewmessages) Target:self] ];
}


#pragma mark - segView-Delegate

- (void)initSegBar
{
    _segControl = [[HYSegmentedControl alloc] initWithOriginY:0.0 Titles:[NSArray arrayWithObjects:@"收件箱",@"发件箱", nil] delegate:self];
    [self.view addSubview:_segControl];
    

}

- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    
    
}

#pragma mark - Action

- (void)sendNewmessages
{
    
}



#pragma mark - TabViewView-Delegate

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.width, self.view.height-100) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"message"];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    _tableView.headerPullToRefreshText = @"下拉可以刷新了";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _tableView.headerRefreshingText = @"正在玩命加载中...";
    
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"正在玩命加载中...";

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 250;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 10;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    
    
    NSString *detailIndicated =@"user_listen";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    
    
    
    return cell;
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
}









@end
