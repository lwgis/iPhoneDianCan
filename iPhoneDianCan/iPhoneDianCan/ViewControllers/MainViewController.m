//
//  MainViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-9.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "MainViewController.h"
#import "RestaurantController.h"
@implementation MainViewController
//@synthesize restaurantController;
-(id)init{
    self=[super init];
    if (self) {
        self.view.backgroundColor=[UIColor grayColor];
//        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,screenHeight)];
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
        [btnRestaurant setFrame:CGRectMake(0, screenHeight-49-80-45, 80, 80)];
        [btnRestaurant setTitleEdgeInsets:UIEdgeInsetsMake(btnRestaurant.frame.size.height-btnRestaurant.titleLabel.frame.size.height, 0, 0, 0)];
        [btnRestaurant setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:btnRestaurant];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
//    [restaurantController release];
    [super dealloc];
}

@end
