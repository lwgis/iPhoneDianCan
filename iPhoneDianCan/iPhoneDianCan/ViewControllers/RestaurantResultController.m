//
//  RestaurantResultController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-12.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RestaurantResultController.h"
#import "Restaurant.h"
#import "RestaurantCell.h"
@implementation RestaurantResultController
@synthesize resultRestaurants;
-(id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController{
    self=[super initWithSearchBar:searchBar contentsController:viewController];
    if (self) {
        self.searchResultsDataSource=self;
        self.searchResultsDelegate=self;
        resultRestaurants=[[NSMutableArray alloc] init];
    }
    return self;
}
#pragma mark - UITableView DataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    self.searchResultsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapTableViewBg"]];
    self.searchResultsTableView.backgroundView = bgImageView;
    [bgImageView release];
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resultRestaurants.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[[RestaurantCell alloc]
				 initWithStyle:UITableViewCellStyleSubtitle
				 reuseIdentifier:SectionsTableIdentifier] autorelease];
        cell.backgroundColor=[UIColor grayColor];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurantTableCellBg"]];
        cell.backgroundView = bgImageView;
        [bgImageView release];
        UIImageView *selectBgImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categoryTablecellSelectBg"]];
        cell.selectedBackgroundView=selectBgImageView;
        [selectBgImageView release];
        cell.textLabel.backgroundColor=[UIColor clearColor];
    }
    Restaurant *restaurant=[self.resultRestaurants objectAtIndex:row];
    cell.restaurant=restaurant;
    cell.indexPath=indexPath;
     return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self pushToFoodList:indexPath.row];
    [self performSelector:@selector(unselectCurrentRow)
               withObject:nil afterDelay:1.0];
}


-(void)showDetails:(UIButton *)sender{
    [self pushToFoodList:sender.tag];
}
- (void) unselectCurrentRow{
    // Animate the deselection
    [self.searchResultsTableView deselectRowAtIndexPath:
     [self.searchResultsTableView indexPathForSelectedRow] animated:YES];
}
//跳转到菜单列表
- (void)pushToFoodList:(NSInteger)row {
    Restaurant *restaurant=[resultRestaurants objectAtIndex:row];
    FoodListController*foodListController=[[FoodListController alloc] initWithRecipe:restaurant];

    [self.searchContentsController.navigationController pushViewController:foodListController animated:YES];
    [foodListController release];
}
-(void)dealloc{
    [resultRestaurants release];
    [super dealloc];
}
@end
