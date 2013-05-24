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
#import "MessageView.h"
#import "OrderListController.h"
#import "AppDelegate.h"
#import "MyAlertView.h"
@interface FoodListController ()

@end

@implementation FoodListController

@synthesize rid,table,categoreTableView,categoryTableViewController,allCategores,currentOrder,tableCenterPoint,searchBar,recipeSearchControllerViewController,toolBarView,orderBtn,waiterBtn;

- (void)addTableShadow {
    [table layer].shadowPath =[UIBezierPath bezierPathWithRect:CGRectMake(table.contentOffset.x, table.contentOffset.y, table.bounds.size.width, table.bounds.size.height)].CGPath;
    [table layer].masksToBounds = NO;
    [[table layer] setShadowOffset:CGSizeMake(-5.0, 0)];
    [[table layer] setShadowRadius:5.0];
    [[table layer] setShadowOpacity:0.5];
    [[table layer] setShadowColor:[UIColor blackColor].CGColor];
}

#pragma mark - LocationCellDelegate
-(void)locationToCell:(NSIndexPath *)indexPath{
    [self.searchBar resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [table setCenter:CGPointMake(160, table.center.y)];
    } completion:^(BOOL finished) {
        tableCenterPoint=table.center;
        table.scrollEnabled=YES;
        [self.table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }]; }
-(void)hideSearchBar{
    if (searchBar.text.length==0) {
        [self.recipeSearchControllerViewController.shadowView removeFromSuperview];
        [self.searchBar resignFirstResponder];
    }
}

-(id)initWithRecipe:(Restaurant *)restaurant{
    self=[super init];
    if (self) {
        self.rid=restaurant.rid;
        self.title=restaurant.name;
        [self.view setFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-TABBARHEIGHT-44)];
        UIView *bgView=[[UIView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:bgView];
        //初始化菜种类
        categoryTableViewController=[[CategoryTableViewController alloc] init];
        categoreTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 35, 200, SCREENHEIGHT-TABBARHEIGHT-45)];
        categoreTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIImageView *catagoreTableViewBgView=[[UIImageView alloc] initWithFrame:table.frame];
        [catagoreTableViewBgView setImage:[UIImage imageNamed:@"categoryTableViewBg"]];
        categoreTableView.backgroundView=catagoreTableViewBgView;
        [catagoreTableViewBgView release];
        [bgView addSubview:categoreTableView];
       
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
        UIPanGestureRecognizer *panGestureRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragTableView:)];
        panGestureRecognizer.delegate=self;
        [self.table addGestureRecognizer:panGestureRecognizer];
        [panGestureRecognizer release];
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
        //初始化搜索
        recipeSearchControllerViewController=[[RecipeSearchControllerViewController alloc] init];
        searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 5, categoreTableView.frame.size.width-3, 30)];
        searchBar.placeholder=@"输入菜名或简拼";
        recipeSearchControllerViewController.searchBar=self.searchBar;
//        [self.view insertSubview:searchBar belowSubview:table];
        [bgView addSubview:searchBar];
        self.searchBar.backgroundColor=[UIColor clearColor];
        recipeSearchControllerViewController.categoreTableView=self.categoreTableView;
        [bgView release];
        toolBarView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-44-44, 320, 44)];
        [toolBarView setBackgroundImage:[UIImage imageNamed:@"CustomizedNavBg"] forToolbarPosition:0 barMetrics:0];
        self.waiterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [waiterBtn addTarget:self action:@selector(waiterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [waiterBtn setFrame:CGRectMake(10, 2, 140, 40)];
        [waiterBtn setBackgroundImage:[UIImage imageNamed:@"callWaiterToolBtn"]forState:UIControlStateNormal];
        [self.waiterBtn setImage:[UIImage imageNamed:@"calledWaiterToolBtn"] forState:UIControlStateDisabled];
        self.orderBtn = [BadgeButton buttonWithType:UIButtonTypeCustom];
        [orderBtn addTarget:self action:@selector(orderBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [orderBtn setFrame:CGRectMake(170, 2, 140, 40)];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"yidianToolBtn"]forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadge:) name:KBadgeNotification object:nil];
        [toolBarView addSubview:orderBtn];
        [toolBarView addSubview:waiterBtn];
        // 下一个界面的返回按钮
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"返回";
        [temporaryBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];

    }
    return self;

}
-(void)updateBadge:(NSNotification *)notification{
    NSNumber *num=(NSNumber *)notification.object;
    self.orderBtn.badgeValue=num.integerValue;
}

-(void)orderBtnClick{
    OrderListController *orderListController = [[OrderListController alloc] init];
    [self.navigationController pushViewController:orderListController animated:YES];
    [orderListController release];
}

-(void)waiterBtnClick{
    MyAlertView *myAlert=[[MyAlertView alloc] initWithTitle:@"提示" message:@"您是要呼叫服务员吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫" ,nil];
    [myAlert show];
    [myAlert release];


}
-(void)rightBarButtonTouch{
    TextAlertView *tat=[[TextAlertView alloc] init];
    [tat setDelegate:self];
    [tat show];
    [tat release];
}

-(void)leftBarButtonTouch{
    [self.searchBar resignFirstResponder];
//    self.searchBar.text=nil;
//    [self.recipeSearchControllerViewController.searchResultTable removeFromSuperview];
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
        categoryTableViewController.categoreTableView=categoreTableView;
        categoreTableView.dataSource=categoryTableViewController;
        categoreTableView.delegate=categoryTableViewController;
        [categoreTableView reloadData];
        categoryTableViewController.locationToCellDelegate=self;
        recipeSearchControllerViewController.locationToCellDelegate=self;
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
            recipeSearchControllerViewController.allCategores=self.allCategores;
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
                    UIBarButtonItem*leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
                    self.navigationItem.leftBarButtonItem=leftButtonItem;
                    [leftButtonItem release];
                    self.title=[NSString stringWithFormat:@"%@-%@",self.title,order.desk.name];
                    [self.view addSubview: toolBarView];
                    [table setFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-TABBARHEIGHT-44-44)];

                } failure:^{
                    [table reloadData];
                }];
            }
            else{
                [table reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"错误: %@", error);
            MessageView *mv=[MessageView messageViewWithMessageText:@"无法连接到服务器"];
            [mv show];
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        MessageView *mv=[MessageView messageViewWithMessageText:@"无法连接到服务器"];
        [mv show];
        
    }];

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
//    self.searchBar.text=nil;
//    [self.recipeSearchControllerViewController.searchResultTable removeFromSuperview];
    [rec setTranslation:CGPointMake(0, 0) inView:self.view];
    if((table.center.x + point.x)>160)
    table.center = CGPointMake(table.center.x + point.x, table.center.y);
    [self.searchBar resignFirstResponder];
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
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:[[UIApplication sharedApplication] keyWindow]];
    // Check for horizontal gesture
    if (sqrt(translation.x * translation.x) / sqrt(translation.y * translation.y) > 1)
    {
        return YES;
    }
    return NO;
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

#pragma mark -
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if ([alertView isKindOfClass:[TextAlertView class]]) {
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
                UIButton*leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [leftButton setFrame:CGRectMake(0, 0, 50, 30)];
                [leftButton setBackgroundImage:[UIImage imageNamed:@"navRightBtn"]forState:UIControlStateNormal];
                [leftButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
                [leftButton setTitle:@"种类" forState:UIControlStateNormal];
                [leftButton addTarget:self action:@selector(leftBarButtonTouch)forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem*leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
                self.navigationItem.leftBarButtonItem=leftButtonItem;
                [leftButtonItem release];
                [self.view addSubview: toolBarView];
                [table setFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-TABBARHEIGHT-44-44)];
                
            } failure:^{
                MessageView *mv=[MessageView messageViewWithMessageText:@"开台码错误"];
                [mv show];
                
            }];
        }
        if ([alertView isKindOfClass:[MyAlertView class]]) {
            self.waiterBtn.enabled=NO;
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
            NSNumber *oidNum=[ud valueForKey:@"oid"];
            NSNumber *ridNum=[ud valueForKey:@"rid"];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"呼叫", @"type",
                                    nil];
            NSString *pathStr=[NSString stringWithFormat:@"restaurants/%d/orders/%d/assistent",ridNum.integerValue,oidNum.integerValue];
            [[AFRestAPIClient sharedClient] postPath:pathStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"返回实体: %@", responseObject);
                NSLog(@"返回头: %@", [operation.response allHeaderFields] );
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"错误: %@", error);
            }];

            [self performSelector:@selector(setWaiterBtnState) withObject:nil afterDelay:10];
        }
           }
}
//设置呼叫服务员按钮状态
-(void)setWaiterBtnState{
    self.waiterBtn.enabled=YES;
}
//刷新菜单
-(void)refreshOrder{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    if (oidNum!=nil) {
        self.table.scrollEnabled=NO;
        [Order rid:self.rid Oid:oidNum.integerValue Order:^(Order *order) {
            [self synchronizeOrder:order];
            self.table.scrollEnabled=YES;
        } failure:^{
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self addTableShadow];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    if (oidNum!=nil) {
    self.navigationItem.rightBarButtonItem.enabled=NO;
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.navigationItem.rightBarButtonItem.enabled=YES;
    }

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }
}


-(void)dealloc{
    [table release];
    [categoreTableView release];
    [categoryTableViewController release];
    [allCategores release];
    [currentOrder release];
    [searchBar release];
    [recipeSearchControllerViewController release];
    [toolBarView release];
    [orderBtn release];
    [waiterBtn release];
    [super dealloc];
}

@end
