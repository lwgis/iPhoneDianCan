//
//  SecondViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Order.h"
@interface OrderListController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,retain)UITableView *table;
@property(nonatomic,retain)Order *currentOrder;
@property(nonatomic,retain)NSMutableArray *allCategores;//所有已点种类
@property(nonatomic)BOOL isUpdating;
@property(nonatomic,retain)UIBarButtonItem *leftButtonItem;
@property(nonatomic,retain)UILabel *tilteLabel;
@end
