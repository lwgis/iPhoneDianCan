//
//  MainViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-9.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "MainViewController.h"
#import "RestaurantController.h"
#import "AFRestAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "Order.h"
#import "OrderItem.h"
#import "TextAlertView.h"
#import "MyZBarReaderViewController.h"
#import "AppDelegate.h"
#import "HistoryOrder.h"
#import "HistoryOrderControllerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AccountViewController.h"
@implementation MainViewController
@synthesize tabView,bmkMapView;

-(id)init{
    self=[super init];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        UIImageView *bgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREENHEIGHT)];
        [bgView setImage:[UIImage imageNamed:@"recipeTableViewBg"]];
        [self.view addSubview:bgView];
        [bgView release];
        UIButton *btnRestaurant=[UIButton buttonWithType:UIButtonTypeCustom];
        btnRestaurant.tag=0;
        [btnRestaurant addTarget:self action:@selector(btnRestaurantClick) forControlEvents:UIControlEventTouchUpInside];
        [btnRestaurant setBackgroundImage:[UIImage imageNamed:@"mapsNearButton"] forState:UIControlStateNormal];
        [btnRestaurant setTitle:@"附近餐厅" forState:UIControlStateNormal];
        [btnRestaurant.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        btnRestaurant.imageView.contentMode=UIViewContentModeScaleAspectFill;
        [btnRestaurant setFrame:CGRectMake(0, SCREENHEIGHT-49-80-45, 80, 80)];
        [btnRestaurant setTitleEdgeInsets:UIEdgeInsetsMake(btnRestaurant.frame.size.height-btnRestaurant.titleLabel.frame.size.height, 0, 0, 0)];
        [btnRestaurant setTitleColor:[UIColor colorWithRed:1 green:3.0/8 blue:1.0/8 alpha:1] forState:UIControlStateNormal];
        btnRestaurant.titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        btnRestaurant.titleLabel.shadowOffset = CGSizeMake(0, 1.0);
        [self.view addSubview:btnRestaurant];
        //开台按钮
        UIButton *btnCheckIn=[UIButton buttonWithType:UIButtonTypeCustom];
        btnCheckIn.tag=0;
        [btnCheckIn addTarget:self action:@selector(btnCheckIn) forControlEvents:UIControlEventTouchUpInside];
        [btnCheckIn setBackgroundImage:[UIImage imageNamed:@"twoDimensionCodeBtn"] forState:UIControlStateNormal];
        [btnCheckIn setTitle:@"二维码开台" forState:UIControlStateNormal];
        [btnCheckIn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        btnCheckIn.imageView.contentMode=UIViewContentModeScaleAspectFill;
        [btnCheckIn setFrame:CGRectMake(80, SCREENHEIGHT-49-80-45, 80, 80)];
        [btnCheckIn setTitleEdgeInsets:UIEdgeInsetsMake(btnCheckIn.frame.size.height-btnCheckIn.titleLabel.frame.size.height, 0, 0, 0)];
        [btnCheckIn setTitleColor:[UIColor colorWithRed:1 green:3.0/8 blue:1.0/8 alpha:1] forState:UIControlStateNormal];
        btnCheckIn.titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        btnCheckIn.titleLabel.shadowOffset = CGSizeMake(0, 1.0);
        [self.view addSubview:btnCheckIn];
        //历史订单按钮
        UIButton *btnHistory=[UIButton buttonWithType:UIButtonTypeCustom];
        btnHistory.tag=0;
        [btnHistory addTarget:self action:@selector(btnHistory) forControlEvents:UIControlEventTouchUpInside];
        [btnHistory setBackgroundImage:[UIImage imageNamed:@"historyBtn"] forState:UIControlStateNormal];
        [btnHistory setTitle:@"历史订单" forState:UIControlStateNormal];
        [btnHistory.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        btnHistory.imageView.contentMode=UIViewContentModeScaleAspectFill;
        [btnHistory setFrame:CGRectMake(160, SCREENHEIGHT-49-80-45, 80, 80)];
        [btnHistory setTitleEdgeInsets:UIEdgeInsetsMake(btnHistory.frame.size.height-btnHistory.titleLabel.frame.size.height, 0, 0, 0)];
        [btnHistory setTitleColor:[UIColor colorWithRed:1 green:3.0/8 blue:1.0/8 alpha:1] forState:UIControlStateNormal];
        btnHistory.titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        btnHistory.titleLabel.shadowOffset = CGSizeMake(0, 1.0);
        [self.view addSubview:btnHistory];
        UIButton *btnAccount=[UIButton buttonWithType:UIButtonTypeCustom];
        btnAccount.tag=0;
        [btnAccount addTarget:self action:@selector(btnAccount) forControlEvents:UIControlEventTouchUpInside];
        [btnAccount setBackgroundImage:[UIImage imageNamed:@"accountBtn"] forState:UIControlStateNormal];
        [btnAccount setTitle:@"个人中心" forState:UIControlStateNormal];
        [btnAccount.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        btnAccount.imageView.contentMode=UIViewContentModeScaleAspectFill;
        [btnAccount setFrame:CGRectMake(240, SCREENHEIGHT-49-80-45, 80, 80)];
        [btnAccount setTitleEdgeInsets:UIEdgeInsetsMake(btnHistory.frame.size.height-btnHistory.titleLabel.frame.size.height, 0, 0, 0)];
        [btnAccount setTitleColor:[UIColor colorWithRed:1 green:3.0/8 blue:1.0/8 alpha:1] forState:UIControlStateNormal];
        btnAccount.titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        btnAccount.titleLabel.shadowOffset = CGSizeMake(0, 1.0);
        [self.view addSubview:btnAccount];
        self.title=@"淘吃客";
        // 下一个界面的返回按钮
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"返回";
        [temporaryBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];

    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tabView.hidden=YES;
//    [self.tabView.delegate updateContentViewSizeWithHidden:YES];


}

-(void)btnRestaurantClick{
    RestaurantController *restaurantController=[[RestaurantController alloc] init];
    self.tabView.hidden=NO;
    [self.tabView.delegate updateContentViewSizeWithHidden:NO];
    if (bmkMapView==nil) {
        bmkMapView=[[BMKMapView alloc] init];
    }
    restaurantController.bmkMapView=bmkMapView;
    [self.navigationController pushViewController:restaurantController animated:YES];
    [restaurantController release];
}

-(void)btnCheckIn{
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
-(void)btnAccount{
    AccountViewController *acViewCon=[[AccountViewController alloc] init];
    [self.navigationController pushViewController:acViewCon animated:YES];
    [acViewCon release];
}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    [reader dismissModalViewControllerAnimated: YES];
    NSLog(@"scandata===%@",symbol.data) ;
    NSString *dataString=[NSString stringWithFormat:@"%@",symbol.data];
    NSArray *array = [dataString componentsSeparatedByString:@"_"];
    if (array.count==1) {
        return;
    }
    NSNumber *numRid=(NSNumber *)[array objectAtIndex:0];
    NSNumber *numOid=(NSNumber *)[array objectAtIndex:1];
    [Order rid:numRid.integerValue Oid:numOid.integerValue Order:^(Order *order) {
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        [ud setValue:numOid forKey:@"oid"];
        [ud setValue:numRid forKey:@"rid"];
        [ud synchronize];
        [Restaurant rid:numRid.integerValue Restaurant:^(Restaurant *restaurant) {
            FoodListController*foodListController=[[FoodListController alloc] initWithRecipe:restaurant];
            UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
            temporaryBarButtonItem.title = @"返回";
            [temporaryBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            [temporaryBarButtonItem release];
            [self.navigationController pushViewController:foodListController animated:YES];
            [foodListController release];
        } failure:^{
        }];
    } failure:^{
        ;
    }];
}
-(void)btnHistory{
    HistoryOrderControllerViewController *historyController=[[HistoryOrderControllerViewController alloc] init];
    [self.navigationController pushViewController:historyController animated:YES];
    [historyController release];
};
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
//    [restaurantController release]
    [bmkMapView release];
    [tabView release];
    [super dealloc];
}

@end
