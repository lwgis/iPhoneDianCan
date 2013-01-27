//
//  MainViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-9.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "MainViewController.h"
#import "RestaurantController.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFRestAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "Order.h"
#import "OrderItem.h"
#import "TextAlertView.h"
#import "MyZBarReaderViewController.h"
#import "AppDelegate.h"
@implementation MainViewController
@synthesize tabView;
-(id)init{
    self=[super init];
    if (self) {
        self.view.backgroundColor=[UIColor grayColor];
//        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,SCREENHEIGHT)];
//        self.view=view;
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
//        [view release];
        UIButton *btnRestaurant=[UIButton buttonWithType:UIButtonTypeCustom];
        btnRestaurant.tag=0;
        [btnRestaurant addTarget:self action:@selector(btnRestaurantClick) forControlEvents:UIControlEventTouchUpInside];
        [btnRestaurant setBackgroundImage:[UIImage imageNamed:@"mapsNearButton"] forState:UIControlStateNormal];
        [btnRestaurant setTitle:@"附近餐厅" forState:UIControlStateNormal];
        [btnRestaurant.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        btnRestaurant.imageView.contentMode=UIViewContentModeScaleAspectFill;
        [btnRestaurant setFrame:CGRectMake(0, SCREENHEIGHT-49-80-45, 80, 80)];
        [btnRestaurant setTitleEdgeInsets:UIEdgeInsetsMake(btnRestaurant.frame.size.height-btnRestaurant.titleLabel.frame.size.height, 0, 0, 0)];
        [btnRestaurant setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:btnRestaurant];
        //开台按钮
        UIButton *btnCheckIn=[UIButton buttonWithType:UIButtonTypeCustom];
        btnCheckIn.tag=0;
        [btnCheckIn addTarget:self action:@selector(btnCheckIn) forControlEvents:UIControlEventTouchUpInside];
        [btnCheckIn setBackgroundImage:[UIImage imageNamed:@"mapsNearButton"] forState:UIControlStateNormal];
        [btnCheckIn setTitle:@"开台" forState:UIControlStateNormal];
        [btnCheckIn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        btnCheckIn.imageView.contentMode=UIViewContentModeScaleAspectFill;
        [btnCheckIn setFrame:CGRectMake(80, SCREENHEIGHT-49-80-45, 80, 80)];
        [btnCheckIn setTitleEdgeInsets:UIEdgeInsetsMake(btnCheckIn.frame.size.height-btnCheckIn.titleLabel.frame.size.height, 0, 0, 0)];
        [btnCheckIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:btnCheckIn];
        self.title=@"淘吃客";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tabView.hidden=YES;
//    [self.tabView.delegate updateContentViewSizeWithHidden:YES];


}


-(void)btnRestaurantClick{
    RestaurantController *restaurantController=[[RestaurantController alloc] init];
    // 下一个界面的返回按钮
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    [temporaryBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
    self.tabView.hidden=NO;
    [self.tabView.delegate updateContentViewSizeWithHidden:NO];
    [self.navigationController pushViewController:restaurantController animated:YES];
    [restaurantController release];
    }

-(void)btnCheckIn{
//    NSString *pathOrder=[NSString stringWithFormat:@"restaurants/2/orders/code/5707"];
//    [[AFRestAPIClient sharedClient] postPath:pathOrder parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        Order *order=[[Order alloc] initWithDictionary:responseObject];
//        for (OrderItem *oi in order.orderItems) {
//            NSLog(@"%@",oi.recipe.name);
//        }
//        NSLog(@"%@",order.starttime);
//
//        [order release];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"错误: %@", error);
//    }];
    TextAlertView *tat=[[TextAlertView alloc] init];
    [tat setDelegate:self];
    [tat show];
    [tat release];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex==3) {
        MyZBarReaderViewController *reader = [[MyZBarReaderViewController alloc] init];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        reader.showsZBarControls=NO;
        ZBarImageScanner *scanner = reader.scanner;
        
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.window.rootViewController presentModalViewController:reader animated:YES];
        [reader release];
    }
}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    [reader dismissModalViewControllerAnimated: YES];
    NSLog(@"scandata%@",symbol.data) ;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
//    [restaurantController release];
    [tabView release];
    [super dealloc];
}

@end
