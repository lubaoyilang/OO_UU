//
//  AboutUthingViewController.m
//  UThing
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "AboutUthingViewController.h"

@interface AboutUthingViewController ()
{
    UIScrollView *a_scrollView;
}

@end

@implementation AboutUthingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于游心";
    
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backView.image = [UIImage imageNamed:@"list-bg.png"];
    [self.view addSubview:backView];
    
    [self createScrollView];
}


- (void)createScrollView
{
    a_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    a_scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:a_scrollView];
    
    NSString *title1 = @"游心科技(北京)有限公司  简称游心网——以精品旅行为基础的国内领先生活方式平台。" ;
    NSString *content1 = @"游心网总部设立与北京，是一家以精品旅行为基础的电子商务生活平台。旅行产品涵盖自由行、海外参团、酒店套餐、同行精品，私人定制，并以顶级旅行产品专家姿态，致力于为中国品质生活人群打造符合旅游趋势的轻奢旅行。";
    UIImageView *itemView1 = [self createSingleItemWithTitle:title1 content:content1];
    CGRect frame = itemView1.frame;
    frame.origin.y = 30;
    itemView1.frame = frame;
    [a_scrollView addSubview:itemView1];
    
    NSString *title2 = @"优质资源";
    NSString *content2 = @"作为互联网精品旅行产品平台，游心网不断整合自身及合作伙伴拥有的强大优势旅行资源，全站产品全部经过游心严格的产品筛选标准，从内容到性价比皆体现着轻奢旅行所富有的高品质享受。";
    UIImageView *itemView2 = [self createSingleItemWithTitle:title2 content:content2];
    CGRect frame2 = itemView2.frame;
    frame2.origin.y = 30+itemView1.bounds.size.height+15;
    itemView2.frame = frame2;
    [a_scrollView addSubview:itemView2];
    
    
    NSString *title3 = @"筛选标准";
    NSString *content3 = @"游心产品筛选标准涵盖旅行中所涉及的各个方面的细节要求，如酒店级别及服务质量、线路的合理化(时间及空间优化)、航班时间(拒绝红眼航班及转机时间浪费等现象)、目的地景区价值、性价比等众多严格标准。";
    UIImageView *itemView3 = [self createSingleItemWithTitle:title3 content:content3];
    CGRect frame3 = itemView3.frame;
    frame3.origin.y = frame2.origin.y + frame2.size.height+15;
    itemView3.frame = frame3;
    [a_scrollView addSubview:itemView3];
    
    NSString *title4 = @"游心网是国内首个将轻奢旅行概念真正融入全部产品的旅行网站。";
    NSString *content4 = @"游心产品打造的轻奢，即\"轻度的奢华\"，追求细节控、品质控以及美好体验。\"轻\"，代表一种优雅、低调与舒适，却也无损高贵与雅致。\"奢\"，代表一种生活态度，一种品位和格调的象征。\r轻奢与金钱、地位、职业、年龄无关，不是头脑发热，更不是虚荣心作祟。\r轻奢是趋于一种理性、健康的消费方式，是处于自我需要，对性价比的理性分析和肯定。轻奢生活提倡的是\"没负担，有品质\"。无需勉强自己，当你不具备消费能力时，仍然可以拥有对时尚品位的学习精神和欣赏眼光；当你有一定消费能力时，学会享受轻奢，宠爱自己，生活可以更美好。\r任何时候，我们都可以拥有对高品质生活的理想和追求，这也是游心网做旅行的初衷。\"唯有爱与旅行，不可辜负。\"";
    UIImageView *itemView4 = [self createSingleItemWithTitle:title4 content:content4];
    CGRect frame4 = itemView4.frame;
    frame4.origin.y = frame3.origin.y + frame3.size.height+15;
    itemView4.frame = frame4;
    [a_scrollView addSubview:itemView4];
    
    a_scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, frame4.origin.y+frame4.size.height+30);
}

- (UIImageView *)createSingleItemWithTitle:(NSString *)title content:(NSString *)content
{
    UIImageView *backView = [[UIImageView alloc] init];
    backView.image = [[UIImage imageNamed:@"app-关于游心_03.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:10];
    
    UILabel *titleLabel = [self createAutolayoutWithString:title fontSize:14 color:[UIColor colorFromHexRGB:@"ff9900"] valueX:5 valueY:10];
    [backView addSubview:titleLabel];
    
    UILabel *contentLabel = [self createAutolayoutWithString:content fontSize:12 color:[UIColor whiteColor] valueX:5 valueY:10+titleLabel.bounds.size.height+10];
    [backView addSubview:contentLabel];
    
    backView.frame = CGRectMake(5, 0, self.view.bounds.size.width-10, 10+titleLabel.bounds.size.height+15+contentLabel.bounds.size.height+10);
    
    return backView;
}

- (UILabel *)createAutolayoutWithString:(NSString *)string fontSize:(CGFloat)fontSize color:(UIColor *)color valueX:(CGFloat)x valueY:(CGFloat)y
{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    UIFont * tfont = [UIFont systemFontOfSize:fontSize];
    label.font = tfont;
    label.lineBreakMode =NSLineBreakByCharWrapping ;
    label.text = string ;
    label.textColor = color;
    
    CGSize size =CGSizeMake(self.view.bounds.size.width-3*x,1000);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    label.frame = CGRectMake(x, y, actualsize.width, actualsize.height);
    
    return label;
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
