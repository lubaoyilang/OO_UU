//
//  ProductDetailCell.m
//  UThing
//
//  Created by luyuda on 14/11/25.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "ProductDetailCell.h"


@interface ProductDetailCell ()

@property (nonatomic,strong)UILabel *tLabel;


@end




@implementation ProductDetailCell



- (id)initWithTEXTStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellh
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        _tLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tLabel.backgroundColor = [UIColor clearColor];
        _tLabel.font = [UIFont fontWithName:@"Arial" size:12];
        [self addSubview:_tLabel];
        
        
    }
    return self;

}



- (void)loadText:(NSString*)str
{
    _tLabel.text = str;
    _tLabel.numberOfLines = 0;
    
    float h =[QuickControl heightForString:str andWidth:[UIScreen mainScreen].bounds.size.width-20 Font:_tLabel.font];
    if (h<=20.0) {
        _tLabel.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 20);
        
    }else{
        _tLabel.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, [QuickControl heightForString:str andWidth:[UIScreen mainScreen].bounds.size.width-20 Font:_tLabel.font]);
    }
    
    
    
    

}






@end
