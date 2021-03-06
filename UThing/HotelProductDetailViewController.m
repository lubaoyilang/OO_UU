//
//  HotelProductDetailViewController.m
//  UThing
//
//  Created by luyuda on 14/12/23.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "HotelProductDetailViewController.h"
#import "hotel_AutoImageTextTableViewCell.h"
#import "ProductDetailCell.h"
#import "HotelDetailTableViewCell.h"
#import "HotelAnyImagesTableViewCell.h"
#import "Flight_infoTableViewCell.h"
#import "TextFieldAndSelectedView.h"
#import "Hotel_UserListenTableViewCell.h"
#import "ReserveViewController.h"
#import "DepositPayViewController.h"
#import "UthingAlertView.h"

#define titImageW 211
#define puImageW 190
#define HeadH   40
#define titHeadH    30

@interface HotelProductDetailViewController ()<clickPro>


@property (nonatomic,strong)NSMutableData *productDetailData;
@property (nonatomic,strong)id  hotelList;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,assign)BOOL isShowUserListen;
@property (nonatomic,strong)NSMutableArray *sectionArray;
@property (nonatomic,strong)NSString *flightName;
@property (nonatomic,strong)NSMutableArray   *packageDict;
@property (nonatomic,strong)TextFieldAndSelectedView *arriveView;
@property (nonatomic,strong)UILabel *low_price;

@end

@implementation HotelProductDetailViewController
@synthesize ProductId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _packageDict = [[NSMutableArray alloc] init];
    _isShow = NO;
    _isShowUserListen = NO;
    self.title = @"产品详情";
    _sectionArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSize:) name:@"changesize" object:nil];
    [self getProductDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString*)getProductTitle
{
    NSString* obj = [_hotelList objectForKey:@"title"];
    return obj;
}


#pragma mark - Action

- (void)changeSize:(NSNotification*)fi
{
    NSString *obj = [fi object];
    
    if ([obj isEqualToString:@"2"]) {
        _isShowUserListen = YES;
        [_tableview reloadData];
        
    }else{
        _isShow = YES;
        [_tableview reloadData];
    }
    
    
    
    
    
}

- (void)paymoney
{
     if ([LoginStatusObject isLoginStatus]) {
         DepositPayViewController *de = [[DepositPayViewController alloc] init];
         de.obj =_hotelList;
         de.priceNum =_low_price.text;
         [self.navigationController pushViewController:de animated:YES];
     }
    
}
- (void)clickShowView:(id)sender
{
    
    UthingAlertView *alertView = [(TextFieldAndSelectedView *)[sender superview] alertView];
    __block NSArray *array = [self getFlightNames];
    alertView.selections = array;
    [alertView showFromView:self.view  animated:YES];
    
    alertView.selectedHandle = ^(NSInteger selectedIndex){
        
        NSString *name = [array safeObjectIndex:selectedIndex];
        _flightName = name;
        _arriveView.textField.text = name;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadflight" object:[self getFlightWithName:name]];
        //[_tableview reloadData];
        
        NSString *pric = [NSString moneyFromThousand:[[self getFlightWithName:name] objectForKey:@"price"]];
        
        
        NSString *priceStr = [NSString stringWithFormat:@"￥%@/人起",pric];
        float w = [QuickControl widthForString:priceStr andHeigh:30 Font:[UIFont systemFontOfSize:17]];
        
        _low_price.frame = CGRectMake(self.view.width-100-w, 0, w, 30);
        _low_price.text = priceStr;

        
    };
    
    
}


/**
 *  预定咨询界面
 *
 *  @param obj 套餐数据
 */
- (void)callBackObj:(id)obj
{
    if ([LoginStatusObject isLoginStatus]) {
        ReserveViewController *rvc = [[ReserveViewController alloc] init];
        rvc.proInfo = obj;
        rvc.proID =ProductId;
    [self.navigationController pushViewController:rvc animated:YES];
    }
}


#pragma mark - Net

- (void)getProductDetail
{
    
    ParametersManagerObject *pObject = [[ParametersManagerObject alloc] init];
    
    
    
    NSString *uid =[NSString stringWithFormat:@"id=%@",ProductId] ; //key = password
    
    
    [pObject addParamer:uid];
    
    
    NSString* urlstr = [getHotelDetailURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *loginUrl = [NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[pObject getHeetBody]];
    
    NSLog(@"pars = %@",[pObject getParamersWithSign]);
    NSURLConnection *historyConn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if (historyConn) {
        _productDetailData = [[NSMutableData alloc] initWithData:nil];
        
        [self showHub:@"产品详情加载中"];
        
        
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
    [_productDetailData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    [self hideHub];
    
    UIAlertView *alow = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"连接服务器超时,请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alow show];
    
    
    
}



-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    
    SBJsonParser *sbp = [[SBJsonParser alloc] init];
    
    NSDictionary *dict = [sbp objectWithData:_productDetailData];
    NSLog(@"dict = %@",dict);
    NSString *resultCode = [dict objectForKey:@"result"];
    
    if ([resultCode isEqualToString:@"ok"]) {
        
        _hotelList = [dict objectForKey:@"data"];
        NSString *sign = [dict objectForKey:@"sign"];
        ParametersManagerObject *p = [[ParametersManagerObject alloc] init];
        BOOL isSign = [p checkSign:_hotelList Sign:sign];
        
        if (isSign) {
            [self handleSections];
            
            [self initView];
            
        }else{
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"警告" message:@"数据校验出错，请重新请求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            _hotelList = nil;
            
            
        }
        
        
        
    }else{
        NSDictionary *data_dict = [dict objectForKey:@"data"];
        NSString *errorMsg = [data_dict objectForKey:@"msg"];
        
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"警告" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        
        
    }
    
    
    
    [self hideHub];
    
    
    
    
    
    
    
}

#pragma mark - Data Fix


- (NSDictionary*)getPakageNameWithInfo:(NSString*)name list:(NSArray*)arr
{
    
    for (int i = 0; i<[arr count]; i++) {
        
        NSDictionary *dic = [arr safeObjectIndex:i];
        NSString *na = [dic objectForKey:@"name"];
        if ([na isEqualToString:name]) {
            return dic;
        }
        
    }
    
    
    return nil;
//    NSDictionary *dict = [arr safeObjectIndex:indexPath.row-1];
    
    
}

- (NSArray*)getShowHttel_Package
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i=0;i<[_packageDict  count]; i++) {
        
        
        BOOL isok = [[[_packageDict safeObjectIndex:i] objectForKey:@"isshow"] boolValue];
        
        if (isok) {
            [array addObject:[_packageDict safeObjectIndex:i]];
        }
        
    }
    return array;
    
    
}

- (NSDictionary*)getFlightWithName:(NSString*)name
{
    NSArray *flight_info = [_hotelList objectForKey:@"flight_info"];
    for (int i = 0; i<[flight_info count]; i++) {
        NSString *fname = [[flight_info objectAtIndex:i] objectForKey:@"dep_city_name"];
        if ([fname isEqualToString:name]) {
            return [flight_info objectAtIndex:i];
        }
    }
    
    
    return nil;
    
}
- (NSArray*)getFlightNames
{
    NSArray *flight_info = [_hotelList objectForKey:@"flight_info"];
    NSMutableDictionary *arr = [[NSMutableDictionary alloc] init];
    for (int i = 0; i<[flight_info count]; i++) {
        NSString *name = [[flight_info objectAtIndex:i] objectForKey:@"dep_city_name"];
        [arr setObject:@"1" forKey:name];
    }
    
    return [arr allKeys];
    
}

- (void)handleSections
{
    
    
    if ([_sectionArray count]) {
        return ;
    }
    [_sectionArray removeAllObjects];
    
    
    
    NSString *title = [_hotelList objectForKey:@"title"];
    if ([title length]) {
        NSArray *arr = [[NSArray alloc] initWithObjects:@"title",title,@"", nil];
        [_sectionArray addObject:arr];
    }
    
    
    
    NSArray *recommend = [_hotelList objectForKey:@"selection_reason"];
    if ([recommend count]) {
        NSArray *arr = [[NSArray alloc] initWithObjects:@"selection_reason",@"甄选理由",@"app-详情页_07", nil];
        [_sectionArray addObject:arr];
    }

    // key   title   price  state
    NSArray *hotel_package = [_hotelList objectForKey:@"hotel_package"]; //酒店套餐
    if ([hotel_package isKindOfClass:[NSArray class]]) {
        if ([hotel_package count]) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"hotel_package",hotel_package,[NSNumber numberWithBool:NO],@"", nil];
            [_sectionArray addObject:arr];
            
            
            for (int i = 0; i<[hotel_package count]; i++) {
                //就按照 一个 cell 一个 object 来 生成  。。。。只判断 是否显示  然后根据 是不是title 来判断 用哪种类型cell 来展示
                
                NSMutableDictionary *titD = [[NSMutableDictionary alloc] init];
                [titD setObject:[NSNumber numberWithBool:YES] forKey:@"isTitle"];
                [titD setObject:[[hotel_package safeObjectIndex:i] objectForKey:@"name"] forKey:@"name"];
                [titD setObject:[NSNumber numberWithBool:YES] forKey:@"isshow"];
                
                [_packageDict addObject:titD];
                
                
                
                NSMutableDictionary *titDD = [[NSMutableDictionary alloc] init];
                [titDD setObject:[NSNumber numberWithBool:NO] forKey:@"isTitle"];
                [titDD setObject:[[hotel_package safeObjectIndex:i] objectForKey:@"name"] forKey:@"name"];
                
                if (i==0) {
                    [titDD setObject:[NSNumber numberWithBool:YES] forKey:@"isshow"];
                }else{
                    [titDD setObject:[NSNumber numberWithBool:NO] forKey:@"isshow"];
                }
                
                
                [_packageDict addObject:titDD];
                
                
            }
            
        }

    }
    
    
    NSArray *fee_include = [_hotelList objectForKey:@"hotel_info"];
    for (int i = 0; i<[fee_include count]; i++) {
        NSArray *arr = [[NSArray alloc] initWithObjects:@"hotel_info",[fee_include safeObjectIndex:i],@"app-详情页_07", nil];
        [_sectionArray addObject:arr];
    }
    
    
    
    
    
    
    id flight = [_hotelList objectForKey:@"flight_info"];
    if ([flight isKindOfClass:[NSArray class]]) {
        
        NSArray *arr = [[NSArray alloc] initWithObjects:@"flight_info",@"参考航班",@"app-详情页_10", nil];
        [_sectionArray addObject:arr];
        
    }
    
    
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"user_listen",@"用户须知",@"app-详情页_10", nil];
    [_sectionArray addObject:arr];
    
    //[self fixContentArray];
    
   
    
    
    
}


- (int)getNumCellForSection:(int)sec
{
    
    id obj = [_sectionArray safeObjectIndex:sec];
    NSString *key = [obj safeFirstObject];
    
    
    
    if ([key isEqualToString:@"hotel_info"]) {
        return 1;
    }else if ([key isEqualToString:@"hotel_package"]){
        
        
        int contNum = 0;
        
        for (int i=0;i<[_packageDict  count]; i++) {
           
            
            BOOL isok = [[[_packageDict safeObjectIndex:i] objectForKey:@"isshow"] boolValue];
            
            if (isok) {
                contNum++;
            }
            
        }

        return contNum;
        
        
    }else if ([key isEqualToString:@"flight_info"]){
        return 1;
    }
    
    NSArray* array =  [_hotelList objectForKey:key];
    
    if ([array isKindOfClass:[NSArray class]]) {
        NSLog(@"key = %@ count = %d",key,[array count]);
        return [array count];
    }else{
        return 1;
    }
    
    
    
}

- (float)getHotel_infoHeight:(id)obj
{
    
    
    float offH = 10;
    
    id hotel_introduction = [obj objectForKey:@"summary"];
    NSMutableString *allIntroduction  = [NSMutableString stringWithString:@""];
    if ([hotel_introduction isKindOfClass:[NSArray class]]) {
        for (int i = 0; i<[hotel_introduction count]; i++) {
            if ([allIntroduction length]) {
                allIntroduction = [NSMutableString stringWithFormat:@"%@\n%@",allIntroduction,[hotel_introduction safeObjectIndex:i]];
            }else if([hotel_introduction isKindOfClass:[NSNull class]]){
                allIntroduction = [NSMutableString stringWithFormat:@"%@",@""];
            }else{
                allIntroduction = [NSMutableString stringWithFormat:@"%@",[hotel_introduction safeObjectIndex:i]];
            }
            
        }
        
    }else{
        allIntroduction = [NSMutableString stringWithFormat:@"%@",hotel_introduction];
    }
    
    float introductionH  = 0.0;
    
    if ([allIntroduction length]) {
        
        
        NSLog(@"allIntroduction=%@",allIntroduction);
        
        
        introductionH = [QuickControl heightForString:allIntroduction andWidth:[UIScreen mainScreen].bounds.size.width-20 Font:[UIFont systemFontOfSize:15]];
        offH +=introductionH;
    }
    
    
    
    
    NSString *coverUrl = [obj objectForKey:@"img_url"];
    if ([coverUrl isValidUrl]) {
        offH+=207;
    }
    
    
    
    NSArray *roomArray = [obj objectForKey:@"hotel_room"];
    
    for (int i = 0; i<[roomArray count]; i++) {
        
        NSString *url = [[roomArray objectAtIndex:i] objectForKey:@"img_url"];
        NSString *name =[[roomArray objectAtIndex:i] objectForKey:@"name"];
        id arr = [[roomArray objectAtIndex:i] objectForKey:@"detail"];
        NSMutableString *temp  = [NSMutableString stringWithString:@""];
        if ([arr isKindOfClass:[NSArray class]]) {
            for (int j = 0; j<[arr count]; j++) {
                if ([temp length]) {
                    temp = [NSMutableString stringWithFormat:@"%@\n%@",temp,[arr safeObjectIndex:j]];
                }else{
                    temp = [NSMutableString stringWithFormat:@"%@",[arr safeObjectIndex:j]];
                }
                
            }
        }else{
            temp = [NSMutableString stringWithFormat:@"%@",arr];
        }
        
        
        
        
        offH+=20.0;
        if ([url isValidUrl]) {
            
            offH+=207;
        }
        
        NSLog(@"temp = %@",temp);
        
        if ([temp length]) {
            float strH =[QuickControl heightForString:temp andWidth:[UIScreen mainScreen].bounds.size.width-20 Font:[UIFont systemFontOfSize:15]];
            offH +=strH;
        }
        
        
        
        
    }

    return offH;

    
    
    
}


#pragma mark - View

- (void)initView
{
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-30) style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    [_tableview setSeparatorColor:[UIColor clearColor]];
    _tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableview];
    [self initBar];
    
}

- (void)initBar
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 237/255.0, 237/255.0, 237/255.0, 1 });
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-self.topLayoutGuide.length-30, self.view.width, 30)];
    bg.backgroundColor = [UIColor whiteColor];
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
    
    
    UIImageView *yuding = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width-90, 0, 90, 30)];
    yuding.image = [UIImage imageNamed:@"app-详情页_40"];
    [bg addSubview:yuding];
    //reserve
    UIControl *yudingBtn = [[UIControl alloc] initWithFrame:CGRectMake(self.view.width-90, 0, 90, 30)];
    [yudingBtn addTarget:self action:@selector(paymoney) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:yudingBtn];
    
    NSString *pric = [NSString moneyFromThousand:[_hotelList objectForKey:@"low_price"]];
    
    //
    NSString *priceStr = [NSString stringWithFormat:@"￥%@/人起",pric];
    float w = [QuickControl widthForString:priceStr andHeigh:30 Font:[UIFont systemFontOfSize:17]];
    
    
    _low_price = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-100-w, 0, w, 30)];
    _low_price.textColor = [UIColor colorFromHexRGB:@"ff9900"];
    _low_price.font = [UIFont systemFontOfSize:17];
    _low_price.textAlignment = NSTextAlignmentRight;
    _low_price.backgroundColor = [UIColor clearColor];
    _low_price.text = priceStr;
    [bg addSubview:_low_price];

    
    
    
}

- (void)changeSize
{
    _isShow = YES;
    [_tableview reloadData];
    
    
}
- (void) viewDidLayoutSubviews {
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    viewBounds.origin.y = topBarOffset * -1;
    self.view.bounds = viewBounds;
}



#pragma mark - tableview Delegate


//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_sectionArray count];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    bg.backgroundColor = [UIColor whiteColor];
    
    
    
    NSArray *arr = [_sectionArray safeObjectIndex:section];
    id key =[arr safeFirstObject];
    id tit = [arr safeObjectIndex:1];
    id img = [arr safeLastObject];
    
    
    if ([key isEqualToString:@"title"]) {
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 20)];
        [labelTitle setBackgroundColor:[UIColor colorFromHexRGB:@"ffffff"]];
        labelTitle.font = [UIFont systemFontOfSize:15];
        labelTitle.textColor = [UIColor colorFromHexRGB:@"333333"];
        labelTitle.text = [NSString stringWithFormat:@"  %@",tit];
        [bg addSubview:labelTitle];
        
    }else if ([key isEqualToString:@"hotel_package"]){
        bg.frame = CGRectMake(0, 0, self.view.width, 5);
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 5)];
        topLine.backgroundColor = RGBCOLOR(245, 245, 245);
        [bg addSubview:topLine];
        
        

        
        
    }else if ([key isEqualToString:@"flight_info"]){
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 5)];
        topLine.backgroundColor = RGBCOLOR(245, 245, 245);
        [bg addSubview:topLine];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5+(HeadH-5-18)/2, 18, 18)];
        icon.image = [UIImage imageNamed:img];
        [bg addSubview:icon];
        
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, self.view.frame.size.width-200, 35)];
        [labelTitle setBackgroundColor:[UIColor colorFromHexRGB:@"ffffff"]];
        labelTitle.font = [UIFont systemFontOfSize:15];
        labelTitle.textColor = [UIColor colorFromHexRGB:@"333333"];
        labelTitle.text = [NSString stringWithFormat:@"  %@",tit];
        [bg addSubview:labelTitle];
        
        
        UILabel *ArriveLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-200, 7, 95, 35)];
        [ArriveLabel setBackgroundColor:[UIColor colorFromHexRGB:@"ffffff"]];
        ArriveLabel.font = [UIFont systemFontOfSize:14];
        ArriveLabel.textAlignment = NSTextAlignmentRight;
        ArriveLabel.text = @"出发地:";
        [bg addSubview:ArriveLabel];
        
        _arriveView = [[TextFieldAndSelectedView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, 15, 100, 35)];
        if ([_flightName length]) {
            _arriveView.textField.text =_flightName;
        }else{
            
            _arriveView.textField.text =[[self getFlightNames] safeFirstObject];;
        }
        //_arriveView.textField.text =[[self getFlightNames] safeFirstObject];;
        _flightName =_arriveView.textField.text;
        _arriveView.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _arriveView.textField.backgroundColor = [UIColor whiteColor];
        _arriveView.button.tag = 9000;
        [_arriveView.button addTarget:self action:@selector(clickShowView:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:_arriveView];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, HeadH-1, self.view.width, 0.5)];
        line.backgroundColor = RGBCOLOR(169, 169, 169);
        [bg addSubview:line];
        
        
        
    }else if ([key isEqualToString:@"hotel_info"]){

        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 5)];
        topLine.backgroundColor = RGBCOLOR(245, 245, 245);
        [bg addSubview:topLine];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5+(HeadH-5-18)/2, 18, 18)];
        icon.image = [UIImage imageNamed:img];
        [bg addSubview:icon];
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, (HeadH-5-15+6)/2, self.view.frame.size.width, 20)];
        [labelTitle setBackgroundColor:[UIColor colorFromHexRGB:@"ffffff"]];
        labelTitle.font = [UIFont systemFontOfSize:14];
        labelTitle.textColor = [UIColor colorFromHexRGB:@"333333"];
        [bg addSubview:labelTitle];
        labelTitle.text = [tit objectForKey:@"name"];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, HeadH-1, self.view.width, 0.5)];
        line.backgroundColor = RGBCOLOR(169, 169, 169);
        [bg addSubview:line];
        
        
        
        
        
        
        
        
        
        
        
    }else if ([key isEqualToString:@"user_listen"]){
        
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 5)];
        topLine.backgroundColor = RGBCOLOR(245, 245, 245);
        [bg addSubview:topLine];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5+(HeadH-5-18)/2, 18, 18)];
        icon.image = [UIImage imageNamed:img];
        [bg addSubview:icon];
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, (HeadH-5-15+6)/2, self.view.frame.size.width, 20)];
        [labelTitle setBackgroundColor:[UIColor colorFromHexRGB:@"ffffff"]];
        labelTitle.font = [UIFont systemFontOfSize:14];
        labelTitle.textColor = [UIColor colorFromHexRGB:@"333333"];
        [bg addSubview:labelTitle];
        labelTitle.text = tit;
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, HeadH-1, self.view.width, 0.5)];
        line.backgroundColor = RGBCOLOR(169, 169, 169);
        [bg addSubview:line];
        
        

        
        
    }else if ([key isEqualToString:@"selection_reason"]){
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 5)];
        topLine.backgroundColor = RGBCOLOR(245, 245, 245);
        [bg addSubview:topLine];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5+(HeadH-5-18)/2, 18, 18)];
        icon.image = [UIImage imageNamed:img];
        [bg addSubview:icon];
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, (HeadH-5-15+6)/2, self.view.frame.size.width, 20)];
        [labelTitle setBackgroundColor:[UIColor colorFromHexRGB:@"ffffff"]];
        labelTitle.font = [UIFont systemFontOfSize:14];
        labelTitle.textColor = [UIColor colorFromHexRGB:@"333333"];
        [bg addSubview:labelTitle];
        labelTitle.text = tit;
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, HeadH-1, self.view.width, 0.5)];
        line.backgroundColor = RGBCOLOR(169, 169, 169);
        [bg addSubview:line];

        
    }
    

    
    
    
    
    return bg;
}





// 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSArray *secArray = [_sectionArray objectAtIndex:indexPath.section];
    NSString *key = [secArray safeFirstObject];
    
    if ([key isEqualToString:@"title"]){
        
        if (_isShow) {
            
            float strH =[QuickControl heightForString:[_hotelList objectForKey:@"subtitle"] andWidth:[UIScreen mainScreen].bounds.size.width-10 Font:nil];
            return strH+220;
            
            
        }else{
            return 240;
        }
        
    }else if ([key isEqualToString:@"selection_reason"]){
    
        NSString *str = [[_hotelList objectForKey:key] safeObjectIndex:indexPath.row];
        float strH =[QuickControl heightForString:str andWidth:[UIScreen mainScreen].bounds.size.width-20 Font:nil];
        //NSLog(@"h =%f",strH);
        return strH;
    
    }else if ([key isEqualToString:@"hotel_info"]){
        NSDictionary *dict = [secArray safeObjectIndex:1];
        return  [self getHotel_infoHeight:dict];
        
        
    
    }else if ([key isEqualToString:@"hotel_package"]){
        
        NSArray *array = [self getShowHttel_Package];
        
        NSMutableDictionary *dict = [array safeObjectIndex:indexPath.row];
        BOOL istit = [[dict objectForKey:@"isTitle"] boolValue];
        NSString *name = [dict objectForKey:@"name"];
        
        if (istit) {
            return 40;
        }else{
            //NSDictionary *dictObj = [[secArray safeObjectIndex:1] safeObjectIndex:indexPath.row];
            
            
            NSDictionary *dictObj = [self getPakageNameWithInfo:name list:[[_sectionArray safeObjectIndex:indexPath.section] safeObjectIndex:1]];
            
            
            NSString *cont = [dictObj objectForKey:@"content"];
            NSString *feature = [dictObj objectForKey:@"feature"];
            
            float c_h = [QuickControl heightForString:cont andWidth:kMainScreenWidth-20 Font:[UIFont systemFontOfSize:15]];
            float f_h = [QuickControl heightForString:feature andWidth:kMainScreenWidth-20 Font:[UIFont systemFontOfSize:15]];
            
            return  c_h+f_h+90;
        }
        
        
        
        
        
        
        
        
        
        
        
        
    }else if ([key isEqualToString:@"flight_info"]){
    
        return  340;
    
    }else if ([key isEqualToString:@"user_listen"]){
    
        if (_isShowUserListen) {
            float hh = [QuickControl heightForString:USERLISTEN andWidth:kMainScreenWidth-20 Font:[UIFont systemFontOfSize:12]];
            return hh+20;
            
        }else{
            return 200;
        }
    
    }
//    else{
//        
//        float strH =[self getCellHeight:indexPath.section row:indexPath.row];
//        return strH;
//        
//    }
    
    
    
    
    return 250;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *arr = [_sectionArray safeObjectIndex:section];
    id key =[arr safeFirstObject];
    if ([key isEqualToString:@"selection_reason"]  ||[key isEqualToString:@"hotel_info"] || [key isEqualToString:@"flight_info"] || [key isEqualToString:@"user_listen"])
     {
         return HeadH;
     }else if ([key isEqualToString:@"hotel_package"]){
         return 5;
     }
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    return [self getNumCellForSection:section];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *secArray = [_sectionArray objectAtIndex:indexPath.section];
    NSString *key = [secArray firstObject];
    
    if ([key isEqualToString:@"title"]) {
        static NSString *detailIndicated = @"hotel_AutoImageTextTableViewCell";
        
        hotel_AutoImageTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
        
        
        if (cell == nil) {
            cell = [[hotel_AutoImageTextTableViewCell alloc] initWithTEXTStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated cellHeight:130 Images:[_hotelList objectForKey:@"photo_list"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //
        
        [cell loadText:[_hotelList objectForKey:@"subtitle"]];

        return cell;
        
        
    }else if ([key isEqualToString:@"selection_reason"]){
        
        static NSString *detailIndicated = @"ProductDetailCell";
        
        ProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
        
        
        if (cell == nil) {
            cell = [[ProductDetailCell alloc] initWithTEXTStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated cellHeight:130];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString *str = [[_hotelList objectForKey:key] safeObjectIndex:indexPath.row];
        //NSLog(@"str = %@",str);
        [cell loadText:str];
        
        
        return cell;
        
    }else if ([key isEqualToString:@"hotel_package"]){
        
        NSArray *showArray = [self getShowHttel_Package];
        
        NSMutableDictionary *dict = [showArray safeObjectIndex:indexPath.row];
        BOOL istit = [[dict objectForKey:@"isTitle"] boolValue];
        NSString *name = [dict objectForKey:@"name"];
        
        
        
        
        if (istit) {
            //title
            static NSString *detailIndicated = @"HotelDetailTableViewCellTitle";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
            UILabel *labelTitle;
            UILabel *labelPrice;
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width-100, 35)];
                [labelTitle setBackgroundColor:[UIColor colorFromHexRGB:@"ffffff"]];
                labelTitle.font = [UIFont systemFontOfSize:15];
                labelTitle.textColor = [UIColor colorFromHexRGB:@"333333"];
                
                labelTitle.tag = 8888;
                [cell addSubview:labelTitle];
                
                
                labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, 5, 100, 35)];
                [labelPrice setBackgroundColor:[UIColor colorFromHexRGB:@"ffffff"]];
                labelPrice.font = [UIFont systemFontOfSize:15];
                labelPrice.textColor = RGBCOLOR(246, 79, 0);
                labelPrice.tag = 9999;
                
                [cell addSubview:labelPrice];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, HeadH-1, self.view.width, 0.5)];
                line.backgroundColor = RGBCOLOR(169, 169, 169);
                [cell addSubview:line];
                
                
            }
            
            labelTitle = (UILabel*)[cell viewWithTag:8888];
            labelPrice = (UILabel*)[cell viewWithTag:9999];
            
            
            
            //NSDictionary *dict = [[[_sectionArray safeObjectIndex:indexPath.section] safeObjectIndex:1] safeObjectIndex:indexPath.row];
            
            NSDictionary *dict = [self getPakageNameWithInfo:name list:[[_sectionArray safeObjectIndex:indexPath.section] safeObjectIndex:1]];
            
            labelTitle.text = [NSString stringWithFormat:@"  %@",[dict objectForKey:@"name"]];
            labelPrice.text = [NSString stringWithFormat:@"%@/人起",[NSString moneyFromThousand:[dict objectForKey:@"price"]]];
            
            
            
            return cell;
            
            
            
            
            
        }else{
            static NSString *detailIndicated = @"HotelDetailTableViewCell";
            
            HotelDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
            
            
            if (cell == nil) {
                cell = [[HotelDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            NSLog(@"index = %d",indexPath.row);
            
            //NSDictionary *dict = [[[_sectionArray safeObjectIndex:indexPath.section] safeObjectIndex:1] safeObjectIndex:indexPath.row-1];
            
            
            [cell loadObj:[self getPakageNameWithInfo:name list:[[_sectionArray safeObjectIndex:indexPath.section] safeObjectIndex:1]]];
            
            
            return cell;
        }
        
        
        
        
        
        
    }else if ([key isEqualToString:@"hotel_info"]){
        
        NSString *detailIndicated =[NSString stringWithFormat:@"HotelAnyImagesTableViewCell%d%d",indexPath.section,indexPath.row];
        HotelAnyImagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
        
        if (cell == nil) {
            cell = [[HotelAnyImagesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell loadObj:[[_sectionArray safeObjectIndex:indexPath.section] safeObjectIndex:1]];
        }
        
        
        
        
        
        return cell;
        
        
    }else if ([key isEqualToString:@"flight_info"]){
        
        NSString *detailIndicated =@"Flight_infoTableViewCell";
        Flight_infoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
        
        if (cell == nil) {
            cell = [[Flight_infoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        [cell loadObj:[self getFlightWithName:_flightName]];

        
        
        return cell;
        
        
    }else if ([key isEqualToString:@"user_listen"]){
        
        NSString *detailIndicated =@"user_listen";
        Hotel_UserListenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
        
        if (cell == nil) {
            cell = [[Hotel_UserListenTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        
        
        
        return cell;
        
        
    }
    
    
    
    
    return nil;
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   
    
    NSMutableArray *secArray = [_sectionArray objectAtIndex:indexPath.section];
    NSString *key = [secArray firstObject];
    
    
    if ([key isEqualToString:@"hotel_package"]) {
        
        NSArray *array = [self getShowHttel_Package];
        
        NSMutableDictionary *dict = [array safeObjectIndex:indexPath.row];
        BOOL istit = [[dict objectForKey:@"isTitle"] boolValue];
        BOOL isShow =[[dict objectForKey:@"isshow"] boolValue];
        NSString *name = [dict objectForKey:@"name"];
        
        if (istit) {
            
            for (int i = 0; i<[_packageDict count]; i++) {
                
                NSMutableDictionary *dic = [_packageDict safeObjectIndex:i];
                NSString *nn = [dic objectForKey:@"name"];
                if ([nn isEqualToString:name]) {
                    
                    BOOL isTitle = [[dic objectForKey:@"isTitle"] boolValue];
                    if (isTitle) {
                        continue;
                    }else{
                        
                        BOOL isSw =[[dic objectForKey:@"isshow"] boolValue];
                        if (isSw) {
                            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isshow"];
                            
                            [tableView beginUpdates];
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationMiddle];
                            [tableView endUpdates];
                            
                            
                            
                        }else{
                            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isshow"];
                            
                            [tableView beginUpdates];
                            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationMiddle];
                            [tableView endUpdates];
                            
                            
                            
                        }
                        
                    
                    }
                }
                
                
            }
            
            
        }else{
            return;
        }
        
        
        
//        BOOL isSow = [[secArray safeObjectIndex:2] boolValue];
//        if (!isSow) {
//            
//            NSNumber *num = [NSNumber numberWithBool:YES];
//            [secArray removeObjectAtIndex:2];
//            [secArray insertObject:num atIndex:2];
//            
//            [tableView beginUpdates];
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
//            [tableView endUpdates];
//        }
        
    }
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}







@end
