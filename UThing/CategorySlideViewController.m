//
//  CategorySlideViewController.m
//  UThing
//
//  Created by Apple on 15/1/19.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "CategorySlideViewController.h"
#import "HYSegmentedControl.h"

#import "MruMakeViewController.h"
#import "OverseasTourViewController.h"
#import "FreeTourViewController.h"
#import "HotelPackagesViewController.h"
#import "TourStewardDetailViewController.h"

@interface CategorySlideViewController ()<UIScrollViewDelegate, HYSegmentedControlDelegate>

@property (nonatomic, strong) HYSegmentedControl *segControl;

@property (nonatomic, strong) UIScrollView *backSView;

@end

@implementation CategorySlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initSegBar];
    
    [self initMainView];
}


- (void)initSegBar
{
    _segControl = [[HYSegmentedControl alloc] initWithOriginY:0.0 Titles:[NSArray arrayWithObjects:@"定制旅行", @"当地游", @"自由行", @"酒店套餐", @"规划师" ,nil] delegate:self];
    [_segControl changeSegmentedControlWithIndex:_currentIndex];
    [self.view addSubview:_segControl];
    
}


- (void)initMainView
{
    
    _backSView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segControl.bottom, kMainScreenWidth, kMainScreenHeight-_segControl.bottom)];
    _backSView.userInteractionEnabled = YES;
    _backSView.pagingEnabled = YES;
    _backSView.delegate = self;
    
    MruMakeViewController *mmvc = [[MruMakeViewController alloc] init];
    mmvc.view.frame = CGRectMake(0, 0, kMainScreenHeight, _backSView.height);
    [_backSView addSubview:mmvc.view];
    [self addChildViewController:mmvc];
    
    OverseasTourViewController *otvc = [[OverseasTourViewController alloc] init];
    otvc.view.frame = CGRectMake(kMainScreenWidth, 0, kMainScreenHeight, _backSView.height);
    [_backSView addSubview:otvc.view];
    [self addChildViewController:otvc];
    
    FreeTourViewController *ftvc = [[FreeTourViewController alloc] init];
    ftvc.view.frame = CGRectMake(kMainScreenWidth*2, 0, kMainScreenHeight, _backSView.height);
    [_backSView addSubview:ftvc.view];
    [self addChildViewController:ftvc];
    
    HotelPackagesViewController *hpvc = [[HotelPackagesViewController alloc] init];
    hpvc.view.frame = CGRectMake(kMainScreenWidth*3, 0, kMainScreenHeight, _backSView.height);
    [_backSView addSubview:hpvc.view];
    [self addChildViewController:hpvc];
    
    TourStewardDetailViewController *tsdvc = [[TourStewardDetailViewController alloc] init];
    tsdvc.view.frame = CGRectMake(kMainScreenWidth*4, 0, kMainScreenHeight, _backSView.height);
    [_backSView addSubview:tsdvc.view];
    [self addChildViewController:tsdvc];
    
    _backSView.contentOffset = CGPointMake(kMainScreenWidth*_currentIndex, 0);
    
    _backSView.contentSize = CGSizeMake(kMainScreenHeight*5, _backSView.height);
    [self.view addSubview:_backSView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < kMainScreenWidth*5 || scrollView.contentOffset.x > 0) {
        NSInteger index = scrollView.contentOffset.x/kMainScreenWidth;
        [_segControl changeSegmentedControlWithIndex:index];
    }
    
}



- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
     NSLog(@"indexss = %i", index);
    [UIView animateWithDuration:0.5 animations:^{
        _backSView.contentOffset = CGPointMake(kMainScreenWidth*index, 0);
    }];
    
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
