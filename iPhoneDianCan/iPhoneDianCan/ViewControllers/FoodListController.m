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
#import <QuartzCore/QuartzCore.h>
@interface FoodListController ()

@end

@implementation FoodListController

@synthesize rid,table,catagoreTableView,categoryTableViewController,allCategores,currentOrder,panGestureRecognizer,tableCenterPoint;

- (void)addTableShadow {
    [table layer].shadowPath =[UIBezierPath bezierPathWithRect:CGRectMake(table.contentOffset.x, table.contentOffset.y, table.bounds.size.width, table.bounds.size.height)].CGPath;
    [table layer].masksToBounds = NO;
    [[table layer] setShadowOffset:CGSizeMake(-5.0, 0)];
    [[table layer] setShadowRadius:5.0];
    [[table layer] setShadowOpacity:0.5];
    [[table layer] setShadowColor:[UIColor blackColor].CGColor];
}

#pragma mark - LocationCellDelegate
-(void)LocationToCell:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.3 animations:^{
        [table setCenter:CGPointMake(160, table.center.y)];
    } completion:^(BOOL finished) {
        tableCenterPoint=table.center;
        table.scrollEnabled=YES;
        [self.table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }]; }

-(id)initWithRecipe:(Restaurant *)restaurant{
    self=[super init];
    if (self) {
        self.rid=restaurant.rid;
        self.title=restaurant.name;
        [self.view setFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-49-45)];
        categoryTableViewController=[[CategoryTableViewController alloc] init];
        //初始化菜种类
        catagoreTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, SCREENHEIGHT-49-45)];
        catagoreTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIImageView *catagoreTableViewBgView=[[UIImageView alloc] initWithFrame:table.frame];
        [catagoreTableViewBgView setImage:[UIImage imageNamed:@"categoryTableViewBg"]];
        catagoreTableView.backgroundView=catagoreTableViewBgView;
        [catagoreTableViewBgView release];
        [self.view addSubview:catagoreTableView];
        //初始化所有菜列表
        table=[[UITableView alloc] initWithFrame:self.view.frame];
        table.backgroundColor=[UIColor redColor];
        table.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIImageView *tableBgView=[[UIImageView alloc] initWithFrame:table.frame];
        [tableBgView setImage:[UIImage imageNamed:@"recipeTableViewBg"]];
        [self addTableShadow];
        table.backgroundView=tableBgView;
        [tableBgView release];
        table.dataSource=self;
        table.delegate=self;
        [self.view addSubview:table];
        allCategores=[[NSMutableArray alloc] init];
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

-(void)leftBarButtonTouch{
    if (tableCenterPoint.x==160) {
            [UIView animateWithDuration:0.3 animations:^{
                [table setCenter:CGPointMake(360, table.center.y)];
            } completion:^(BOOL finished) {
                tableCenterPoint=table.center;
                table.scrollEnabled=NO;
            }];
    }
    else{
            [UIView animateWithDuration:0.3 animations:^{
                [table setCenter:CGPointMake(160, table.center.y)];
            } completion:^(BOOL finished) {
                tableCenterPoint=table.center;
                table.scrollEnabled=YES;
            }];
    }

}

- (void)synchronizeOrder:(Order *)order {
    self.currentOrder=order;
    for (Category *category in self.allCategores) {
        for (Recipe *recipe in category.allRecipes) {
            recipe.countNew=0;
            recipe.countDeposit=0;
            recipe.countConfirm=0;
        }
    }
    for (Category *category in self.allCategores) {
        for (Recipe *recipe in category.allRecipes) {
            for (OrderItem *oItem in self.currentOrder.orderItems) {
                if (recipe.rid==oItem.recipe.rid) {
                    recipe.countNew=oItem.countNew;
                    recipe.countDeposit=oItem.countDeposit;
                    recipe.countConfirm=oItem.countConfirm;
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
            [allCategores addObject:category];
            [category release];
        }
        categoryTableViewController.allCategores=allCategores;
        categoryTableViewController.catagoreTableView=catagoreTableView;
        catagoreTableView.dataSource=categoryTableViewController;
        catagoreTableView.delegate=categoryTableViewController;
        [catagoreTableView reloadData];
        categoryTableViewController.locationToCellDelegate=self;
        //请求所有菜
        [[AFRestAPIClient sharedClient] getPath:pathRepice parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *list = (NSArray*)responseObject;
            for (int i=0; i<list.count;i++) {
                NSDictionary *dn=[list objectAtIndex:i];
                Recipe *recipe=[[Recipe alloc] initWithDictionary:dn];
                for (Category *category in allCategores) {
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
                    UIButton*leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [leftButton setFrame:CGRectMake(0, 0, 50, 30)];
                    [leftButton setBackgroundImage:[UIImage imageNamed:@"navRightBtn"]forState:UIControlStateNormal];
                    [leftButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
                    [leftButton setTitle:@"种类" forState:UIControlStateNormal];
                    [leftButton addTarget:self action:@selector(leftBarButtonTouch)forControlEvents:UIControlEventTouchUpInside];
                    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
                    self.navigationItem.leftBarButtonItem= leftItem;
                    [leftItem release];
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
    panGestureRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragTableView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    if (oidNum!=nil) {
        [self.navigationItem setHidesBackButton:YES];
    }
    [self refreshOrder];
    [super viewWillAppear:animated];
  }

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    tableCenterPoint=table.center;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 拖动菜列表
-(void)dragTableView:(UIPanGestureRecognizer *)rec{
    CGPoint point = [rec translationInView:self.view];
    if (table.center.x<160) {
        return;
    }
    [rec setTranslation:CGPointMake(0, 0) inView:self.view];
    if((table.center.x + point.x)>160)
    table.center = CGPointMake(table.center.x + point.x, table.center.y);
    
    if (rec.state==UIGestureRecognizerStateEnded) {
        if (tableCenterPoint.x==160) {
            if ((table.center.x-tableCenterPoint.x)>40) {
                [UIView animateWithDuration:0.1*200/abs(table.center.x-tableCenterPoint.x) animations:^{
                    [table setCenter:CGPointMake(360, table.center.y)];
                } completion:^(BOOL finished) {
                    tableCenterPoint=table.center;
                    table.scrollEnabled=NO;
                }];
            }
            else{
                [UIView animateWithDuration:0.5*abs(table.center.x-tableCenterPoint.x)/40 animations:^{
                    [table setCenter:CGPointMake(160, table.center.y)];
                } completion:^(BOOL finished) {
                    tableCenterPoint=table.center;
                    table.scrollEnabled=YES;
                }];

            }
        }
        else{
            if ((table.center.x-tableCenterPoint.x)<-40) {
                [UIView animateWithDuration:0.1*200/abs(table.center.x-tableCenterPoint.x) animations:^{
                    [table setCenter:CGPointMake(160, table.center.y)];
                } completion:^(BOOL finished) {
                    tableCenterPoint=table.center;
                    table.scrollEnabled=YES;
                }];
            }
            else{
                [UIView animateWithDuration:0.5*abs(table.center.x-tableCenterPoint.x)/40  animations:^{
                    [table setCenter:CGPointMake(360, table.center.y)];
                } completion:^(BOOL finished) {
                    tableCenterPoint=table.center;
                    table.scrollEnabled=NO;
                }];
            }
        }
    }
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return  allCategores.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Category *category=[allCategores objectAtIndex:section];
    return category.allRecipes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Category *category=[allCategores objectAtIndex:indexPath.section];
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
    Category *category=[allCategores objectAtIndex:section];
    headerLabel.text=[NSString stringWithFormat:@"%@(%d)", category.name,category.allRecipes.count];
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
            [rightButton setFrame:CGRectMake(0, 0, 45, 35)];
            [rightButton setBackgroundImage:[UIImage imageNamed:@"refreshOrder"]forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(refreshOrder)forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
            self.navigationItem.rightBarButtonItem= rightItem;
            [rightItem release];
            [self synchronizeOrder:order];
            self.title=[NSString stringWithFormat:@"%@-%@",self.title,order.desk.name];
            UIButton*leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [leftButton setFrame:CGRectMake(0, 0, 50, 30)];
            [leftButton setBackgroundImage:[UIImage imageNamed:@"navRightBtn"]forState:UIControlStateNormal];
            [leftButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
            [leftButton setTitle:@"种类" forState:UIControlStateNormal];
            [leftButton addTarget:self action:@selector(leftBarButtonTouch)forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
            self.navigationItem.leftBarButtonItem= leftItem;
            [leftItem release];

        } failure:^{
        }];
    }
    else{
        
    }
}

//刷新菜单
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self addTableShadow];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

-(void)dealloc{
    [table release];
    [catagoreTableView release];
    [categoryTableViewController release];
    [allCategores release];
    [currentOrder release];
    [panGestureRecognizer release];
    [super dealloc];
}

@end
