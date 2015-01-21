//
//  DateOutViewController.m
//  UThing
//
//  Created by luyuda on 14/11/18.
//  Copyright (c) 2014年 UThing. All rights reserved.
//




#import "DateOutViewController.h"
#import "MyOrderFillInViewController.h"
#import "TextFieldAndSelectedView.h"
#import "UthingAlertView.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalPrivate.h"
#import "IIViewDeckController.h"
#define PROFILER 0
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>
void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};
    
    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}
#endif

NSString *const KalDataSourceChangedNotification = @"KalDataSourceChangedNotification";


@interface DateOutViewController ()

@property (nonatomic,strong)UIView *ButtomView;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)NSMutableArray *cityNameArray;
@property (nonatomic,strong)NSMutableData *receivedData;
@property (nonatomic,strong)id dataDict;
@property (nonatomic,strong)NSDictionary *selectDict;
@property (nonatomic,strong)UIScrollView *bgView;
@property (nonatomic,assign)NSInteger pre_days;
@property (nonatomic,strong)TextFieldAndSelectedView *chengrenView;
@property (nonatomic,strong)TextFieldAndSelectedView *childView;
@property (nonatomic,strong)TextFieldAndSelectedView *roomNumView;
@property (nonatomic,strong)TextFieldAndSelectedView *roomtypeView;

@property (nonatomic,strong)UILabel *chengrenPrice;
@property (nonatomic,strong)UILabel *ertongPrice;
@property (nonatomic,strong)UILabel *ertong;

@property (nonatomic,strong)NSString *selectTitle;

- (KalView*)calendarView;


@property (nonatomic,assign)BOOL isFirstLoad;


@end



@implementation DateOutViewController
@synthesize dataSource, delegate,productDict;

- (void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    
    if (!_isFirstLoad) {
        return;
    }
    
    
    
    self.calendarView.gridView.beginDate = _selectedDate;
    [self showAndSelectDate:_selectedDate];
    _selectDict = [self getInfoWithDate:_selectedDate];
    
    [self changeButtomInfo];
    
    
    
    
    
    BOOL isHave = [self isHaveChild:_selectDict];
    if (isHave) {
        //
        _ertong.hidden = NO;
        _ertongPrice.hidden = NO;
        _childView.hidden = NO;
        _childView.textField.text = @"0";
        
    }else{
        _ertong.hidden = YES;
        _ertongPrice.hidden = YES;
        _childView.hidden = YES;
        _childView.textField.text = @"0";
    }
    
    
    
}

- (void)setBeginDate:(NSDate *)beginDate
{
    _beginDate = beginDate;
    self.calendarView.gridView.beginDate = _beginDate;
    [self showAndSelectDate:_beginDate];
}

- (void)setEndDate:(NSDate *)endDate
{
    _endDate = endDate;
    self.calendarView.gridView.endDate = _endDate;
    [(KalView *)[self.view viewWithTag:28881] redrawEntireMonth];
}

- (void)setMinAvailableDate:(NSDate *)minAvailableDate
{
    _minAvailableDate = minAvailableDate;
    ((KalView *)[self.view viewWithTag:28881]).gridView.minAvailableDate = minAvailableDate;
    [(KalView *)[self.view viewWithTag:28881] redrawEntireMonth];
}

- (void)setMaxAVailableDate:(NSDate *)maxAVailableDate
{
    _maxAVailableDate = maxAVailableDate;
    ((KalView *)[self.view viewWithTag:28881]).gridView.maxAVailableDate = maxAVailableDate;
    [(KalView *)[self.view viewWithTag:28881] redrawEntireMonth];
}

- (id)initWithSelectionMode:(KalSelectionMode)selectionMode;
{
    if ((self = [super init])) {
        logic = [[KalLogic alloc] initForDate:[NSDate date]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
        self.selectionMode = selectionMode;
//        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//        }
    }
    return self;
}

- (id)init
{
    
    self.hidesBottomBarWhenPushed = YES;

    
    return [self initWithSelectionMode:KalSelectionModeSingle];
}

- (KalView*)calendarView { return (KalView*)[self.view viewWithTag:28881]; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
    if (dataSource != aDataSource) {
        dataSource = aDataSource;
        tableView.dataSource = dataSource;
    }
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
    if (delegate != aDelegate) {
        delegate = aDelegate;
        tableView.delegate = delegate;
    }
}

- (void)clearTable
{
    [dataSource removeAllItems];
    [tableView reloadData];
}

- (void)reloadData
{
    [dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self];
}

- (void)significantTimeChangeOccurred
{
    [[self calendarView] jumpToSelectedMonth];
    [self reloadData];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)changeFrame:(CGRect)frame
{
    NSLog(@"new frame x= %f y = %f w= %f h = %f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);

    [self changeButtom:frame.origin.y+75];

}

- (void)didSelectDate:(NSDate *)date
{
    //日期选择回调
    
    [self setSelectedDate:date];
    NSDate *from = [date cc_dateByMovingToBeginningOfDay];
    NSDate *to = [date cc_dateByMovingToEndOfDay];
    [dataSource loadItemsFromDate:from toDate:to];
    
    
    _selectDict = [self getInfoWithDate:_selectedDate];
    
    
    
//    int stock = [[_selectDict  objectForKey:@"stock"] integerValue];
//    if (stock == 0) {
//        _roomNumView.textField.text =@"0";
//        _chengrenView.textField.text = @"0";
//        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提醒" message: @"该日期已售罄" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [al show];
//    }
    
    BOOL isHave = [self isHaveChild:_selectDict];
    if (isHave) {
        //
        _ertong.hidden = NO;
        _ertongPrice.hidden = NO;
        _childView.hidden = NO;
        _childView.textField.text = @"0";
        
    }else{
        _ertong.hidden = YES;
        _ertongPrice.hidden = YES;
        _childView.hidden = YES;
        _childView.textField.text = @"0";
    }
    
    
    
}


- (void)showPreviousMonth
{
    [logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
}

- (void)showFollowingMonth
{
    [logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
    NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
    NSMutableArray *dates = [markedDates mutableCopy];
    for (int i=0; i<[dates count]; i++)
        [dates replaceObjectAtIndex:i withObject:[dates objectAtIndex:i]];
    
    [[self calendarView] markTilesForDates:dates];
}

// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
    if ([[self calendarView] isSliding])
        return;
    
    [logic moveToMonthForDate:date];
    
#if PROFILER
    uint64_t start, end;
    struct timespec tp;
    start = mach_absolute_time();
#endif
    
    [[self calendarView] jumpToSelectedMonth];
    
#if PROFILER
    end = mach_absolute_time();
    mach_absolute_difference(end, start, &tp);
    printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
    
    [self reloadData];
}

// -----------------------------------------------------------------------------------
#pragma mark UIViewController






- (void)loadView
{
    [super loadView];

    if (!self.title)
        self.title = @"选择出行";
    

}
//- (void) viewDidLayoutSubviews {
//    CGRect viewBounds = self.view.bounds;
//    CGFloat topBarOffset = self.topLayoutGuide.length;
//    viewBounds.origin.y = topBarOffset * -1;
//    self.view.bounds = viewBounds;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isFirstLoad = YES;
    _selectDict = nil;

    self.view.backgroundColor = [UIColor whiteColor];
    _cityNameArray = [[NSMutableArray alloc] init];

    
    
    [self getPriceKal];
    
    
    
    
    

    
}




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    //[self changeMenu:NO];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[self changeMenu:YES];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];
}

#pragma mark - Net
/**
 *  获取价格日历接口
 */
- (void)getPriceKal
{
    ParametersManagerObject *pObject = [[ParametersManagerObject alloc] init];
    NSString *productId =[NSString stringWithFormat:@"id=%@",[productDict objectForKey:@"id"]] ;

    [pObject addParamer:productId];
    
    
    
    
    
    
    NSString* urlstr = [getProductPriceKalURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *loginUrl = [NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[pObject getHeetBody]];
    NSURLConnection *historyConn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if (historyConn) {
        _receivedData = [[NSMutableData alloc] initWithData:nil];
        [self showHub:@"商品获取中..."];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"警告"
                                                        message: @"不能连接到服务器,请检查您的网络"
                                                       delegate: nil
                                              cancelButtonTitle: @"确定"
                                              otherButtonTitles: nil];
        [alert show];
    }

    
    
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self hideHub];
    
    
    UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"连接服务器超时,请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alow show];
    
    
    
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    SBJsonParser *sbp = [[SBJsonParser alloc] init];
    
    NSDictionary *dict = [sbp objectWithData:_receivedData];
    
    NSString *resultCode = [dict objectForKey:@"result"];
    if ([resultCode isEqualToString:@"ok"]) {
        
        _dataDict = [[dict objectForKey:@"data"] objectForKey:@"goods"];
        _pre_days = [[[[dict objectForKey:@"data"] objectForKey:@"product"] objectForKey:@"pre_date"] integerValue];
        NSString *sign = [dict objectForKey:@"sign"];
        NSLog(@"%@",_dataDict);
        ParametersManagerObject *p = [[ParametersManagerObject alloc] init];
        BOOL isSign = [p checkSign:[dict objectForKey:@"data"] Sign:sign];
        
        if (isSign) {
            
            if (![_dataDict isKindOfClass:[NSArray class]]) {
                _dataDict = [NSArray array];
            }
            
            if ([_dataDict count] == 0) {
                
                 [self hideHub];
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"该商品已经售罄，有问题请拨打客服电话4000798790" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                al.tag = 8907;
                [al show];
                return;
            }
            
            [self initView];
            NSString *tit = [[self getCitysOrRoomsArray] safeFirstObject];
            NSArray *arr = [self getCityInfoWithName:tit];
            [self setSelectedDate:[self getFirstDateWithArray:arr]];
            
            
        }else{
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"警告" message:@"数据校验出错，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            
            
        }
        
        
        
    }else{
        
        NSDictionary *data_dict = [dict objectForKey:@"data"];
        NSString *errorMsg = [data_dict objectForKey:@"msg"];
        
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"警告" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        
    }
    
    
    [self hideHub];
    
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 8907) {
        [self changeMenu:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - Action


- (void)changeButtomInfo
{
    
    
    _roomtypeView.textField.text = @"无";
    _roomNumView.textField.text =@"0";
    _chengrenView.textField.text = @"1";
    _childView.textField.text = @"0";
    
    
    NSArray *array = [_selectDict objectForKey:@"good_price"];
    double single_room = [[_selectDict objectForKey:@"single_room"] doubleValue]; //单房差
    if (single_room>0.0) {
        if ([_chengrenView.textField.text isEqualToString:@"1"]) {
            _roomNumView.textField.text =@"1";
        }
        
    }else{
         _roomNumView.textField.text =@"0";
    }
    
    
    
    
    
    
    
    
    if ([array isKindOfClass:[NSArray class]]) {
        
        
        
        for (NSDictionary *obj in array) {
            
            NSString *typename = [obj objectForKey:@"typename"];
            long long pr = [[obj objectForKey:@"price"] longLongValue];
            
            if ([typename isEqualToString:@"成人"]) {
                _chengrenPrice.text = [NSString stringWithFormat:@"￥%lld/位",pr];
                
            }else if ([typename isEqualToString:@"儿童"]){
                
                _ertongPrice.text = [NSString stringWithFormat:@"￥%lld/位",pr];
            }
            
            
        }
        
        
        
        
        
    }

    
    int stock = [[_selectDict  objectForKey:@"stock"] integerValue];
    if (stock == 0) {
        
        _roomNumView.textField.text =@"0";
        _chengrenView.textField.text = @"0";
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提醒" message: @"该日期已售罄" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        
        
        
    }
    
    
    
    
}




- (void)clickShowView:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    if (btn.tag != 8000) {
        
        if (![[_selectDict allKeys] count]) {
            
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请您先选择日期再进行操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            return;
            
        }
        
    }
    
    
    
    
    int stock = [[_selectDict  objectForKey:@"stock"] integerValue];
    __block int chengrenNum = [_chengrenView.textField.text integerValue];
    __block int childNum = [_childView.textField.text integerValue];
    
    int room_people = [[_selectDict objectForKey:@"room_people"] integerValue];//每个房间入住人数（计算单房差使用）
    double single_room = [[_selectDict objectForKey:@"single_room"] doubleValue]; //单房差
    
    
    NSMutableArray *chengrenList = [[NSMutableArray alloc] init];
    NSMutableArray *childList = [[NSMutableArray alloc] init];
    
    int child_stock_status = 0;//是否扣库存（1 扣 0 不扣）
    int chengren_stock_status = 0; //是否扣库存（1 扣 0 不扣）
    double chengren_Price = 0.0;
    double child_Price = 0.0;
    
    NSArray *array = [_selectDict objectForKey:@"good_price"];
    if ([array isKindOfClass:[NSArray class]]) {
        
        
            
            for (NSDictionary *obj in array) {
                
                NSString *typename = [obj objectForKey:@"typename"];
                
                if ([typename isEqualToString:@"成人"]) {
                    chengren_stock_status = [[obj objectForKey:@"stock_status"] intValue];
                    chengren_Price = [[_selectDict objectForKey:@"price"] doubleValue];
                    
                }else if ([typename isEqualToString:@"儿童"]){
                    child_stock_status = [[obj objectForKey:@"stock_status"] intValue];
                    child_Price = [[_selectDict objectForKey:@"price"] doubleValue];
                    
                }
                
                
            }
            
        

        
        
    }
    
    
    
    
    if (btn.tag == 8000) {
        
        TextFieldAndSelectedView *selView = (TextFieldAndSelectedView *)[btn superview];
        UthingAlertView *alertView = selView.alertView;
        alertView.selections = [self getCitysOrRoomsArray];
        [alertView showFromView:self.view  animated:YES];
        
        alertView.selectedHandle = ^(NSInteger selectedIndex){
            
            NSString *titleName =[[self getCitysOrRoomsArray] objectAtIndex:selectedIndex];
            NSArray *cityInfoArray = [self getCityInfoWithName:titleName];
            //CGRectMake(self.view.width-80, 5, 80, 20)
            
            KalView *kal = [self calendarView];
            [kal.gridView currentMonthViewDate:cityInfoArray :_pre_days];
            
            
            
           TextFieldAndSelectedView* city = (TextFieldAndSelectedView *)[btn superview];
            if ([city isKindOfClass:[TextFieldAndSelectedView class]]) {
                float w = [QuickControl widthForString:titleName andHeigh:20 Font:[UIFont systemFontOfSize:12]];
                if (w>=80.0) {
                    city.frame =CGRectMake(self.view.width-w-20, 5, w+20, 20);
                }else{
                    city.frame =CGRectMake(self.view.width-80, 5, 80, 20);
                }
                city.button.frame = city.bounds;
                city.textField.frame = CGRectMake(0, 0, city.bounds.size.width-20, 20);
                UIButton *btn = (UIButton*)[city viewWithTag:9991];
                btn.frame = CGRectMake(city.bounds.size.width-20, 0, 20, 20);
                city.textField.text = titleName;
                _selectTitle = titleName;
                [self setSelectedDate:[self getFirstDateWithArray:cityInfoArray]];
            }
            
            
        };
        
        
    }else if (btn.tag == 9000){
    //成人
        if (child_stock_status) {//儿童算库存
            
            
            if (chengren_stock_status) {
                //成人算库存
                int surplus = stock -childNum;
                for (int i = 0; i<surplus; i++) {
                    [chengrenList addObject:[NSString stringWithFormat:@"%d",i+1]];
                }
                
                
            }else{
                //成人不算库存
                for (int i = 0; i<stock; i++) {
                    [chengrenList addObject:[NSString stringWithFormat:@"%d",i+1]];
                    if (i == 9) {
                        break;
                    }
                }
        
            
            }
            
            
            
        }else{
            
            for (int i = 0; i<stock; i++) {
                [chengrenList addObject:[NSString stringWithFormat:@"%d",i+1]];
                if (i == 9) {
                    break;
                }
            }
            
            
            
            
        }
        
        
        
        TextFieldAndSelectedView *selView = (TextFieldAndSelectedView *)[btn superview];
        UthingAlertView *alertView = selView.alertView;
        if ([chengrenList count]) {
            alertView.selections = chengrenList;
        }else{
            [chengrenList addObject:@"0"];
            alertView.selections = chengrenList;
        }

        [alertView showFromView:self.view  animated:YES];
        
        alertView.selectedHandle = ^(NSInteger selectedIndex){
            
            
            TextFieldAndSelectedView* city = (TextFieldAndSelectedView *)[btn superview];
            if ([city isKindOfClass:[TextFieldAndSelectedView class]]) {
                city.textField.text = [chengrenList objectAtIndex:selectedIndex] ;
                
                
               chengrenNum = [_chengrenView.textField.text integerValue];
                
                
                
                if (single_room>0) {
                    int all = chengrenNum+childNum;
                    int min = (all/room_people);
                    if (all%room_people != 0) {
                        min+=1;
                    }
//                    if (min == 0) {
//                        min = 1;
//                    }
                    _roomNumView.textField.text = [NSString stringWithFormat:@"%d",min];
                }
                
                
                
                
            }
            
            
        };
        
        
        
        
        
        
        
        
    }else if (btn.tag == 9001){
    //儿童
        
        
        if (chengren_stock_status) {//成人算库存
            
            
            if (child_stock_status) {
                //儿童算库存
                int surplus = stock -chengrenNum;
                for (int i = 0; i<=surplus; i++) {
                    [childList addObject:[NSString stringWithFormat:@"%d",i]];
                }
                
                
            }else{
                //儿童不算库存
                for (int i = 0; i<=stock; i++) {
                    [childList addObject:[NSString stringWithFormat:@"%d",i]];
                    if (i == 9) {
                        break;
                    }
                }
                
                
            }
            
            
            
        }else{
            
            for (int i = 0; i<=stock; i++) {
                [childList addObject:[NSString stringWithFormat:@"%d",i]];
                if (i == 9) {
                    break;
                }
            }
            
            
            
            
        }

        TextFieldAndSelectedView *selView = (TextFieldAndSelectedView *)[btn superview];
        UthingAlertView *alertView = selView.alertView;
        if ([childList count]) {
            alertView.selections = childList;
        }else{
            alertView.selections = [NSArray arrayWithObject:@"0"];
        }
        
        [alertView showFromView:self.view  animated:YES];
        
        alertView.selectedHandle = ^(NSInteger selectedIndex){
            
            
            
            TextFieldAndSelectedView* city = (TextFieldAndSelectedView *)[btn superview];
            if ([city isKindOfClass:[TextFieldAndSelectedView class]]) {
                
                city.textField.text = [childList objectAtIndex:selectedIndex] ;
                childNum = [_childView.textField.text integerValue];
                if (single_room>0) {
                    int all = chengrenNum+childNum;
                    int min = (all/room_people);
                    if (all%room_people != 0) {
                        min+=1;
                    }
                    _roomNumView.textField.text = [NSString stringWithFormat:@"%d",min];
                }
                
            }
            
            
        };
        
        
        
        
        
        
    }else if (btn.tag == 9003){
    //房间数
        
        TextFieldAndSelectedView *selView = (TextFieldAndSelectedView *)[btn superview];
        UthingAlertView *alertView = selView.alertView;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        int min,all;
        if (single_room>0) {
            all = chengrenNum+childNum;
            min = (all/room_people);
            if (all%room_people != 0) {
                min+=1;
            }
            for (int i = min; i<=all; i++) {
                [array addObject:[NSString stringWithFormat:@"%d",i]];
                if (i-min>10) {
                    break;
                }
            }
            
        }else{
            [array addObject:[NSString stringWithFormat:@"0"]];
        }
        
        
        
        
        alertView.selections = array;
        [alertView showFromView:self.view  animated:YES];
        
        alertView.selectedHandle = ^(NSInteger selectedIndex){
            
            
            TextFieldAndSelectedView* city = (TextFieldAndSelectedView *)[btn superview];
            if ([city isKindOfClass:[TextFieldAndSelectedView class]]) {
                city.textField.text = [array objectAtIndex:selectedIndex] ;
            }
            
            
        };
        
        
        
        
        
        
        
    }else if (btn.tag == 9004){
        //房型
        
        
        TextFieldAndSelectedView *selView = (TextFieldAndSelectedView *)[btn superview];
        UthingAlertView *alertView = selView.alertView;
        NSString *str = [_selectDict objectForKey:@"room_name"];
        NSArray *array;
        if ([str length]) {
             array= [NSArray arrayWithObjects:str, nil];
        }else{
            array= [NSArray arrayWithObjects:@"无", nil];
        }
        
        alertView.selections = array;
        
        [alertView showFromView:self.view  animated:YES];
        
        alertView.selectedHandle = ^(NSInteger selectedIndex){
            
            
            TextFieldAndSelectedView* city = (TextFieldAndSelectedView *)[btn superview];
            if ([city isKindOfClass:[TextFieldAndSelectedView class]]) {
                city.textField.text = [array objectAtIndex:selectedIndex] ;
            }
            
            
        };
        
        
        
        
    }
    

        
        
        
};


- (void)updateOrder
{
    
    if (![[_selectDict allKeys] count]) {
        
        UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请您选择出行日期后再选择提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alow show];
        return;
        
    }
    
    if ([_chengrenView.textField.text intValue]==0 ) {
        
        UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请您选择出行人数后再选择提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alow show];
        return;
        
    }
    
    
    MyOrderFillInViewController *myo = [[MyOrderFillInViewController alloc] init];
    myo.productDict = productDict;
    myo.gid = [[[_selectDict objectForKey:@"good_price"] firstObject] objectForKey:@"gid"];
    myo.roomNum =_roomNumView.textField.text ;
    myo.single_room_Price = [_selectDict objectForKey:@"single_room"];
    myo.tripTime = [_selectedDate stringWithFormat:@"yyyy-MM-dd" locale:LOCALE_CHINA];
    myo.childNum =_childView.textField.text;
    myo.adultNum =_chengrenView.textField.text;
    [self.navigationController pushViewController:myo animated:YES];

}

#pragma mark - DataFix

- (NSDate*)getFirstDateWithArray:(NSArray*)arr
{
    
    
    NSDate *aaa = [[NSDate date] dateByIgnoreOption:NSDateIgnoreHour|NSDateIgnoreMin|NSDateIgnoreSecond];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[aaa timeIntervalSince1970]];
    double num = _pre_days*24*60*60;
    double all =[timeSp longLongValue] +num;
    
    double dat =0;
    
    
    for (int i = 0;i<[arr count];i++) {
        NSDictionary *obj = [arr objectAtIndex:i];
        NSTimeInterval numDate =[[obj objectForKey:@"date"] doubleValue];
       
        if (numDate > all) {
            
            if (dat == 0) {
               dat= numDate;
             }else{
               
               if (numDate<dat) {
                   dat = numDate;
            }
                 
        }
            
            
        }
    }
    if (dat==0) {
        return [NSDate date];
    }
    

    NSDate *objDate = [NSDate dateWithTimeIntervalSince1970:dat];
    return objDate;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    long long dat =0;
//    
//    
//    for (int i = 0;i<[arr count];i++) {
//        NSDictionary *obj = [arr objectAtIndex:i];
//        NSTimeInterval numDate =[[obj objectForKey:@"date"] doubleValue];
//        if (numDate == 0) {
//            return [NSDate date];
//        }
//        NSDate *objDate = [NSDate dateWithTimeIntervalSince1970:numDate];
//        int dd = [objDate distanceInDaysToDate:[NSDate date]];
//        int abDays = abs(dd);
//        if (_pre_days<=abDays) {
//            
//            if (dat == 0) {
//                dat= [[obj objectForKey:@"date"] longLongValue];
//            }else{
//                
//                long long temp = [[obj objectForKey:@"date"] longLongValue];
//                if (temp<dat) {
//                    dat = temp;
//                }
//                
//            }
//            
//           
//        }
//
//    }
//    
//    NSTimeInterval numDate =[[NSString stringWithFormat:@"%lld",dat] doubleValue];
//    if (numDate == 0) {
//        return [NSDate date];
//    }
//    NSDate *objDate = [NSDate dateWithTimeIntervalSince1970:numDate];
//    return objDate;

    
    
    

    
}

- (NSDictionary*)getInfoWithDate:(NSDate*)date
{
    
    //
    for (NSDictionary *obj in _dataDict) {
        
        NSTimeInterval numDate =[[obj objectForKey:@"date"] doubleValue];
        NSDate *objDate = [NSDate dateWithTimeIntervalSince1970:numDate];
        
        BOOL isEq  = [objDate isEqualToDate:date ignore:NSDateIgnoreHour|NSDateIgnoreMin|NSDateIgnoreSecond];
        
        if (isEq) {
            
            NSString *title = [obj objectForKey:@"city_name"];
            NSString *room = [obj objectForKey:@"room_name"];
            if (![_selectTitle length]) {
                _selectTitle =[[self getCitysOrRoomsArray] safeFirstObject];
            }
            if ([room length]) {
                
                BOOL iseq = [room isEqualToString:_selectTitle];
                if (iseq) {
                    return obj;
                }
            }else{
                BOOL iseq = [title isEqualToString:_selectTitle];
                if (iseq) {
                    return obj;
                }
            }
            
            
            
            
        }
        
        
        
        
    
    
    
    }
    
    
    return nil;
    

}

/**
 *  选择的日期中，乘客是否包含儿童
 *
 *  @param dict
 *
 *  @return
 */




- (BOOL)isHaveChild:(NSDictionary*)dict
{
    NSArray *array = [dict objectForKey:@"good_price"];
    for (NSDictionary * obj in array) {
        NSString *typeName = [obj objectForKey:@"typename"];
        if ([typeName isEqualToString:@"儿童"]) {
            return YES;
        }
        
        
    }
    
    return NO;


}

/**
 *  获取 城市名或者 房型 数组
 *
 *  @return
 */

- (NSArray*)getCitysOrRoomsArray
{
    [_cityNameArray removeAllObjects];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSDictionary *obj in _dataDict) {
        NSString *cityName = [obj objectForKey:@"city_name"];
        NSString *roomName = [obj objectForKey:@"room_name"];
        if ([roomName length]) {
            [dict setObject:@"1" forKey:roomName];
        }else{
            [dict setObject:@"1" forKey:cityName];
        }
        
    }
    return [dict allKeys];

}
/**
 *  根据name 来获取 对应的数据
 *
 *  @param cName
 *
 *  @return
 */

- (NSArray*)getCityInfoWithName:(NSString*)cName
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in _dataDict) {
        
        NSString *cityName = [obj objectForKey:@"city_name"];
        NSString *roomName = [obj objectForKey:@"room_name"];
        
        if ([cName isEqualToString:roomName]) {
            [array addObject:obj];
            
        }else{
            
            if ([cName isEqualToString:cityName]) {
                [array addObject:obj];
            }
            
        }
        
        
    }

    return array;
}



#pragma mark - View

/**
 *  初始化界面全部ui
 */
- (void)initView
{
    
    _bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-35)];
    _bgView.contentSize = CGSizeMake(self.view.width, self.view.height+50);
    [_bgView setPagingEnabled:NO];
    [_bgView setShowsVerticalScrollIndicator:NO];
    [_bgView setShowsHorizontalScrollIndicator:NO];
    _bgView.bounces = NO;
    [self.view addSubview:_bgView];
    
    
    
    
    
    _ButtomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-200, self.view.width, 120)];
    
    
    CGRect rr =[[UIScreen mainScreen] applicationFrame];
    KalView *kalView = [[KalView alloc] initWithFrame:CGRectMake(0, 30, rr.size.width, rr.size.height-30) delegate:self logic:logic];
    kalView.gridView.selectionMode = self.selectionMode;
    kalView.tag = 28881;
    
    [_bgView addSubview:kalView];
    
    
    
    
    
    
    [self initTopView];
    [self initButtomView];
    [self initBelowBar];
}





- (void)initTopView
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    _topView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    titleLabel.text = @"出行城市";
    titleLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    [_topView addSubview:titleLabel];
    NSDictionary *obj = nil;
    if ([_dataDict count]) {
         obj=  [_dataDict firstObject];
    }
    
    NSString *roomName = [obj objectForKey:@"room_name"];
    
    if ([roomName length]) {
        titleLabel.text = @"选择房型";
    }else{
        titleLabel.text = @"出行城市";
    }

    
    TextFieldAndSelectedView * selCity = [[TextFieldAndSelectedView alloc] initWithFrame:CGRectMake(self.view.width-80, 5, 80, 20)];
    selCity.button.tag =8000;
    selCity.textField.layer.borderColor = RGBCOLOR(241, 241, 241).CGColor;
    selCity.textField.layer.borderWidth = 1.0f;
    selCity.textField.backgroundColor = [UIColor whiteColor];
    
    [selCity.button addTarget:self action:@selector(clickShowView:) forControlEvents:UIControlEventTouchUpInside];
    NSString *titleName = @"无";
    NSArray *array = [self getCitysOrRoomsArray];
    if ([array count]) {
       titleName=[array objectAtIndex:0];
    }
    
    
    NSArray *cityInfoArray = [self getCityInfoWithName:titleName];
    
    if ([cityInfoArray count]) {
        
        KalView *kal = [self calendarView];
        [kal.gridView currentMonthViewDate:cityInfoArray :_pre_days];
        selCity.textField.text =titleName;
        _selectTitle = titleName;
        
        float w = [QuickControl widthForString:titleName andHeigh:20 Font:[UIFont systemFontOfSize:12]];
        if (w>=80.0) {
            selCity.frame =CGRectMake(_topView.width-w-20, 5, w+20, 20);
        }else{
            selCity.frame =CGRectMake(_topView.width-80-20, 5, 80+20, 20);
        }
        selCity.button.frame = selCity.bounds;
        selCity.textField.frame = CGRectMake(0, 0, selCity.bounds.size.width-20, 20);
        UIButton *btn = (UIButton*)[selCity viewWithTag:9991];
        btn.frame = CGRectMake(selCity.bounds.size.width-20, 0, 20, 20);
        
        
    }
    [_topView addSubview:selCity];
    
    
}

- (void)initButtomView
{
    
   
    
        
        _ButtomView.backgroundColor = RGBCOLOR(230, 230, 230);
        _ButtomView.alpha = 0.9;
        [_bgView addSubview:_ButtomView];
        
        
        
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5,18 , 18)];
        icon.image = [UIImage imageNamed:@"app-选择出行_pop"];
        [_ButtomView addSubview:icon];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 200, 20)];
        titleLabel.text = @"旅行人数和其他";
        titleLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.backgroundColor = [UIColor clearColor];
        [_ButtomView addSubview:titleLabel];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 28, self.view.bounds.size.width, 0.5)];
        line.backgroundColor = [UIColor darkGrayColor];
        [_ButtomView addSubview:line];
        
        //---------------成人
        
        UILabel *chengren = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 25, 20)];
        chengren.text = @"成人";
        chengren.textAlignment = NSTextAlignmentRight;
        chengren.backgroundColor = [UIColor clearColor];
        chengren.font = [UIFont systemFontOfSize:10];
        chengren.textColor = [UIColor colorFromHexRGB:@"666666"];
        [_ButtomView addSubview:chengren];
    
        _chengrenView = [[TextFieldAndSelectedView alloc] initWithFrame:CGRectMake(30, 40, 70, 20)];
        _chengrenView.textField.text = @"1";
        _chengrenView.textField.layer.borderColor = [UIColor whiteColor].CGColor;
        _chengrenView.textField.backgroundColor = [UIColor whiteColor];
        _chengrenView.button.tag = 9000;
        [_chengrenView.button addTarget:self action:@selector(clickShowView:) forControlEvents:UIControlEventTouchUpInside];
    
        [_ButtomView addSubview:_chengrenView];
        
        _chengrenPrice = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 60, 20)];
        _chengrenPrice.text = @"";
        _chengrenPrice.textAlignment = NSTextAlignmentRight;
        _chengrenPrice.backgroundColor = [UIColor clearColor];
        _chengrenPrice.font = [UIFont systemFontOfSize:11];
        _chengrenPrice.textColor = [UIColor colorFromHexRGB:@"ff9900"];
        [_ButtomView addSubview:_chengrenPrice];
        
        
        //---------------儿童
        float x = self.view.width;
        _ertong = [[UILabel alloc] initWithFrame:CGRectMake(x-160, 40, 25, 20)];
        _ertong.text = @"儿童";
        _ertong.textAlignment = NSTextAlignmentRight;
        _ertong.backgroundColor = [UIColor clearColor];
        _ertong.font = [UIFont systemFontOfSize:10];
        _ertong.textColor = [UIColor colorFromHexRGB:@"666666"];
        [_ButtomView addSubview:_ertong];
    
    
    
        _childView = [[TextFieldAndSelectedView alloc] initWithFrame:CGRectMake(x-130, 40, 70, 20)];
        _childView.textField.text = @"0";
        _childView.button.tag = 9001;
    _childView.textField.layer.borderColor = [UIColor whiteColor].CGColor;
    _childView.textField.backgroundColor = [UIColor whiteColor];
        [_childView.button addTarget:self action:@selector(clickShowView:) forControlEvents:UIControlEventTouchUpInside];
    
        [_ButtomView addSubview:_childView];
        
        _ertongPrice = [[UILabel alloc] initWithFrame:CGRectMake(x-60, 40, 60, 20)];
        _ertongPrice.text = @"";
        _ertongPrice.textAlignment = NSTextAlignmentRight;
        _ertongPrice.backgroundColor = [UIColor clearColor];
        _ertongPrice.font = [UIFont systemFontOfSize:11];
        _ertongPrice.textColor = [UIColor colorFromHexRGB:@"ff9900"];
        [_ButtomView addSubview:_ertongPrice];
        
        
        
        //---------------房间数
        
        
        UILabel *fangjianshu = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 30, 20)];
        fangjianshu.text = @"房间数";
        fangjianshu.textAlignment = NSTextAlignmentRight;
        fangjianshu.backgroundColor = [UIColor clearColor];
        fangjianshu.font = [UIFont systemFontOfSize:10];
        fangjianshu.textColor = [UIColor colorFromHexRGB:@"666666"];
        [_ButtomView addSubview:fangjianshu];
    
    
        _roomNumView = [[TextFieldAndSelectedView alloc] initWithFrame:CGRectMake(30, 70, 70, 20)];
        _roomNumView.textField.text = @"0";
        _roomNumView.button.tag = 9003;
        _roomNumView.textField.layer.borderColor = [UIColor whiteColor].CGColor;
        _roomNumView.textField.backgroundColor = [UIColor whiteColor];
        [_roomNumView.button addTarget:self action:@selector(clickShowView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
        [_ButtomView addSubview:_roomNumView];
        
//        UILabel *fangjianshuPrice = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 60, 20)];
//        fangjianshuPrice.text = @"29999.0/位";
//        fangjianshuPrice.textAlignment = NSTextAlignmentRight;
//        fangjianshuPrice.backgroundColor = [UIColor clearColor];
//        fangjianshuPrice.font = [UIFont systemFontOfSize:11];
//        fangjianshuPrice.textColor = [UIColor colorFromHexRGB:@"ff9900"];
//        [_ButtomView addSubview:fangjianshuPrice];
    
        
        
        
        //---------------房型
    
//        NSDictionary *obj =  [_dataDict firstObject];
//        NSString *roomName = [obj objectForKey:@"room_name"];
//    
//        if ([roomName length]) {
//            return;
//        }
//        
//        
//        UILabel *fangxing = [[UILabel alloc] initWithFrame:CGRectMake(x-160, 70, 25, 20)];
//        fangxing.text = @"房型";
//        fangxing.textAlignment = NSTextAlignmentRight;
//        fangxing.backgroundColor = [UIColor clearColor];
//        fangxing.font = [UIFont systemFontOfSize:10];
//        fangxing.textColor = [UIColor colorFromHexRGB:@"666666"];
//        //[_ButtomView addSubview:fangxing];
//    
//        _roomtypeView = [[TextFieldAndSelectedView alloc] initWithFrame:CGRectMake(x-130, 70, 70, 20)];
//        _roomtypeView.textField.text = @"无";
//        _roomtypeView.button.tag = 9004;
//        _roomtypeView.textField.layer.borderColor = [UIColor whiteColor].CGColor;
//        _roomtypeView.textField.backgroundColor = [UIColor whiteColor];
//        [_roomtypeView.button addTarget:self action:@selector(clickShowView:) forControlEvents:UIControlEventTouchUpInside];
    

        //[_ButtomView addSubview:_roomtypeView];
        
//        UILabel *fangxingPrice = [[UILabel alloc] initWithFrame:CGRectMake(260, 70, 60, 20)];
//        fangxingPrice.text = @"29999.0/位";
//        fangxingPrice.textAlignment = NSTextAlignmentRight;
//        fangxingPrice.backgroundColor = [UIColor clearColor];
//        fangxingPrice.font = [UIFont systemFontOfSize:11];
//        fangxingPrice.textColor = [UIColor colorFromHexRGB:@"ff9900"];
//        [_ButtomView addSubview:fangxingPrice];

 

}



- (void)initBelowBar
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 237/255.0, 237/255.0, 237/255.0, 1 });
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-35, self.view.bounds.size.width, 35)];
    bg.backgroundColor = [UIColor clearColor];
    [bg.layer setBorderColor:colorref];
    [self.view addSubview:bg];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, (30-20)/2, 20, 20)];
    icon.image = [UIImage imageNamed:@"app-详情页_41"];
    [bg addSubview:icon];
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(5, (30-20)/2, 20, 20)];
    [control addTarget:self action:@selector(telAction) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:control];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 0.5, 30)];
    line.backgroundColor = RGBCOLOR(236, 236, 236);
    [bg addSubview:line];
    
    UILabel *tijiaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-90, 2, 90, 30)];
    tijiaoLabel.text =@"提交";
    tijiaoLabel.textAlignment = NSTextAlignmentCenter;
    tijiaoLabel.font = [UIFont systemFontOfSize:14];
    tijiaoLabel.textColor = [UIColor whiteColor];
    tijiaoLabel.backgroundColor = RGBCOLOR(248, 154, 6);
    [bg addSubview:tijiaoLabel];
    UIControl *yudingBtn = [[UIControl alloc] initWithFrame:CGRectMake(self.view.width-90, 0, 90, 30)];
    [yudingBtn addTarget:self action:@selector(updateOrder) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:yudingBtn];
    
    //NSString *priceStr = [productDict objectForKey:@"low_price"];
    //float w = [QuickControl widthForString:priceStr andHeigh:30 Font:[UIFont systemFontOfSize:17]];
    
    //价格
    UILabel *low_price = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-100, 0, 100, 30)];
    low_price.textColor = [UIColor colorFromHexRGB:@"ff9900"];
    low_price.font = [UIFont systemFontOfSize:17];
    low_price.textAlignment = NSTextAlignmentRight;
    low_price.backgroundColor = [UIColor clearColor];
    low_price.text = [NSString stringWithFormat:@"￥%@",[productDict objectForKey:@"low_price"]];
    //[bg addSubview:low_price];
    
    
    
    
    
}




- (void)changeButtom:(float)y
{
    
    
    
    if (_ButtomView != nil) {
        NSLog(@"y = %f",y);
        _ButtomView.frame =CGRectMake(0, y+30, self.view.bounds.size.width,120);
        
        
        
    }
    

}




@end
