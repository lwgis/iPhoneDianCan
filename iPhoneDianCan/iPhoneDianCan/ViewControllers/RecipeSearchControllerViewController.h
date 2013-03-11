//
//  RecipeSearchControllerViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-11.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTableViewController.h"
@interface RecipeSearchControllerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate>
@property(nonatomic,assign)NSMutableArray *allCategores;//所有种类
@property(nonatomic,retain)NSMutableArray *allRecipes;
@property(nonatomic,retain)NSMutableArray *allIndexPaths;
@property(nonatomic,assign)UISearchBar *searchBar;
@property(nonatomic,retain)UITableView *searchResultTable;
@property(nonatomic,assign)UITableView *categoreTableView;//菜类列表
@property(nonatomic,assign)id<LocationToCellDelegate> locationToCellDelegate;
@end
