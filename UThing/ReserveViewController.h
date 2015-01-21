//
//  ReserveViewController.h
//  UThing
//
//  Created by wushengzhong on 14/12/22.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "BaseViewController.h"

//预定咨询 界面

@interface ReserveViewController : BaseViewController

//酒店套餐标题   由酒店详情界面传入
@property (nonatomic, strong) NSString *title;//标题

@property (nonatomic, strong) NSString *proID;//产品id

@property (nonatomic, strong) NSDictionary *proInfo;

@end
