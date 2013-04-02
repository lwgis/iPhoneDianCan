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
#import "Recipe.h"
#import <QuartzCore/QuartzCore.h>
#import "MessageView.h"
@implementation OrderListController
@synthesize table,currentOrder,allCategores,isUpdating,leftButtonItems,rightItem,tilteLabel;

-(id)init{
    self=[super init];
    if (self) {
        self.title=@"未开台";
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
        [leftButton setTitle:@"下单" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftBarButtonTouch)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        UIButton*leftButtonHide = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButtonHide setFrame:CGRectMake(0, 0, 50, 30)];
        UIBarButtonItem *leftButtonItemHide = [[UIBarButtonItem alloc]initWithCustomView:leftButtonHide];
        self.leftButtonItems=[NSArray arrayWithObjects:leftButtonItem,leftButtonItemHide,nil];
        [leftButtonItemHide release];
        [leftButtonItem release];
        UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(0, 0, 35, 35)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"refreshOrder"]forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(refreshOrder)forControlEvents:UIControlEventTouchUpInside];
        rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        isUpdating=NO;
        CGRect frame = CGRectMake(0, 0, 200, 44);
        tilteLabel = [[UILabel alloc] initWithFrame:frame];
        tilteLabel.numberOfLines=2;
        tilteLabel.backgroundColor = [UIColor clearColor];
        tilteLabel.font = [UIFont boldSystemFontOfSize:17.0];
        tilteLabel.textAlignment = UITextAlignmentCenter;
        tilteLabel.textColor=[UIColor whiteColor];
        self.navigationItem.titleView = tilteLabel;
        tilteLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        tilteLabel.shadowOffset = CGSizeMake(0, -1.0);
    }
    return self;
}
-(void)setTitle:(NSString *)title{
    tilteLabel.text=title;
}
-(void)leftBarButtonTouch{
//    /*
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    [Order rid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
        NSString *message=@"";
        for (OrderItem *oItem in order.orderItems) {
            if (oItem.countNew>0) {
                message=[NSString stringWithFormat:@"%@%@ ---%d份\n",message,oItem.recipe.name,oItem.countNew];
            }
        }
        MyAlertView *myAlert=[[MyAlertView alloc] initWithTitle:@"下单确认" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下单" ,nil];
        [myAlert show];
        [myAlert release];
    } failure:^{
        
    }];
}

- (void)refreshOrder {
    if (isUpdating) {
        return;
    }
    self.table.scrollEnabled=NO;
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    if (oidNum&&ridNum) {
        if (self.navigationItem.rightBarButtonItem==nil) {
            self.navigationItem.rightBarButtonItem= rightItem;
        }
        NSString *pathCategory=[NSString stringWithFormat:@"restaurants/%d/categories",ridNum.integerValue];
        NSString *udid=[ud objectForKey:@"udid"];
        self.table.userInteractionEnabled=NO;
        isUpdating=YES;
        [[AFRestAPIClient sharedClient] setDefaultHeader:@"X-device" value:udid];
        //请求所有菜种类
        [[AFRestAPIClient sharedClient] getPath:pathCategory parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                self.table.userInteractionEnabled=YES;
                self.table.scrollEnabled=YES;

            } failure:^{
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"错误: %@", error);
            MessageView *mv=[[MessageView alloc] initWithMessageText:@"无法连接到服务器"];
            [mv show];

        }];
        
    }
    else{
        [allCategores removeAllObjects];
        [table reloadData];
        self.title=[NSString stringWithFormat:@"未开台"];
        self.navigationItem.rightBarButtonItem= nil;

    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshOrder];
}
-(void)viewWillAppear:(BOOL)animated{
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
        recipeCount=recipeCount+aRecipe.countAll;
    }
    headerLabel.text=[NSString stringWithFormat:@"%@(%d份)",category.name,recipeCount];
    [headerLabel sizeToFit];
    CGRect rect=headerLabel.frame;
    rect.origin.x=(320.0f-rect.size.width)/2;
    rect.size.width+=10;
    headerLabel.frame=rect;
    rect.origin.x-=5;
    [customView setFrame:rect];
    [headerView addSubview:customView];
    [headerView addSubview:headerLabel];
    [customView release];
    [headerLabel release];
    return headerView;
}

- (void)synchronizeOrder:(Order *)order {
    self.currentOrder=order;
    NSInteger newCount=0;
    for (OrderItem *oItem in order.orderItems) {
        oItem.recipe.countNew=oItem.countNew;
        oItem.recipe.countDeposit=oItem.countDeposit;
        oItem.recipe.countConfirm=oItem.countConfirm;
        newCount+=oItem.countNew;
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
    if (newCount>0) {
        self.title=[NSString stringWithFormat:@"总价:￥%.2f\n%d份未下单",order.priceAll,newCount];
        self.navigationItem.leftBarButtonItems= leftButtonItems;
    }
    else{
        self.title=[NSString stringWithFormat:@"总价:￥%.2f",order.priceAll];
        self.navigationItem.leftBarButtonItem= nil;
    }
    [table reloadData];
    [tempArray release];
    isUpdating=NO;

}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        NSNumber *oidNum=[ud valueForKey:@"oid"];
        NSNumber *ridNum=[ud valueForKey:@"rid"];
        [Order OrderWithRid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
            [self refreshOrder];
            
        } failure:^{
        }];    }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.navigationItem.rightBarButtonItem.enabled=NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.navigationItem.rightBarButtonItem.enabled=YES;

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [leftButtonItems release];
    [table release];
    [tilteLabel release];
    [rightItem release];
    [super dealloc];
}
@end
