//
//  ProductDetailViewController.h
//  UThing
//
//  Created by luyuda on 14/11/25.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "BaseViewController.h"

@interface ProductDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

//产品ID
@property (nonatomic,strong)NSString *ProductId;

- (NSString*)getProductTitle;

@end
