//
//  FirstViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodListController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property NSInteger rid;// 餐厅id
@property(nonatomic,retain)UITableView *table;
@property(nonatomic,retain)NSMutableArray *allCatagores;//所有种类
@end
