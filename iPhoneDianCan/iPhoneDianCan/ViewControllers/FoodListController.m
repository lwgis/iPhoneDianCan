//
//  FirstViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "FoodListController.h"
#import "AFRestAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "Restaurant.h"
#import "Category.h"
#import "Recipe.h"
#import "RecipeTableViewCell.h"
#import "TextAlertView.h"
#import "Order.h"
#import "OrderItem.h"
#import "Desk.h"
@interface FoodListController ()

@end

@implementation FoodListController

@synthesize rid,table,allCatagores,currentOrder;

-(id)initWithRecipe:(Restaurant *)restaurant{
    self=[super init];
    if (self) {
        self.rid=restaurant.rid;
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
        //初始化右边按钮
        UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(0, 0, 50, 30)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"navRightBtn"]forState:UIControlStateNormal];
        [rightButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        [rightButton setTitle:@"开台" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightBarButtonTouch)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem= rightItem;
        [rightItem release];
    }
    return self;

}

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
        //初始化右边按钮
        UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(0, 0, 50, 30)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"navRightBtn"]forState:UIControlStateNormal];
        [rightButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        [rightButton setTitle:@"开台" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightBarButtonTouch)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem= rightItem;
        [rightItem release];
    }
    return self;
}

-(void)rightBarButtonTouch{
    TextAlertView *tat=[[TextAlertView alloc] init];
    [tat setDelegate:self];
    [tat show];
    [tat release];
}

- (void)synchronizeOrder:(Order *)order {
    self.currentOrder=order;
    for (Category *category in self.allCatagores) {
        for (Recipe *recipe in category.allRecipes) {
            for (OrderItem *oItem in self.currentOrder.orderItems) {
                if (recipe.rid==oItem.recipe.rid) {
                    recipe.orderedCount=oItem.count;
                }
            }
        }
    }
    [table reloadData];
}

-(void)viewDidLoad{
    [super viewDidLoad];
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
            NSNumber *oidNum=[ud valueForKey:@"oid"];
            if (oidNum!=nil) {
                [Order rid:self.rid Oid:oidNum.integerValue Order:^(Order *order) {
                    [self.navigationItem setHidesBackButton:YES];
                    [self synchronizeOrder:order];
                    UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [rightButton setFrame:CGRectMake(0, 0, 35, 35)];
                    [rightButton setBackgroundImage:[UIImage imageNamed:@"refreshOrder"]forState:UIControlStateNormal];
                    [rightButton addTarget:self action:@selector(refreshOrder)forControlEvents:UIControlEventTouchUpInside];
                    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
                    self.navigationItem.rightBarButtonItem= rightItem;
                    [rightItem release];
                    self.title=[NSString stringWithFormat:@"%@-%@",self.title,order.desk.name];
                } failure:^{
                    [table reloadData];
                }];
            }
            else{
                [table reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"错误: %@", error);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    if (oidNum!=nil) {
        [self.navigationItem setHidesBackButton:YES];
    }

    [super viewWillAppear:animated];
  }

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning{
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

#pragma mark -
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        TextAlertView *tav=(TextAlertView *)alertView;
        [Order rid:self.rid Code:tav.code Order:^(Order *order) {
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
            NSNumber *numoid=[NSNumber numberWithInteger:order.oid];
            [ud setValue:numoid forKey:@"oid"];
            NSNumber *numrid=[NSNumber numberWithInteger:self.rid];
            [ud setValue:numrid forKey:@"rid"];
            [ud synchronize];
            [self.navigationItem setHidesBackButton:YES];
            self.currentOrder=order;
            UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightButton setFrame:CGRectMake(0, 0, 35, 35)];
            [rightButton setBackgroundImage:[UIImage imageNamed:@"refreshOrder"]forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(refreshOrder)forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
            self.navigationItem.rightBarButtonItem= rightItem;
            [rightItem release];
            [self synchronizeOrder:order];
            self.title=[NSString stringWithFormat:@"%@-%@",self.title,order.desk.name];
        } failure:^{
        }];
    }
    else{
        
    }
}
-(void)refreshOrder{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    if (oidNum!=nil) {
        [Order rid:self.rid Oid:oidNum.integerValue Order:^(Order *order) {
            [self synchronizeOrder:order];
        } failure:^{
        }];
    }
}
-(void)dealloc{
    [table release];
    [allCatagores release];
    [currentOrder release];
    [super dealloc];
}

@end
