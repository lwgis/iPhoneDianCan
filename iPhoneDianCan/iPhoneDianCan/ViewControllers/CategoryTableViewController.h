//
//  CategoryTableViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol LocationToCellDelegate;
@interface CategoryTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSMutableArray *allCategores;//所有种类
@property(nonatomic,assign)UITableView *catagoreTableView;//菜类列表
@property(nonatomic,assign)id<LocationToCellDelegate> locationToCellDelegate;
@end 

@protocol LocationToCellDelegate <NSObject>

-(void)LocationToCell:(NSIndexPath *)indexPath;

@end