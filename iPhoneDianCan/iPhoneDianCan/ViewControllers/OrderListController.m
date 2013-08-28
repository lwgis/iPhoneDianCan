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
@synthesize table,currentOrder,allCategores,isUpdating,rightItem,tilteLabel,toolBarView,orderBtn;

-(id)init{
    self=[super init];
    if (self) {
        [self.view setFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-44-44)];
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
        
        toolBarView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-44-44, 320, 44)];
        [toolBarView setBackgroundImage:[UIImage imageNamed:@"CustomizedNavBg"] forToolbarPosition:0 barMetrics:0];
        UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [payBtn setFrame:CGRectMake(10, 2, 140, 40)];
        [payBtn setBackgroundImage:[UIImage imageNamed:@"payToolBtn"]forState:UIControlStateNormal];
         self.orderBtn = [BadgeButton buttonWithType:UIButtonTypeCustom];
        [orderBtn addTarget:self action:@selector(orderBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [orderBtn setFrame:CGRectMake(170, 2, 140, 40)];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"orderToolBtn"]forState:UIControlStateNormal];
        [toolBarView addSubview:payBtn];
        [toolBarView addSubview:orderBtn];
        [self.view addSubview:toolBarView];

    }
    return self;
}

-(void)payBtnClick{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    [Order rid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
        NSString *message=[NSString stringWithFormat:@"您总共消费￥%.2f",order.priceDeposit];
        MyAlertView *myAlert=[[MyAlertView alloc] initWithTitle:@"结账确认" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"结账" ,nil];
        myAlert.tag=0;
        [myAlert show];
        [myAlert release];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }];
}

-(void)setTitle:(NSString *)title{
    tilteLabel.text=title;
}
-(void)orderBtnClick{
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
        myAlert.tag=1;
        [myAlert show];
        [myAlert release];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
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
                if (order.status>2) {
                    MessageView *mv=[MessageView messageViewWithMessageText:@"该订单已经申请结账了！"];
                    [mv show];
                    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                    [ud removeObjectForKey:@"oid"];
                    [ud synchronize];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [self synchronizeOrder:order];
                self.table.userInteractionEnabled=YES;
                self.table.scrollEnabled=YES;

            } failure:^(AFHTTPRequestOperation *operation, NSError *error){
       
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"错误: %@", error);
            MessageView *mv=[MessageView messageViewWithMessageText:@"无法连接到服务器"];
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
        orderBtn.enabled=YES;
        [orderBtn setBadgeValue:newCount];
    }
    else{
        self.title=[NSString stringWithFormat:@"总价:￥%.2f",order.priceAll];
        orderBtn.enabled=NO;
        [orderBtn setBadgeValue:0];
    }
    [table reloadData];
    [tempArray release];
    isUpdating=NO;

}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView.tag==0) {
            [self.navigationItem.leftBarButtonItem setEnabled:NO];
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
           NSNumber *oidNum=[ud valueForKey:@"oid"];
           NSNumber *ridNum=[ud valueForKey:@"rid"];
           [Order CheckOrderWithRid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
            [ud removeObjectForKey:@"oid"];
            [ud removeObjectForKey:@"rid"];
            [ud synchronize];
            self.title=@"";
            AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            UINavigationController *nav=(UINavigationController *)appDelegate.window.rootViewController;
            [nav popToRootViewControllerAnimated:YES];
           } failure:^(AFHTTPRequestOperation *operation, NSError *error){
               AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
               UINavigationController *nav=(UINavigationController *)appDelegate.window.rootViewController;
               [nav popToRootViewControllerAnimated:YES];
           }];
        }
        if (alertView.tag==1) {
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
            NSNumber *oidNum=[ud valueForKey:@"oid"];
            NSNumber *ridNum=[ud valueForKey:@"rid"];
            [Order OrderWithRid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
                [self refreshOrder];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            }];
        }
          }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.navigationItem.rightBarButtonItem.enabled=NO;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.navigationItem.rightBarButtonItem.enabled=YES;

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [table release];
    [tilteLabel release];
    [rightItem release];
    [toolBarView release];
    [currentOrder release];
    [allCategores release];
    [orderBtn release];
    [super dealloc];
}
@end
