//
//  FirstViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "FoodListController.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFRestAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "Restaurant.h"
#import "Category.h"
#import "Recipe.h"
#import "RecipeTableViewCell.h"
@interface FoodListController ()

@end

@implementation FoodListController
@synthesize rid,table,allCatagores;
-(id)init{
    self=[super init];
    if (self) {
        [self.view setFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-49-45)];
        table=[[UITableView alloc] initWithFrame:self.view.frame];
        table.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIImageView *tableBgView=[[UIImageView alloc] initWithFrame:table.frame];
        [tableBgView setImage:[UIImage imageNamed:@"recipeTableViewBg"]];
        table.backgroundView=tableBgView;
        [tableBgView release];
        table.dataSource=self;
        table.delegate=self;
        [self.view addSubview:table];
        allCatagores=[[NSMutableArray alloc] init];
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.allCatagores.count!=0) {
        return;
    }
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *pathCategory=[NSString stringWithFormat:@"restaurants/%d/categories",self.rid];
    NSString *pathRepice=[NSString stringWithFormat:@"restaurants/%d/recipes",self.rid];
    NSString *udid=[ud objectForKey:@"udid"];
    [[AFRestAPIClient sharedClient] setDefaultHeader:@"X-device" value:udid];
    //请求所有菜种类
    [[AFRestAPIClient sharedClient] getPath:pathCategory parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"返回头: %@", [operation.response allHeaderFields]);
        NSArray *list = (NSArray*)responseObject;
        for (int i=0; i<list.count;i++) {
            NSDictionary *dn=[list objectAtIndex:i];
            Category *category=[[Category alloc] initWithDictionary:dn];
            [allCatagores addObject:category];
            [category release];
        }
        //请求所有菜
        [[AFRestAPIClient sharedClient] getPath:pathRepice parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *list = (NSArray*)responseObject;
            for (int i=0; i<list.count;i++) {
                NSDictionary *dn=[list objectAtIndex:i];
                Recipe *recipe=[[Recipe alloc] initWithDictionary:dn];
                for (Category *category in allCatagores) {
                    if (recipe.cid==category.cid) {
                        [category.allRecipes addObject:recipe];
                    }
                }
                [recipe release];
            }
            [table reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"错误: %@", error);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  allCatagores.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Category *category=[allCatagores objectAtIndex:section];
    return category.allRecipes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Category *category=[allCatagores objectAtIndex:indexPath.section];
    Recipe *recipe=[category.allRecipes objectAtIndex:indexPath.row];
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[[RecipeTableViewCell alloc]
				 initWithStyle:UITableViewCellStyleSubtitle
				 reuseIdentifier:SectionsTableIdentifier] autorelease];
    }
    cell.recipe=recipe;

//取消边框线
//
//    [cell setBackgroundView:[[UIView alloc] init]];          //取消边框线
//    cell.backgroundColor = [UIColor clearColor];
//    cell.textLabel.text=recipe.name;
//    cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2f",recipe.price];
//    cell.detailTextLabel.contentMode=UIViewContentModeBottomRight;
//    cell.detailTextLabel.textAlignment = UITextAlignmentRight;
//    cell.detailTextLabel.textColor=[UIColor redColor];
//    NSString *imageUrlString=IMAGESERVERADDRESS;
//    imageUrlString=[NSString stringWithFormat:@"%@%@",imageUrlString,recipe.imageUrl];
//    [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrlString]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    NSMutableArray *array=[[[NSMutableArray alloc] init] autorelease];
//    for (Category *category in allCatagores) {
//        [array addObject:category.name];
//    }
//    return array ;
//}
//- (NSString *)tableView:(UITableView *)tableView
//titleForHeaderInSection:(NSInteger)section {
//    Category *category=[allCatagores objectAtIndex:section];
//    return category.name;
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[[UIView alloc] init] autorelease];
    UIImageView* customView = [[UIImageView alloc] init];
    [customView setImage:[UIImage imageNamed:@"restaurantTableHeadBg"]];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    Category *category=[allCatagores objectAtIndex:section];
    headerLabel.text=category.name;
    [headerLabel sizeToFit];
    CGRect rect=headerLabel.frame;
    rect.origin.x=(320.0f-rect.size.width)/2;
    headerLabel.frame=rect;
    [customView setFrame:headerLabel.frame];
    [headerView addSubview:customView];
    [headerView addSubview:headerLabel];
    [customView release];
    [headerLabel release];
    return headerView;
}

-(void)dealloc{
    [table release];
    [allCatagores release];
    [super dealloc];
}

@end
