//
//  HistoryDetailViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-19.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryOrder.h"
@interface HistoryDetailViewController : UITableViewController
@property(nonatomic,assign)HistoryOrder *historyOrder;
@property(nonatomic,retain)NSMutableArray *allOrderItems;
@end
