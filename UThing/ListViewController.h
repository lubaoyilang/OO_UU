//
//  ListViewController.h
//  UThing
//
//  Created by Apple on 14/11/18.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "BaseViewController.h"


@interface ListViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataArr;

//适用于重写
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//开始下载数据并显示数据
- (void)downLoadDataWithType:(NSInteger)tpyeIndex;

@end
