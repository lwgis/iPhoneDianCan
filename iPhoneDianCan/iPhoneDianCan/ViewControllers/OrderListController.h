//
//  SecondViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Order.h"
#import "BadgeButton.h"
@interface OrderListController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>

@property(nonatomic,retain)UITableView *table;
@property(nonatomic,retain)Order *currentOrder;
@property(nonatomic,retain)NSMutableArray *allCategores;//所有已点种类
@property(nonatomic,retain)UIBarButtonItem *rightItem;
@property(nonatomic,retain)UILabel *tilteLabel;
@property(nonatomic,retain)UIToolbar *toolBarView;
@property(nonatomic,retain)BadgeButton *orderBtn ;
@property(nonatomic)BOOL isUpdating;

@end
