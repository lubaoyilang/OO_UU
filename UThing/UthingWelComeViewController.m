//
//  UthingWelComeViewController.m
//  UThing
//
//  Created by luyuda on 14/12/10.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "UthingWelComeViewController.h"

@interface UthingWelComeViewController ()<UIScrollViewDelegate>

@end

@implementation UthingWelComeViewController
@synthesize delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView *sco = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    sco.contentSize = CGSizeMake(self.view.width*4, self.view.height);
    [sco setPagingEnabled:YES];
    [sco setShowsVerticalScrollIndicator:NO];
    [sco setShowsHorizontalScrollIndicator:NO];
    sco.bounces = NO;
    [self.view addSubview:sco];
    
    
    for (int i = 0; i<4; i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width*i, 0, self.view.width, self.view.height)];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
        [sco addSubview:image];
        
        
        if (i == 3) {
            image.userInteractionEnabled = YES;
            UIControl *con = [[UIControl alloc] initWithFrame:CGRectMake(0, self.view.height/2, self.view.width, self.view.height/2)];
            [con addTarget:self action:@selector(goUthing) forControlEvents:UIControlEventTouchUpInside];
            [image addSubview:con];
        }
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goUthing
{
    if (delegate && [delegate respondsToSelector:@selector(goWelBack)]) {
        [delegate goWelBack];
    }
    
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
