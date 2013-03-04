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
#import "MyAlertView.h"
#import "AppDelegate.h"

@implementation OrderListController
@synthesize table,currentOrder,allCategores;

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
        allCategores =[[NSMutableArray alloc] init];
        UIButton*leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(0, 0, 50, 30)];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"navRightBtn"]forState:UIControlStateNormal];
        [leftButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        [leftButton setTitle:@"结账" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftBarButtonTouch)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem= leftItem;
        [leftItem release];
        UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(0, 0, 35, 35)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"refreshOrder"]forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(refreshOrder)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem= rightItem;
        [rightItem release];
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
            }
    return self;
}

-(void)leftBarButtonTouch{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    [Order rid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
        NSString *message=[NSString stringWithFormat:@"您总共消费￥%.2f",order.price];
        MyAlertView *myAlert=[[MyAlertView alloc] initWithTitle:@"结账确认" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"结账" ,nil];
        [myAlert show];
        [myAlert release];
    } failure:^{
        
    }];
}

- (void)refreshOrder {
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
            [allCategores removeAllObjects];
            NSArray *list = (NSArray*)responseObject;
            for (int i=0; i<list.count;i++) {
                NSDictionary *dn=[list objectAtIndex:i];
                Category *category=[[Category alloc] initWithDictionary:dn];
                [allCategores addObject:category];
                [category release];
            }
            [Order rid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
                [self synchronizeOrder:order];
                [self.navigationItem.leftBarButtonItem setEnabled:YES];
            } failure:^{
                [self.navigationItem.leftBarButtonItem setEnabled:NO];
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"错误: %@", error);
            
        }];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self refreshOrder];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return allCategores.count;
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
    Category *category=[allCategores objectAtIndex:section];
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
    self.title=[NSString stringWithFormat:@"总价：￥%.2f",order.price];
    for (OrderItem *oItem in order.orderItems) {
        oItem.recipe.orderedCount=oItem.count;
        for (Category *category in allCategores) {
            if (oItem.recipe.cid==category.cid) {
                [category.allRecipes addObject:oItem.recipe];
            }
        }
    }
    NSMutableArray *tempArray=[allCategores copy];
    [allCategores removeAllObjects];
    for (Category *category in tempArray) {
        if (category.allRecipes.count>0) {
            [allCategores addObject:category];
        }
    }
    [table reloadData];
    [tempArray release];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        NSNumber *oidNum=[ud valueForKey:@"oid"];
        NSNumber *ridNum=[ud valueForKey:@"rid"];
        [Order CheckOrderWithRid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
            [ud removeObjectForKey:@"oid"];
            [ud removeObjectForKey:@"rid"];
            [ud synchronize];
        [allCategores removeAllObjects];
        [table reloadData];
        self.title=@"";
        AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.tabBarController.selectedIndex=0;
        UINavigationController *nav=(UINavigationController *)[[appDelegate.tabBarController viewControllers] objectAtIndex:0];
        [nav popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:KBadgeNotification object:0];
        [appDelegate.tabView reSetting];
        } failure:^{
    
        }];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [table release];
    [super dealloc];
}
@end
