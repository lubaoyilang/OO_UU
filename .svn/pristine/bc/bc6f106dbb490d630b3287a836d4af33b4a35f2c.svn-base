//
//  DateOutViewController.h
//  UThing
//
//  Created by luyuda on 14/11/18.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "BaseViewController.h"
#import "KalView.h"       // for the KalViewDelegate protocol
#import "KalDataSource.h" // for the KalDataSourceCallbacks protocol

@class KalLogic;


@interface DateOutViewController : BaseViewController<KalViewDelegate, KalDataSourceCallbacks>
{
    KalLogic *logic;
    UITableView *tableView;
    id <UITableViewDelegate> __unsafe_unretained delegate;
    id <KalDataSource> __unsafe_unretained dataSource;
}

@property (nonatomic, unsafe_unretained) id<UITableViewDelegate> delegate;
@property (nonatomic, unsafe_unretained) id<KalDataSource> dataSource;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) KalSelectionMode selectionMode;
@property (nonatomic, strong) NSDate *minAvailableDate;
@property (nonatomic, strong) NSDate *maxAVailableDate;
@property (nonatomic, strong) NSDictionary *productDict;

- (id)initWithSelectionMode:(KalSelectionMode)selectionMode;
- (void)reloadData;                                 // If you change the KalDataSource after the KalViewController has already been displayed to the user, you must call this method in order for the view to reflect the new data.
- (void)showAndSelectDate:(NSDate *)date;           // Updates the state of the calendar to display the specified date's month and selects the tile for that date.


@end
