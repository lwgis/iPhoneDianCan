//
//  WaiterViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-3.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "WaiterViewController.h"
#import "Order.h"
#import "MyAlertView.h"
#import "AppDelegate.h"
@interface WaiterViewController ()

@end

@implementation WaiterViewController

-(id)init{
    self=[super init];
    if (self) {
        UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(0, 0, 50, 30)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"navRightBtn"]forState:UIControlStateNormal];
        [rightButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        [rightButton setTitle:@"结账" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(payOrder)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem= rightItem;
        [rightItem release];
    }
    return self;
}
-(void)payOrder{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    [Order rid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
        NSString *message=[NSString stringWithFormat:@"您总共消费￥%.2f",order.priceDeposit];
        MyAlertView *myAlert=[[MyAlertView alloc] initWithTitle:@"结账确认" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"结账" ,nil];
        [myAlert show];
        [myAlert release];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } failure:^{
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        //        NSNumber *oidNum=[ud valueForKey:@"oid"];
        //        NSNumber *ridNum=[ud valueForKey:@"rid"];
        //        [Order CheckOrderWithRid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
        [ud removeObjectForKey:@"oid"];
        [ud removeObjectForKey:@"rid"];
        [ud synchronize];
        self.title=@"";
        AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.tabBarController.selectedIndex=0;
        UINavigationController *nav=(UINavigationController *)[[appDelegate.tabBarController viewControllers] objectAtIndex:0];
        [nav popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:KBadgeNotification object:0];
        [appDelegate.tabView reSetting];
        //        } failure:^{
        //
        //        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
