//
//  HistoryOrderControllerViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-17.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "HistoryOrderControllerViewController.h"
#import "HistoryOrder.h"
#import "HistoryDetailViewController.h"
#import "MessageView.h"
@interface HistoryOrderControllerViewController ()

@end

@implementation HistoryOrderControllerViewController
@synthesize orders,allDates,allOrdes;
-(id)init{
    self=[super init];
    if (self) {
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIImageView *tableBgView=[[UIImageView alloc] initWithFrame:self.tableView.frame];
        [tableBgView setImage:[UIImage imageNamed:@"recipeTableViewBg"]];
        self.tableView.backgroundView=tableBgView;
        [tableBgView release];
        allDates=[[NSMutableArray alloc] init];
        allOrdes=[[NSMutableDictionary alloc] init];
        self.title=@"历史订单";
        // 下一个界面的返回按钮
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"返回";
        [temporaryBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [HistoryOrder historyOrder:^(NSArray *historyOrders) {
        self.orders=historyOrders;
        for (HistoryOrder *hOrder in orders) {
            NSString *dateString=[hOrder yearMouthDayWeek];
            if (![allDates containsObject:dateString]) {
                [allDates addObject:dateString];
            }
        }
        for (NSString *dataString in allDates) {
            NSMutableArray *orderArray=[[NSMutableArray alloc] init];
            for (HistoryOrder *aOrder in orders) {
                if ([[aOrder yearMouthDayWeek] isEqualToString:dataString]) {
                    [orderArray addObject:aOrder];
                }
            }
            [allOrdes setObject:orderArray forKey:dataString];
            [orderArray release];
        }
        if (allOrdes.count==0) {
            MessageView *mv=[[MessageView alloc] initWithMessageText:@"您还没有历史订单"];
            [mv show];
        }
        [self.tableView reloadData];
    } failue:^{
        MessageView *mv=[[MessageView alloc] initWithMessageText:@"无法连接服务器"];
        [mv show];
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - uitableviewdatasouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return allDates.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *dateString=[allDates objectAtIndex:section];
    NSArray *orderArray=[allOrdes objectForKey:dateString];
    return orderArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *dateString=[allDates objectAtIndex:indexPath.section];
    NSArray *orderArray=[allOrdes objectForKey:dateString];
    HistoryOrder *order=[orderArray objectAtIndex:indexPath.row];
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleValue1
				 reuseIdentifier:SectionsTableIdentifier] autorelease];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurantTableCellBg"]];
        cell.backgroundView = bgImageView;
        [bgImageView release];
        UIImageView *selectBgImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categoryTablecellSelectBg"]];
        cell.selectedBackgroundView=selectBgImageView;
        [selectBgImageView release];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
        cell.detailTextLabel.textColor=[UIColor redColor];
        cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        cell.detailTextLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@  %d月%d日%d点",order.restaurantName,order.month,order.day,order.hour]];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%.1f",order.money];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[[UIView alloc] init] autorelease];
    UIImageView* customView = [[UIImageView alloc] init];
    [customView setImage:[UIImage imageNamed:@"restaurantTableHeadBg"]];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:15];
    NSString *dateString=[allDates objectAtIndex:section];
    headerLabel.text=[NSString stringWithFormat:@"%@",dateString];
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
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *dateString=[allDates objectAtIndex:indexPath.section];
    NSArray *orderArray=[allOrdes objectForKey:dateString];
    HistoryOrder *order=[orderArray objectAtIndex:indexPath.row];
    HistoryDetailViewController *hisDv=[[HistoryDetailViewController alloc] init];
    hisDv.historyOrder=order;
    [self.navigationController pushViewController:hisDv animated:YES];
    [hisDv release];
    [self performSelector:@selector(unselectCurrentRow)
               withObject:nil afterDelay:1.0];
}
- (void) unselectCurrentRow{
    // Animate the deselection
    [self.tableView deselectRowAtIndexPath:
     [self.tableView indexPathForSelectedRow] animated:YES];
}

-(void)dealloc{
    [orders release];
    [allOrdes release];
    [allDates release];
    [super dealloc];
}
@end
