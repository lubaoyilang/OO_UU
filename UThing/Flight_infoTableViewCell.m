//
//  Flight_infoTableViewCell.m
//  UThing
//
//  Created by luyuda on 15/1/6.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "Flight_infoTableViewCell.h"

#define bgTag 8000

@implementation Flight_infoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNotfication:) name:@"loadflight" object:nil];
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, 320)];
        bg.backgroundColor = RGBCOLOR(248, 248, 248);
        bg.tag =bgTag;
        [self addSubview:bg];
        
/*--------------------------------------------------------------------------------------------------*/
        
        
        UILabel *leftUp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 160)];
        leftUp.backgroundColor = [UIColor clearColor];
        leftUp.textColor = RGBCOLOR(103, 103, 103);
        leftUp.text = @"去程";
        leftUp.font = [UIFont systemFontOfSize:11];
        leftUp.textAlignment = NSTextAlignmentCenter;
        [bg addSubview:leftUp];
        
        
        UILabel *go_1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, kMainScreenWidth-100, 20)];
        go_1.backgroundColor = [UIColor clearColor];
        go_1.textColor = RGBCOLOR(103, 103, 103);
        go_1.text = @"";
        go_1.tag =bgTag+1;
        go_1.font = [UIFont systemFontOfSize:11];
        go_1.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:go_1];
        
        UILabel *go_2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, kMainScreenWidth-100, 20)];
        go_2.backgroundColor = [UIColor clearColor];
        go_2.textColor = RGBCOLOR(103, 103, 103);
        go_2.text = @"";
        go_2.tag =bgTag+2;
        go_2.font = [UIFont systemFontOfSize:11];
        go_2.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:go_2];
        
        UILabel *go_3 = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, kMainScreenWidth-100, 20)];
        go_3.backgroundColor = [UIColor clearColor];
        go_3.textColor = RGBCOLOR(103, 103, 103);
        go_3.text = @"";
        go_3.tag =bgTag+3;
        go_3.font = [UIFont systemFontOfSize:11];
        go_3.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:go_3];
        
        
        UILabel *go_4 = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, kMainScreenWidth-100, 20)];
        go_4.backgroundColor = [UIColor clearColor];
        go_4.textColor = RGBCOLOR(103, 103, 103);
        go_4.text = @"";
        go_4.tag =bgTag+4;
        go_4.font = [UIFont systemFontOfSize:11];
        go_4.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:go_4];
        
        UILabel *go_5 = [[UILabel alloc] initWithFrame:CGRectMake(100, 80, kMainScreenWidth-100, 20)];
        go_5.backgroundColor = [UIColor clearColor];
        go_5.textColor = RGBCOLOR(103, 103, 103);
        go_5.text = @"";
        go_5.tag =bgTag+5;
        go_5.font = [UIFont systemFontOfSize:11];
        go_5.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:go_5];
        
        
        UILabel *go_6 = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, kMainScreenWidth-100, 20)];
        go_6.backgroundColor = [UIColor clearColor];
        go_6.textColor = RGBCOLOR(103, 103, 103);
        go_6.text = @"";
        go_6.tag =bgTag+6;
        go_6.font = [UIFont systemFontOfSize:11];
        go_6.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:go_6];
        
        
        
        UILabel *go_7 = [[UILabel alloc] initWithFrame:CGRectMake(100, 120, kMainScreenWidth-100, 20)];
        go_7.backgroundColor = [UIColor clearColor];
        go_7.textColor = RGBCOLOR(103, 103, 103);
        go_7.text = @"";
        go_7.tag =bgTag+7;
        go_7.font = [UIFont systemFontOfSize:11];
        go_7.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:go_7];
        
        
        UILabel *go_8 = [[UILabel alloc] initWithFrame:CGRectMake(100, 140, kMainScreenWidth-100, 20)];
        go_8.backgroundColor = [UIColor clearColor];
        go_8.textColor = RGBCOLOR(103, 103, 103);
        go_8.text = @"";
        go_8.tag =bgTag+8;
        go_8.font = [UIFont systemFontOfSize:11];
        go_8.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:go_8];
        
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 160, kMainScreenWidth-20, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [bg addSubview:line];
        
        
/*--------------------------------------------------------------------------------------------------*/
        UILabel *rightUp = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 70, 160)];
        rightUp.backgroundColor = [UIColor clearColor];
        rightUp.textColor = RGBCOLOR(103, 103, 103);
        rightUp.text = @"返程";
        rightUp.font = [UIFont systemFontOfSize:11];
        rightUp.textAlignment = NSTextAlignmentCenter;
        [bg addSubview:rightUp];
        
        
        UILabel *back_1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 160, kMainScreenWidth-100, 20)];
        back_1.backgroundColor = [UIColor clearColor];
        back_1.textColor = RGBCOLOR(103, 103, 103);
        back_1.text = @"";
        back_1.tag = bgTag+1000+1;
        back_1.font = [UIFont systemFontOfSize:11];
        back_1.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:back_1];
        
        UILabel *back_2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 180, kMainScreenWidth-100, 20)];
        back_2.backgroundColor = [UIColor clearColor];
        back_2.textColor = RGBCOLOR(103, 103, 103);
        back_2.tag = bgTag+1000+2;
        back_2.text = @"";
        back_2.font = [UIFont systemFontOfSize:11];
        back_2.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:back_2];
        
        UILabel *back_3 = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, kMainScreenWidth-100, 20)];
        back_3.backgroundColor = [UIColor clearColor];
        back_3.textColor = RGBCOLOR(103, 103, 103);
        back_3.tag = bgTag+1000+3;
        back_3.text = @"";
        back_3.font = [UIFont systemFontOfSize:11];
        back_3.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:back_3];
        
        UILabel *back_4 = [[UILabel alloc] initWithFrame:CGRectMake(100, 220, kMainScreenWidth-100, 20)];
        back_4.backgroundColor = [UIColor clearColor];
        back_4.textColor = RGBCOLOR(103, 103, 103);
        back_4.tag = bgTag+1000+4;
        back_4.text = @"";
        back_4.font = [UIFont systemFontOfSize:11];
        back_4.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:back_4];
        
        UILabel *back_5 = [[UILabel alloc] initWithFrame:CGRectMake(100, 240, kMainScreenWidth-100, 20)];
        back_5.backgroundColor = [UIColor clearColor];
        back_5.textColor = RGBCOLOR(103, 103, 103);
        back_5.tag = bgTag+1000+5;
        back_5.text = @"";
        back_5.font = [UIFont systemFontOfSize:11];
        back_5.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:back_5];
        
        UILabel *back_6 = [[UILabel alloc] initWithFrame:CGRectMake(100, 260, kMainScreenWidth-100, 20)];
        back_6.backgroundColor = [UIColor clearColor];
        back_6.textColor = RGBCOLOR(103, 103, 103);
        back_6.tag = bgTag+1000+6;
        back_6.text = @"";
        back_6.font = [UIFont systemFontOfSize:11];
        back_6.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:back_6];
        
        
        UILabel *back_7 = [[UILabel alloc] initWithFrame:CGRectMake(100, 280, kMainScreenWidth-100, 20)];
        back_7.backgroundColor = [UIColor clearColor];
        back_7.textColor = RGBCOLOR(103, 103, 103);
        back_7.tag = bgTag+1000+7;
        back_7.text = @"";
        back_7.font = [UIFont systemFontOfSize:11];
        back_7.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:back_7];
        
        
        
        UILabel *back_8 = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, kMainScreenWidth-100, 20)];
        back_8.backgroundColor = [UIColor clearColor];
        back_8.textColor = RGBCOLOR(103, 103, 103);
        back_8.tag = bgTag+1000+8;
        back_8.text = @"";
        back_8.font = [UIFont systemFontOfSize:11];
        back_8.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:back_8];
        
        
        
        
        
        
        
    }
    return self;
}

- (void)loadNotfication:(NSNotification*)ca
{
    id oo = [ca object];
    [self loadObj:oo];
    
}


- (void)loadObj:(id)obj
{
    UIView *bg = [self viewWithTag:bgTag];
    
    UILabel *go_1 = (UILabel*)[bg viewWithTag:bgTag+1];
    UILabel *go_2 = (UILabel*)[bg viewWithTag:bgTag+2];
    UILabel *go_3 = (UILabel*)[bg viewWithTag:bgTag+3];
    UILabel *go_4 = (UILabel*)[bg viewWithTag:bgTag+4];
    UILabel *go_5 = (UILabel*)[bg viewWithTag:bgTag+5];
    UILabel *go_6 = (UILabel*)[bg viewWithTag:bgTag+6];
    UILabel *go_7 = (UILabel*)[bg viewWithTag:bgTag+7];
    UILabel *go_8 = (UILabel*)[bg viewWithTag:bgTag+8];
    
    
    UILabel *back_1  =(UILabel*)[bg viewWithTag:bgTag+1000+1];
    UILabel *back_2  =(UILabel*)[bg viewWithTag:bgTag+1000+2];
    UILabel *back_3  =(UILabel*)[bg viewWithTag:bgTag+1000+3];
    UILabel *back_4  =(UILabel*)[bg viewWithTag:bgTag+1000+4];
    UILabel *back_5  =(UILabel*)[bg viewWithTag:bgTag+1000+5];
    UILabel *back_6  =(UILabel*)[bg viewWithTag:bgTag+1000+6];
    UILabel *back_7  =(UILabel*)[bg viewWithTag:bgTag+1000+7];
    UILabel *back_8  =(UILabel*)[bg viewWithTag:bgTag+1000+8];
    
    
    
    
    int has_flight  = [[obj objectForKey:@"has_flight"] intValue];
    if (has_flight == 0) {
        go_1.text = [NSString stringWithFormat:@"出发机场:%@",@""];
        go_2.text = [NSString stringWithFormat:@"中转机场:%@",@""];
        go_3.text = [NSString stringWithFormat:@"到达机场:%@",@""];
        go_4.text = [NSString stringWithFormat:@"航空公司:%@",@""];
        go_5.text = [NSString stringWithFormat:@"起飞时间:%@",@""];
        go_6.text = [NSString stringWithFormat:@"到达时间:%@",@""];
        go_7.text = [NSString stringWithFormat:@"中转起飞时间:%@",@""];
        go_8.text = [NSString stringWithFormat:@"中转到达时间:%@",@""];
        
        back_1.text = [NSString stringWithFormat:@"出发机场:%@",@""];
        back_2.text = [NSString stringWithFormat:@"中转机场:%@",@""];
        back_3.text = [NSString stringWithFormat:@"到达机场:%@",@""];
        back_4.text = [NSString stringWithFormat:@"航空公司:%@",@""];
        back_5.text = [NSString stringWithFormat:@"起飞时间:%@",@""];
        back_6.text = [NSString stringWithFormat:@"到达时间:%@",@""];
        back_7.text = [NSString stringWithFormat:@"中转起飞时间:%@",@""];
        back_8.text = [NSString stringWithFormat:@"中转到达时间:%@",@""];

        return;
        
    }
    
    
    
    go_1.text = [NSString stringWithFormat:@"出发机场:%@",[obj objectForKey:@"t_start_airport"]];
    go_2.text = [NSString stringWithFormat:@"中转机场:%@",[obj objectForKey:@"t_mid_airport"]];
    go_3.text = [NSString stringWithFormat:@"到达机场:%@",[obj objectForKey:@"t_end_airport"]];
    go_4.text = [NSString stringWithFormat:@"航空公司:%@",[obj objectForKey:@"t_airline"]];
    go_5.text = [NSString stringWithFormat:@"起飞时间:%@",[obj objectForKey:@"t_start_time"]];
    
    go_7.text = [NSString stringWithFormat:@"中转起飞时间:%@",[obj objectForKey:@"t_mid_start_time"]];
    
    
    int t_mid_days  = [[obj objectForKey:@"t_mid_days"] intValue];
    if (t_mid_days == 0) {
        go_8.text = [NSString stringWithFormat:@"中转到达时间:%@",[obj objectForKey:@"t_mid_end_time"]];
    }else{
        go_8.text = [NSString stringWithFormat:@"中转到达时间:%@ +%d天",[obj objectForKey:@"t_mid_end_time"],t_mid_days];
    }
    
    
    
    
    int t_day = [[obj objectForKey:@"t_days"] intValue];
    if (t_day==0) {
        go_6.text = [NSString stringWithFormat:@"到达时间:%@",[obj objectForKey:@"t_end_time"]];
    }else{
        go_6.text = [NSString stringWithFormat:@"到达时间:%@ +%d天",[obj objectForKey:@"t_end_time"],t_day];
    }
    
    
    
    
    
    
    
    back_1.text = [NSString stringWithFormat:@"出发机场:%@",[obj objectForKey:@"b_start_airport"]];
    back_2.text = [NSString stringWithFormat:@"中转机场:%@",[obj objectForKey:@"b_mid_airport"]];
    back_3.text = [NSString stringWithFormat:@"到达机场:%@",[obj objectForKey:@"b_end_airport"]];
    back_4.text = [NSString stringWithFormat:@"航空公司:%@",[obj objectForKey:@"b_airline"]];
    back_5.text = [NSString stringWithFormat:@"起飞时间:%@",[obj objectForKey:@"b_start_time"]];
    
    back_7.text = [NSString stringWithFormat:@"中转起飞时间:%@",[obj objectForKey:@"b_mid_start_time"]];
    
    
    int b_mid_days  = [[obj objectForKey:@"b_mid_days"] intValue];
    if (b_mid_days == 0) {
        back_8.text = [NSString stringWithFormat:@"中转到达时间:%@",[obj objectForKey:@"b_mid_end_time"]];
    }else{
        back_8.text = [NSString stringWithFormat:@"中转到达时间:%@ +%d天",[obj objectForKey:@"b_mid_end_time"],b_mid_days];
    }
    
    
    
    int b_days = [[obj objectForKey:@"b_days"] intValue];
    if (b_days == 0) {
        back_6.text = [NSString stringWithFormat:@"到达时间:%@",[obj objectForKey:@"b_end_time"]];
    }else{
        back_6.text = [NSString stringWithFormat:@"到达时间:%@ +%d天",[obj objectForKey:@"b_end_time"],b_days];
    }
    
    
    
    
    
    
    

}






@end
