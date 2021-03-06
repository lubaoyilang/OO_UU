//
//  CycleScrollView.m
//  Product
//
//  Created by Apple on 14/12/25.
//  Copyright (c) 2014年 Wushengzhong. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"




@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;

@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSArray *imageUrlArray;

@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) UIPageControl *pageControl;

@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;

@end

@implementation CycleScrollView


- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

#pragma mark -
#pragma mark - 初始化函数


- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration imageUrlArray:(NSArray *)imageUrlArray
{
    //[self handleImageViewArray:imageUrlArray withFrame:frame];
    _totalPageCount = imageUrlArray.count;
    _imageUrlArray = imageUrlArray;
    self = [self initWithFrame:frame animationDuration:animationDuration];
    if (self) {
        
    }
    return self;
}



/**
 *  自动循环滚动 初始化函数
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        if (_totalPageCount != 1) {
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                                   target:self
                                                                 selector:@selector(animationTimerDidFired:)
                                                                 userInfo:nil
                                                                  repeats:YES];
            
            [[NSRunLoop mainRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
            
            [self.animationTimer pauseTimer];
        }
        
    }
    return self;
}


/**
 *  循环滚动 初始化函数
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //子视图会根据autoresizingMask属性的值自动进行尺寸调整
        self.autoresizesSubviews = YES;
        
        //初始化scrollView
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        for (int i=0; i<3; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth*i, 0, self.width, self.height)];
            imageView.tag = 213 + i;
            [self.scrollView addSubview:imageView];
        }
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
        
        if (_imageUrlArray.count) {
            if (_totalPageCount == 1) {
                
                self.scrollView.scrollEnabled = NO;
            }
            else {
                // 初始化 pagecontrol
                self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,0,300,18)]; // 初始化mypagecontrol
                self.pageControl.center = CGPointMake(frame.size.width/2, frame.size.height-15);
                [self.pageControl setCurrentPageIndicatorTintColor:[UIColor colorFromHexRGB:@"ee8f00"]];
                [self.pageControl setPageIndicatorTintColor:[UIColor blackColor]];
                self.pageControl.userInteractionEnabled = NO;
                self.pageControl.currentPage = 0;
                
                [self addSubview: self.pageControl];
                
                
            }
            
            [self configContentViews];
        } else {
            self.scrollView.scrollEnabled = NO;
            [self.scrollView addSubview:[UIImageView imageViewWithFrame:CGRectMake(kMainScreenWidth, 0, kMainScreenWidth, frame.size.height) image:@"placeHolderImage.png"]];
        }
        
        
        
        
        
        
        // 后续扩展 pagecontrol 点击切换视图
//        [self.pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    }
    return self;
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    self.pageControl.numberOfPages = _totalPageCount;
    //
    
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    
    if (!self.fetchContentViewAtIndex) {
        for (int i=0; i<3; i++) {
            UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:213+i];
            [imageView sz_setImageWithUrlString:_contentViews[i] imageSize:@"640x423" options:SDWebImageLowPriority placeholderImageName:@"placeHolderImage.png"];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
            [imageView addGestureRecognizer:tapGesture];
        }
    }
    else {
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (UIView *contentView in self.contentViews) {
            contentView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
            [contentView addGestureRecognizer:tapGesture];
            CGRect rightRect = contentView.frame;
            rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
            contentView.frame = rightRect;
            [self.scrollView addSubview:contentView];
        }
    }
    
   
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}


/**
 *  设置scrollView的content数据源，即contentViews     count始终为3  存放为pageIndex
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    
    if (self.fetchContentViewAtIndex) {
        
        
        
        [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
        
    }
    else {
        
        if (_totalPageCount == 1) {
            
            
            [self.contentViews addObject:[_imageUrlArray[previousPageIndex] mutableCopy]];
            [self.contentViews addObject:[_imageUrlArray[_currentPageIndex] mutableCopy]];
            [self.contentViews addObject:[_imageUrlArray[rearPageIndex] mutableCopy]];
            
            
        }
        else {
            
            if (_imageUrlArray.count) {
                [self.contentViews addObject:[[_imageUrlArray safeObjectIndex:previousPageIndex] mutableCopy]];
                [self.contentViews addObject:[[_imageUrlArray safeObjectIndex:_currentPageIndex] mutableCopy]];
                [self.contentViews addObject:[[_imageUrlArray safeObjectIndex:rearPageIndex] mutableCopy]];
            } else {
//                [self.contentViews addObject:nil];
            }
            
            
        }
        
    }
}


/**
 *  初始化viewsArray
 *
 *  @param imageUrlArray     url数组
 *  @param frame
 */
- (void)handleImageViewArray:(NSArray *)imageUrlArray withFrame:(CGRect)frame
{
    _imageViewArray = [[NSMutableArray alloc] init];
    for (NSString *stringUrl in imageUrlArray) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sz_setImageWithUrlString:stringUrl imageSize:@"640x423" options:SDWebImageLowPriority placeholderImageName:@"placeHolderImage.png"];
        [_imageViewArray addObject:imageView];
    }
}


/**
 *  获取第几张图片
 */
- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}


#pragma mark -
#pragma mark - UIScrollViewDelegate
/**
 *  滚动视图代理方法  处理定时器的启动和停止
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        //NSLog(@"next，当前页:%li",(long)self.currentPageIndex);
        self.pageControl.currentPage = self.currentPageIndex;
        
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        NSLog(@"previous，当前页:%li",(long)self.currentPageIndex);
        self.pageControl.currentPage = self.currentPageIndex;
        [self configContentViews];
    }
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}


#pragma mark -
#pragma mark - 响应事件
/**
 *  timer 响应事件
 */
- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}


/**
 *  滚动视图 点击响应事件
 */
- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
