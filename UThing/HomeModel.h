//
//  AppModel.h
//  UThing
//
//  Created by Apple on 14/11/26.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import <Foundation/Foundation.h>

//首页
@interface HomeModel : NSObject

//type值
@property (nonatomic) NSInteger type;
//type的基本信息,含addtime、admin_id、booking、dep_status、flight、id、name、room_status、trip、updatetime
@property (nonatomic, strong) NSDictionary *infoDict;
//tpye中对应的几种产品信息,数组中存储类型为ProductModel类型
@property (nonatomic, strong) NSMutableArray *productArr;

@end
