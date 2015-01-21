//
//  SubjectViewController.m
//  UThing
//
//  Created by Apple on 15/1/20.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "SubjectViewController.h"
#import "NetworkingCenter.h"
#import "ProductDetailViewController.h"
#import "HotelProductDetailViewController.h"

@interface SubjectViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-44)];
    _webView.delegate = self;
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [self.view addSubview:_webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showHub:@"专题加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    [self hideHub];
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHub];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        NSURL *url = [request URL];
        NSString *urlString = [url absoluteString];
        NSArray *array = [urlString componentsSeparatedByString:@"/"];
        
        NSLog(@"lastID = %@", [array lastObject]);
        
        [self downloadDataWithID:[array lastObject]];
        
        return NO;
    }
    return YES;
}


//下载数据 判断type
- (void)downloadDataWithID:(NSString *)ID
{
    ParametersManagerObject *managerObject = [[ParametersManagerObject alloc] init];
    
    [managerObject addParamer:[NSString stringWithFormat:@"id=%@", ID]];
    
    NSData *data = [managerObject getHeetBody];
    
    NetworkingCenter *networkingCenter = [[NetworkingCenter alloc] init];
    
    [networkingCenter setMyResultsHandle:^(NSMutableData *resultData) {
        
        __block NSError *error1 = [[NSError alloc] init];
        NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error1];
        
    
        
        if ([managerObject checkSign:[resultsDictionary objectForKey:@"data"] Sign:[resultsDictionary objectForKey:@"sign"]]) {
            
            
            if ([[[resultsDictionary objectForKey:@"data"] objectForKey:@"type"] intValue] == 3) {
                
                //
                HotelProductDetailViewController *hpdvc = [[HotelProductDetailViewController alloc] init];
                hpdvc.ProductId = ID;
                [self.navigationController pushViewController:hpdvc animated:YES];
                
            } else {
                
                ProductDetailViewController *pdvc = [[ProductDetailViewController alloc] init];
                pdvc.ProductId = ID;
                [self.navigationController pushViewController:pdvc animated:YES];
            }

            
        }
        
        
        
        
    }];
    
    [networkingCenter setMyError:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
    [networkingCenter myAsynchronousPostWithUrl:productTypeURL postData:data];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

@end
