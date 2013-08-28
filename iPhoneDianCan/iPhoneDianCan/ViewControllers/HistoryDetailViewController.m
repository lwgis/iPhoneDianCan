//
//  HistoryDetailViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-19.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "Order.h"
@interface HistoryDetailViewController ()

@end

@implementation HistoryDetailViewController
@synthesize historyOrder=_historyOrder,allOrderItems;
-(id)init{
    self=[super init];
    if (self) {
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIImageView *tableBgView=[[UIImageView alloc] initWithFrame:self.tableView.frame];
        [tableBgView setImage:[UIImage imageNamed:@"recipeTableViewBg"]];
        self.tableView.backgroundView=tableBgView;
        [tableBgView release];
        allOrderItems=[[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)setHistoryOrder:(HistoryOrder *)historyOrder{
    _historyOrder=historyOrder;
    [Order rid:_historyOrder.rid Oid:_historyOrder.oid Order:^(Order *order) {
        for (OrderItem *oItem in order.orderItems) {
            if (oItem.countDeposit!=0) {
                [allOrderItems addObject:oItem];
            }
        }
     self.title=[NSString stringWithFormat:@"%@(￥%.2f)",historyOrder.restaurantName,order.priceDeposit];
     [self.tableView reloadData];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}

#pragma mark - UITableViewDataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (allOrderItems.count>0) {
        return 1;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allOrderItems.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderItem *orderItem=[allOrderItems objectAtIndex:indexPath.row];
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
        cell.detailTextLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
        UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = backView;
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        [backView release];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@---%d份",orderItem.recipe.name,orderItem.countDeposit]];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"单价￥%.2f",orderItem.recipe.price];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [allOrderItems release];
    [super dealloc];
}
@end
