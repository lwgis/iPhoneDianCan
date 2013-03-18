//
//  FirstViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//
@class Order;
@class Restaurant;
#import <UIKit/UIKit.h>
#import "CategoryTableViewController.h"
#import "RecipeSearchControllerViewController.h"
@interface FoodListController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate,LocationToCellDelegate,UIGestureRecognizerDelegate>
@property NSInteger rid;// 餐厅id
@property(nonatomic,retain)UITableView *table;//所有菜列表
@property(nonatomic,retain)UITableView *categoreTableView;//菜类列表
@property(nonatomic,retain)CategoryTableViewController *categoryTableViewController;
@property(nonatomic,retain)NSMutableArray *allCategores;//所有种类
@property(nonatomic,retain)Order *currentOrder;
//@property(nonatomic,retain)UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic)CGPoint tableCenterPoint;
@property(nonatomic,retain)UISearchBar *searchBar;
@property(nonatomic,retain)RecipeSearchControllerViewController *recipeSearchControllerViewController;
@property(nonatomic,retain)NSArray *leftButtonItems;
-(id)initWithRecipe:(Restaurant *)restaurant;
- (void)synchronizeOrder:(Order *)order ;
@end
