//
//  SecondViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "OrderListController.h"
#import "AFRestAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "Category.h"
#import "RecipeTableViewCell.h"
#import "OrderItem.h"
#import "Category.h"
@interface OrderListController ()

@end

@implementation OrderListController
@synthesize table,currentOrder,allCatagores;

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
        allCatagores =[[NSMutableArray alloc] init];
            }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    if (oidNum&&ridNum) {
        NSString *pathCategory=[NSString stringWithFormat:@"restaurants/%d/categories",ridNum.integerValue];
        NSString *udid=[ud objectForKey:@"udid"];
        [[AFRestAPIClient sharedClient] setDefaultHeader:@"X-device" value:udid];
        //请求所有菜种类
        [[AFRestAPIClient sharedClient] getPath:pathCategory parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"返回头: %@", [operation.response allHeaderFields]);
            [allCatagores removeAllObjects];
            NSArray *list = (NSArray*)responseObject;
            for (int i=0; i<list.count;i++) {
                NSDictionary *dn=[list objectAtIndex:i];
                Category *category=[[Category alloc] initWithDictionary:dn];
                [allCatagores addObject:category];
                [category release];
            }
        [Order rid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
            [self synchronizeOrder:order];
        } failure:^{
            
        }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"错误: %@", error);
            
        }];

    }
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return allCatagores.count;
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
    cell.indexPath =indexPath;
    cell.isAllowRemoveCell=YES;
    cell.recipe=recipe;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[[UIView alloc] init] autorelease];
    UIImageView* customView = [[UIImageView alloc] init];
    [customView setImage:[UIImage imageNamed:@"restaurantTableHeadBg"]];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    Category *category=[allCatagores objectAtIndex:section];
    NSInteger recipeCount=0;
    for (Recipe *aRecipe in category.allRecipes) {
        recipeCount=recipeCount+aRecipe.orderedCount;
    }
    headerLabel.text=[NSString stringWithFormat:@"%@(%d份)",category.name,recipeCount];
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


- (void)synchronizeOrder:(Order *)order {
    self.currentOrder=order;
    for (OrderItem *oItem in order.orderItems) {
        oItem.recipe.orderedCount=oItem.count;
        for (Category *category in allCatagores) {
            if (oItem.recipe.cid==category.cid) {
                [category.allRecipes addObject:oItem.recipe];
            }
        }
    }
    NSMutableArray *tempArray=[allCatagores copy];
    [allCatagores removeAllObjects];
    for (Category *category in tempArray) {
        if (category.allRecipes.count>0) {
            [allCatagores addObject:category];
        }
    }
    [table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [table release];
    [super dealloc];
}
@end
