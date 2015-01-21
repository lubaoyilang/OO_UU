//
//  HotelAnyImagesTableViewCell.m
//  UThing
//
//  Created by luyuda on 15/1/4.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "HotelAnyImagesTableViewCell.h"

@interface HotelAnyImagesTableViewCell ()



@end


@implementation HotelAnyImagesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        
        
    }
    return self;
}



- (void)loadObj:(id)obj
{
    

    
    
    
    float offH = 10;
    
    id hotel_introduction = [obj objectForKey:@"summary"];
    NSMutableString *allIntroduction  = [NSMutableString stringWithString:@""];
    if ([hotel_introduction isKindOfClass:[NSArray class]]) {
        for (int i = 0; i<[hotel_introduction count]; i++) {
            if ([allIntroduction length]) {
                allIntroduction = [NSMutableString stringWithFormat:@"%@\n%@",allIntroduction,[hotel_introduction safeObjectIndex:i]];
            }else{
                allIntroduction = [NSMutableString stringWithFormat:@"%@",[hotel_introduction safeObjectIndex:i]];
            }
            
        }
    
    }else if ([hotel_introduction isKindOfClass:[NSNull class]]){
        allIntroduction = [NSMutableString stringWithFormat:@"%@",@""];
    }else{
        allIntroduction = [NSMutableString stringWithFormat:@"%@",hotel_introduction];
    }
    
    float introductionH  = 0.0;
    
    if ([allIntroduction length]) {
        
        
        NSLog(@"allIntroduction=%@",allIntroduction);
        
        UILabel *titL = [[UILabel alloc] initWithFrame:CGRectZero];
        titL.backgroundColor = [UIColor clearColor];
        titL.font = [UIFont systemFontOfSize:15];
        titL.textColor = RGBCOLOR(103, 103, 103);
        titL.numberOfLines = 0;
        [self addSubview:titL];
        titL.text =allIntroduction;
        introductionH = [QuickControl heightForString:allIntroduction andWidth:[UIScreen mainScreen].bounds.size.width-20 Font:titL.font];
        titL.frame = CGRectMake(10, offH, kMainScreenWidth-20, introductionH);
        offH +=introductionH;
    }

    
    
    
    NSString *coverUrl = [obj objectForKey:@"img_url"];
    if ([coverUrl isValidUrl]) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, offH, kMainScreenWidth-20, 207)];
        img.backgroundColor = [UIColor clearColor];
        [img sz_setImageWithUrlString:coverUrl imageSize:@"676x449" options:SDWebImageLowPriority placeholderImageName:nil];
        [self addSubview:img];
        
        
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
        
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offH, [UIScreen mainScreen].bounds.size.width-20, 20)];
        nameLabel.text = name;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.numberOfLines = 0;
        [self addSubview:nameLabel];
        offH+=20.0;
        if ([url isValidUrl]) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, offH, kMainScreenWidth-20, 207)];
            img.backgroundColor = [UIColor clearColor];
            [img sz_setImageWithUrlString:url imageSize:@"676x449" options:SDWebImageLowPriority placeholderImageName:nil];
            [self addSubview:img];
            offH+=207;
        }
        
        NSLog(@"temp = %@",temp);
        
        if ([temp length]) {
            float strH =[QuickControl heightForString:temp andWidth:[UIScreen mainScreen].bounds.size.width-20 Font:[UIFont systemFontOfSize:15]];
            UILabel *detailL =[[UILabel alloc] initWithFrame:CGRectMake(10, offH, [UIScreen mainScreen].bounds.size.width-20, strH)];
            detailL.numberOfLines = 0;
            detailL.text =temp;
            detailL.backgroundColor = [UIColor clearColor];
            detailL.font = [UIFont systemFontOfSize:15];
            [self addSubview:detailL];
            offH +=strH;
        }
        
        
        
        
    }
    
    
    
    NSLog(@"introductionH = %f",offH);
    
    

}

@end
