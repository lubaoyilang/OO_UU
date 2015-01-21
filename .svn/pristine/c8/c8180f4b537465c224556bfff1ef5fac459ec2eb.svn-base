//
//  ProductDetailViewController.m
//  UThing
//
//  Created by luyuda on 14/11/25.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductImageTextCell.h"
#import "ProductDetailCell.h"
#import "UserInfoSingleton.h"
#import "ProductRightImageCell.h"
#import "ProductRightTextCell.h"
#import "DateOutViewController.h"

#define titImageW 211
#define puImageW 190
#define HeadH   40
#define titHeadH    30

#define flightStr @"起飞时间:  %@ \n降落时间:  %@ %@ \n起飞机场:  %@ \n降落机场:  %@ \n航空公司名称:  %@ \n航班号:  %@\n"


@interface ProductDetailViewController ()

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,strong) NSMutableData *productDetailData;
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,strong) NSMutableArray *contArray;
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,assign) NSInteger tripArrCount;

@end

@implementation ProductDetailViewController
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"产品详情";
    _isShow = NO;
    _tripArrCount = 0;
    _sectionArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSize) name:@"changesize" object:nil];
    
    [self getProductDetail];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews {
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    viewBounds.origin.y = topBarOffset * -1;
    self.view.bounds = viewBounds;
}


#pragma mark - Action

//预定
- (void)reserveAction
{
    if ([LoginStatusObject isLoginStatus]) {
        
        DateOutViewController *dd = [[DateOutViewController alloc] initWithSelectionMode:KalSelectionModeSingle];
        dd.productDict =_dataDict;
        dd.selectedDate = [NSDate dateStartOfDay:[[NSDate date] offsetDay:0]];
        [self.navigationController pushViewController:dd animated:YES];
        
    }
    
    
    
    
    
    
}




#pragma mark - View
- (void)initView
{
    

    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.bounds.size.height-self.topLayoutGuide.length-30) style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    [_tableview setSeparatorColor:[UIColor clearColor]];
    _tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableview];
    
    [self initBelowBar];
    

}


- (void)initBelowBar
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
    [yudingBtn addTarget:self action:@selector(reserveAction) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:yudingBtn];
    
    NSString *pric = [NSString moneyFromThousand:[_dataDict objectForKey:@"low_price"]];
    
    //
    NSString *priceStr = [NSString stringWithFormat:@"￥%@/人起",pric];
    float w = [QuickControl widthForString:priceStr andHeigh:30 Font:[UIFont systemFontOfSize:17]];
    
    
    UILabel *low_price = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-100-w, 0, w, 30)];
    low_price.textColor = [UIColor colorFromHexRGB:@"ff9900"];
    low_price.font = [UIFont systemFontOfSize:17];
    low_price.textAlignment = NSTextAlignmentRight;
    low_price.backgroundColor = [UIColor clearColor];
    low_price.text = priceStr;
    [bg addSubview:low_price];
    
    
    
   
    
}


- (void)changeSize
{
    _isShow = YES;
    [_tableview reloadData];
    
    
}





#pragma mark - Net

- (void)getProductDetail
{
    
    ParametersManagerObject *pObject = [[ParametersManagerObject alloc] init];
    
    
    
    NSString *uid =[NSString stringWithFormat:@"id=%@",ProductId] ; //key = password
    
    
    [pObject addParamer:uid];
    
    
    NSString* urlstr = [getProdectDetailURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    
    NSString *resultCode = [dict objectForKey:@"result"];
    
    if ([resultCode isEqualToString:@"ok"]) {
        
        _dataDict = [dict objectForKey:@"data"];
        NSString *sign = [dict objectForKey:@"sign"];
        NSLog(@"%@",_dataDict);
        ParametersManagerObject *p = [[ParametersManagerObject alloc] init];
        BOOL isSign = [p checkSign:_dataDict Sign:sign];
        
        if (isSign) {
            [self initView];
            
        }else{
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"警告" message:@"数据校验出错，请重新请求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            _dataDict = nil;
            
            
        }
        
        
        
    }else{
        NSDictionary *data_dict = [dict objectForKey:@"data"];
        NSString *errorMsg = [data_dict objectForKey:@"msg"];
        
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"警告" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        
        
    }
    
    
    
    [self hideHub];
    
    
    
    
    
    
    
}

#pragma mark - dataFix

- (void)fixContentArray
{
    
    if ([_contArray count]) {
        return;
    }
    
    _contArray = [[NSMutableArray alloc] init];
    NSArray *tripArray = [_dataDict objectForKey:@"trip"];
    _tripArrCount = [tripArray count];
    if ([tripArray count]) {
        
        for (int i = 0; i<[tripArray count]; i++) {
            NSDictionary *dic = [tripArray objectAtIndex:i];
            NSArray *cArr = [dic objectForKey:@"content"];
            [_contArray addObject:[NSString stringWithFormat:@"第%d天",i+1]];
            for (NSString *str in cArr) {
                [_contArray addObject:str];
            }
        }
    }
}


- (NSString*)getCellContent:(int)section row:(int)r
{
    NSArray *secArray = [_sectionArray objectAtIndex:section];
    NSString *key = [secArray firstObject];
    id obj = [_dataDict objectForKey:key];
    if ([key isEqualToString:@"trip"]) {
    
        
        return [_contArray objectAtIndex:r];
        
        
        
        
        
    }
    else if ([key isEqualToString:@"flight"]){
        if ([obj isKindOfClass:[NSArray class]]) {
            NSDictionary *dict = [obj firstObject];
            NSString *days = [dict objectForKey:@"days"];
            if ([days integerValue]==0) {
                days = @"";
            }else{
                days = [NSString stringWithFormat:@"+%@天",days];
            }
            
            NSString *str = [NSString stringWithFormat:flightStr,[dict objectForKey:@"start_time"],[dict objectForKey:@"end_time"],days,[dict objectForKey:@"start_airport"],[dict objectForKey:@"end_airport"],[dict objectForKey:@"airline"],[dict objectForKey:@"flight_number"]];
            
            return str;
            
        }else{
            return nil;
        }
        
        
    }
    else{
    
        if ([obj isKindOfClass:[NSArray class]]) {
            
            return [obj objectAtIndex:r];
            
        }else if ([obj isKindOfClass:[NSString class]]){
            return obj;
        }else{
            return obj;
        }
        
        
    }
    
    
    
    
}

- (NSString*)getProductTitle
{
    NSString* obj = [_dataDict objectForKey:@"title"];
    return obj;
    
}


- (float)getCellHeight:(int)section row:(int)r
{
    float h = 0.0;
    
    NSArray *secArray = [_sectionArray objectAtIndex:section];
    NSString *key = [secArray firstObject];
    id obj = nil;
    
    
    if ([key isEqualToString:@"trip"]) {
        
//        NSArray *arr = [_dataDict objectForKey:@"trip"];
//        NSMutableArray *contArray = [[NSMutableArray alloc] init];
//        
//        for (int i = 0; i<[arr count]; i++) {
//            NSDictionary *dic = [arr objectAtIndex:i];
//            NSArray *cArr = [dic objectForKey:@"content"];
//            [contArray addObject:[NSString stringWithFormat:@"第%d天",i+1]];
//            for (NSString *str in cArr) {
//                [contArray addObject:str];
//            }
//        }

        obj = _contArray ;
        UIFont *fon = [UIFont systemFontOfSize:12];

    
        if ([obj isKindOfClass:[NSArray class]]) {
            
             id str = [obj objectAtIndex:r];
            if ([str isKindOfClass:[NSString class]]) {
                
                if ([str isValidUrl]) {
                    if (section == 0) {
                        h+=titImageW;
                    }else{
                        h+=puImageW;
                    }
                    return h;
                }else{
                    
                    NSString *top = [str substringWithRange:NSMakeRange(0,1)];
                    
                    if ([top isEqualToString:@"第"]) {
                        fon = [UIFont systemFontOfSize:14];
                    }else{
                        fon = [UIFont systemFontOfSize:12];
                    }
                    
                    h += [QuickControl heightForString:str andWidth:rightTextW Font:fon];
                    return h;
                    
                }
                
                
            }
            
            
            
            
        }else if ([obj isKindOfClass:[NSString class]]){
            
            NSString *top = [obj substringWithRange:NSMakeRange(0,1)];
            
            if ([top isEqualToString:@"第"]) {
                fon = [UIFont systemFontOfSize:14];
            }else{
                fon = [UIFont systemFontOfSize:12];
            }
            
            
            h+=[QuickControl heightForString:obj andWidth:rightTextW Font:fon];
            return h;
            
            
        }
    }else if ([key isEqualToString:@"flight"]){
    
        obj = [_dataDict objectForKey:key];
        
        if ([obj isKindOfClass:[NSArray class]]) {
            NSDictionary *dict = [obj firstObject];
            
            NSString *days = [dict objectForKey:@"days"];
            if ([days integerValue]==0) {
                days = @"";
            }else{
                days = [NSString stringWithFormat:@"+%@天",days];
            }
            
            NSString *str = [NSString stringWithFormat:flightStr,[dict objectForKey:@"start_time"],[dict objectForKey:@"end_time"],days,[dict objectForKey:@"start_airport"],[dict objectForKey:@"end_airport"],[dict objectForKey:@"airline"],[dict objectForKey:@"flight_number"]];
            
            h += [QuickControl heightForString:str andWidth:[UIScreen mainScreen].bounds.size.width Font:nil];
            return h;
            
        }else{
            return h;
        }

        
        
        
    }else{
        //非行程
        
        obj = [_dataDict objectForKey:key];
        
        if ([obj isKindOfClass:[NSArray class]]) {
            
             id str = [obj objectAtIndex:r];
            if ([str isKindOfClass:[NSString class]]) {
                
                if ([str isValidUrl]) {
                    if (section == 0) {
                        h+=titImageW;
                    }else{
                        h+=puImageW;
                    }
                    return h;
                }else{
                    
                    h += [QuickControl heightForString:str andWidth:[UIScreen mainScreen].bounds.size.width-20 Font:nil];
                    return h;
                    
                }
                
            }
            
            
            
            
            
        }else if ([obj isKindOfClass:[NSString class]]){
            
            h+=[QuickControl heightForString:obj andWidth:[UIScreen mainScreen].bounds.size.width-20 Font:nil];
            return h;
            
            
        }

        
        
        
    
    }
    
    
    
    if ([obj isKindOfClass:[NSArray class]]) {
        
        id str = [obj objectAtIndex:r];
        
        if ([str isKindOfClass:[NSString class]]) {
            if ([str isValidUrl]) {
                if (section == 0) {
                    h+=titImageW;
                }else{
                    h+=puImageW;
                }
                return h;
            }else{
                
                h += [QuickControl heightForString:str andWidth:[UIScreen mainScreen].bounds.size.width-10 Font:nil];
                return h;
                
            }
        }
        
        

        
    }else if ([obj isKindOfClass:[NSString class]]){
        
        h+=[QuickControl heightForString:obj andWidth:[UIScreen mainScreen].bounds.size.width-10 Font:nil];
        return h;
        
        
    }

    
    return h;
    
}

- (int)getNumSection
{
    if ([_sectionArray count]) {
        return [_sectionArray count];
    }
    
    
    [_sectionArray removeAllObjects];
    
    NSString *title = [_dataDict objectForKey:@"title"];
    if ([title length]) {
        NSArray *arr = [[NSArray alloc] initWithObjects:@"title",title,@"", nil];
        [_sectionArray addObject:arr];
    }
    NSArray *recommend = [_dataDict objectForKey:@"feature"];
    if ([recommend count]) {
        NSArray *arr = [[NSArray alloc] initWithObjects:@"feature",@"行程特点",@"app-详情页_07", nil];
        [_sectionArray addObject:arr];
    }
    id flight = [_dataDict objectForKey:@"flight"];
    if ([flight isKindOfClass:[NSArray class]]) {

        NSArray *arr = [[NSArray alloc] initWithObjects:@"flight",@"机票信息",@"app-详情页_10", nil];
        [_sectionArray addObject:arr];
        
        
    }
    NSArray *trip = [_dataDict objectForKey:@"trip"];
    if ([trip count]) {
        
        NSArray *arr = [[NSArray alloc] initWithObjects:@"trip",@"行程",@"app-详情页_12", nil];
        [_sectionArray addObject:arr];
    }
    NSArray *fee_include = [_dataDict objectForKey:@"fee_include"];
    if ([fee_include count]) {
        
        NSArray *arr = [[NSArray alloc] initWithObjects:@"fee_include",@"费用包含",@"app-详情页_32", nil];
        [_sectionArray addObject:arr];
    }
    
    NSArray *fee_exclude = [_dataDict objectForKey:@"fee_exclude"];
    if ([fee_exclude count]) {
        
        NSArray *arr = [[NSArray alloc] initWithObjects:@"fee_exclude",@"费用不包含",@"app-详情页_35", nil];
        [_sectionArray addObject:arr];
    }
    
    NSArray *visa = [_dataDict objectForKey:@"visa"];
    if ([visa count]) {
        
        NSArray *arr = [[NSArray alloc] initWithObjects:@"visa",@"签证",@"app-详情页_37", nil];
        [_sectionArray addObject:arr];
    }
    
    
    [self fixContentArray];
    
    return [_sectionArray count];

}


- (int)getNumCellForSection:(int)section
{
    NSArray *secArray = [_sectionArray objectAtIndex:section];
    NSString *key = [secArray firstObject];
    
    if ([key isEqualToString:@"trip"]) {
        NSArray *arr = [_dataDict objectForKey:@"trip"];
        int j = 0;
        
        for (int i = 0; i<[arr count]; i++) {
            NSDictionary *dic = [arr objectAtIndex:i];
            NSArray *cArr = [dic objectForKey:@"content"];
            j = j+1+[cArr count];
            
        }
       
        return j;
        
        
    }else{
        id obj = [_dataDict objectForKey:key];
        
        if ([obj isKindOfClass:[NSArray class]]) {
            return [obj count];
        }else if ([obj isKindOfClass:[NSString class]]){
            return 1;
        }
        
    }
    
    
    
    
    return 1;
    
    
}






#pragma mark - tableviewDelegate






//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self getNumSection];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    bg.backgroundColor = [UIColor whiteColor];
    
    
    
    NSArray *arr = [_sectionArray objectAtIndex:section];
    NSString *tit = [arr objectAtIndex:1];
    NSString *img = [arr lastObject];
    
    switch (section) {
        case 0:
        {
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 20)];
            [labelTitle setBackgroundColor:[UIColor colorFromHexRGB:@"ffffff"]];
            labelTitle.font = [UIFont systemFontOfSize:15];
            labelTitle.textColor = [UIColor colorFromHexRGB:@"333333"];
            [bg addSubview:labelTitle];
            labelTitle.text = [NSString stringWithFormat:@"  %@",tit];
            break;
        }
        case 1:
            
            
        case 2:
            
            
        case 3:
            
            
        case 4:
            
            
        case 5:
            
            
        case 6:
            
           
        case 7:
            
            
            
        default:
        {
            
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 5)];
            topLine.backgroundColor = RGBCOLOR(74, 57, 63);
            [bg addSubview:topLine];
            
            
            
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5+(HeadH-5-18)/2, 18, 18)];
            icon.image = [UIImage imageNamed:img];
            [bg addSubview:icon];
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, (HeadH-5-12)/2, self.view.frame.size.width, 20)];
            [labelTitle setBackgroundColor:[UIColor colorFromHexRGB:@"ffffff"]];
            labelTitle.font = [UIFont systemFontOfSize:14];
            labelTitle.textColor = [UIColor colorFromHexRGB:@"333333"];
            [bg addSubview:labelTitle];
            labelTitle.text = tit;
            
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, self.view.width, 0.5)];
            line.backgroundColor = RGBCOLOR(95, 90, 87);
            [bg addSubview:line];
            
            
            break;
        }
    }
    
    
    
    
    return bg;
}





// 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    NSArray *secArray = [_sectionArray objectAtIndex:indexPath.section];
    NSString *key = [secArray firstObject];
    
    if ([key isEqualToString:@"title"]){
    
        if (_isShow) {
            
            float strH =[QuickControl heightForString:[_dataDict objectForKey:@"subtitle"] andWidth:[UIScreen mainScreen].bounds.size.width-10 Font:nil];
            return strH+220;
            
            
        }else{
            return 240;
        }
    
    }else{
    
        float strH =[self getCellHeight:indexPath.section row:indexPath.row];
        return strH;

    }
    
    
    
    
    //return 250;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return titHeadH;
    }
    return HeadH;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    
    return [self getNumCellForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *secArray = [_sectionArray objectAtIndex:indexPath.section];
    NSString *key = [secArray firstObject];
    
    if ([key isEqualToString:@"trip"]){
    
        NSString *str = [self getCellContent:indexPath.section row:indexPath.row];
        if ([str isValidUrl]) {
            
            
            static NSString *detailIndicated = @"ProductRightImageCell";
            
            ProductRightImageCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
            
            if (cell == nil) {
                cell = [[ProductRightImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }

            [cell loadImageWithUrl:str];
            [cell showLine:[self getCellHeight:indexPath.section row:indexPath.row]];
            if (indexPath.row+1 == [_contArray count]) {
                [cell showIcon:@"2"];
            }else{
                [cell showIcon:@"1"];
            }
            return cell;
            
            
        }else{
            
            static NSString *detailIndicated = @"ProductRightTextCell";
            
            ProductRightTextCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
            
            if (cell == nil) {
                cell = [[ProductRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
            }
            
            [cell loadText:str];
            [cell showLine:[self getCellHeight:indexPath.section row:indexPath.row]];
            
            if (indexPath.row+1 == [_contArray count]) {
                [cell showIcon:@"2"];
            }else{
                [cell showIcon:@"1"];
            }
            
            
            
            
            
            
            
            
            return cell;
        }
        
        
        
    }else{
        
        
        
        if (indexPath.section == 0) {
            
            static NSString *detailIndicated = @"ProductImageTextCell";
            
            ProductImageTextCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
            
            
            if (cell == nil) {
                cell = [[ProductImageTextCell alloc] initWithTEXTStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated cellHeight:130];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            //
            //[cell loadImageWithUrl:@"http://221.203.108.70:8080/jxzy/UploadFiles_4517/201005/2010052615045178.jpg"];
            
            [cell loadImageWithUrl:[_dataDict objectForKey:@"cover_photo_url"]];
            [cell loadText:[_dataDict objectForKey:@"subtitle"]];
            
            
            return cell;
            
            
            
        }else {
            
            
            static NSString *detailIndicated = @"ProductDetailCell";
            
            ProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
            
            
            if (cell == nil) {
                cell = [[ProductDetailCell alloc] initWithTEXTStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated cellHeight:130];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            NSString *str = [self getCellContent:indexPath.section row:indexPath.row];
            
            [cell loadText:str];
            
            
            return cell;
            
            
            
            
        }
        
    }
    
    
    
    
    
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
