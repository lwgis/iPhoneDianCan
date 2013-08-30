//
//  RecentBrowseViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-26.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RecentBrowseViewController.h"
#import "Restaurant.h"
#import "FoodListController.h"
#import "UIImageView+AFNetworking.h"
#import "RestaurantCell.h"
#import "AFRestAPIClient.h"
#import "MessageView.h"
@interface RecentBrowseViewController ()

@end

@implementation RecentBrowseViewController
@synthesize allRestaurants,alldates;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title=@"最近浏览";
        // 下一个界面的返回按钮
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"返回";
        [temporaryBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];
        //初始化tableView
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recipeTableViewBg"]];
        self.tableView.backgroundView = bgImageView;
        [bgImageView release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [alldates release];
    [allRestaurants release];
    NSUserDefaults *us=[NSUserDefaults standardUserDefaults];
    NSDictionary *recentBrowse=[us objectForKey:@"recentBrowse"];
    NSArray *dates=[recentBrowse.allKeys sortedArrayUsingSelector:@selector(compare:)]; //[[NSMutableArray alloc] initWithArray:recentBrowse.allKeys];
    alldates=[[NSMutableArray alloc] init];
    for (int i=dates.count-1; i>=0; i--) {
        [alldates addObject:[dates objectAtIndex:i]];
    }
    allRestaurants=[[NSMutableArray alloc] init];
    for (NSString *str in alldates) {
        NSDictionary *dic=[recentBrowse valueForKey:str];
        Restaurant *restaurant=[[Restaurant alloc] initWithDictionary:dic];
        [allRestaurants addObject:restaurant];
        [restaurant release];
    }
    [[AFRestAPIClient sharedClient] getPath:@"user/favorites" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr=(NSArray *)responseObject;
        for (Restaurant *res in allRestaurants) {
            for (NSDictionary *dic in arr) {
                NSString *ridStr=(NSString *)[dic valueForKey:@"rid"];
                if (res.rid==[ridStr integerValue]) {
                    res.isFavorite=YES;
                }
            }
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView reloadData];
//        MessageView *mv=[MessageView messageViewWithMessageText:@"您还没有浏览过任何餐厅"];
//        [mv show];
    }];
    if (allRestaurants.count==0) {
        MessageView *mv=[MessageView messageViewWithMessageText:@"您还没有浏览过任何餐厅"];
        [mv show];
        
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (allRestaurants==nil) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return allRestaurants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    static NSString *CellIdentifier = @"SectionsTableIdentifier";
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 CellIdentifier];

    if (cell == nil) {
        cell = [[[RestaurantCell alloc]
				 initWithStyle:UITableViewCellStyleSubtitle
				 reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor=[UIColor grayColor];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurantTableCellBg"]];
        cell.backgroundView = bgImageView;
        cell.textLabel.backgroundColor=[UIColor clearColor];
        [bgImageView release];
        UIImageView *selectBgImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categoryTablecellSelectBg"]];
        cell.selectedBackgroundView=selectBgImageView;
        [selectBgImageView release];
    }
    Restaurant *restaurant=[self.allRestaurants objectAtIndex:indexPath.row];
    cell.restaurant=restaurant;
    NSString *dateStr=[alldates objectAtIndex:indexPath.row];
    NSRange range;
    range.length=dateStr.length-6;
    range.location=0;
    cell.detailTextLabel.text=[dateStr substringWithRange:range];
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushToFoodList:indexPath.row];
    [self performSelector:@selector(unselectCurrentRow)
               withObject:nil afterDelay:1.0];

}

//跳转到菜单列表
- (void)pushToFoodList:(NSInteger)row {
    Restaurant *restaurant=[allRestaurants objectAtIndex:row];
    NSUserDefaults *us=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionary=[us valueForKey:@"recentBrowse"];
    NSMutableDictionary *recentBrowse=[[NSMutableDictionary alloc] initWithDictionary:dictionary];
    if (recentBrowse!=nil) {
        for (NSString *key in recentBrowse.allKeys) {
            NSDictionary *dic=[recentBrowse objectForKey:key];
            NSString *ridString=[dic valueForKey:@"id"];
            NSNumber *ridNum=[NSNumber numberWithInteger:[ridString integerValue]];
            if (ridNum.integerValue==restaurant.rid) {
                [recentBrowse removeObjectForKey:key];
            }
        }
    }
    NSString *dateStr=[NSString stringWithFormat:@"%@",[NSDate date]];
    [recentBrowse setObject:restaurant.restaurantDictionary forKey:dateStr];
    [us setValue:recentBrowse forKey:@"recentBrowse"];
    [us synchronize];
    [recentBrowse release];
    FoodListController*foodListController=[[FoodListController alloc] initWithRecipe:restaurant];
    [self.navigationController pushViewController:foodListController animated:YES];
    [foodListController release];
}

- (void) unselectCurrentRow{
    // Animate the deselection
    [self.tableView deselectRowAtIndexPath:
     [self.tableView indexPathForSelectedRow] animated:YES];
}


-(void)dealloc{
    [allRestaurants release];
    [alldates release];
    [super dealloc];
}
@end
