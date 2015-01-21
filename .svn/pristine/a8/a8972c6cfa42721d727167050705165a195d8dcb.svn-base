//
//  UserInfoCenterViewController.h
//  Uthing
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 Wushengzhong. All rights reserved.
//

#import "BaseViewController.h"
#import "QBFlatButton.h"

#define HeightForCell 35.0f

@protocol UserInfoCenterInfoDelegate <NSObject>

- (void)userInfoCenterClickIndex:(NSInteger)index;

@end

@interface UserInfoCenterViewController : BaseViewController
@property (nonatomic, weak) id<UserInfoCenterInfoDelegate> delegate;
@property (nonatomic, strong) UITableView *functionMenutableView;
@property (nonatomic, strong) QBFlatButton *quickLoginBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@end
