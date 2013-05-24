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
#import "RecentBrowseViewController.h"
#import "MyAlertView.h"
#import "SelectCityViewController.h"
#import "MessageView.h"
@implementation MainViewController
@synthesize bmkMapView,cityBtn,cityId,cityName,search;

-(id)init{
    self=[super init];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        UIImageView *bgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
        [bgView setImage:[UIImage imageNamed:@"headPageAd"]];
        [self.view addSubview:bgView];
        [bgView release];
        UIView *buttonsBgView=[[UIView alloc] initWithFrame:CGRectMake(0, (SCREENHEIGHT-TABBARHEIGHT-200+125)/2, 320, 200)];
        buttonsBgView.backgroundColor=[UIColor clearColor];
        //附近餐厅
        UIButton *btnRestaurant=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnRestaurant addTarget:self action:@selector(btnRestaurantClick) forControlEvents:UIControlEventTouchUpInside];
        [btnRestaurant setImage:[UIImage imageNamed:@"mapsNearButton"] forState:UIControlStateNormal];
        [btnRestaurant setFrame:CGRectMake(20, 0, 80, 80)];
        [buttonsBgView addSubview:btnRestaurant];
        //开台按钮
        UIButton *btnCheckIn=[UIButton buttonWithType:UIButtonTypeCustom];
        btnCheckIn.tag=0;
        [btnCheckIn addTarget:self action:@selector(btnCheckIn) forControlEvents:UIControlEventTouchUpInside];
        [btnCheckIn setImage:[UIImage imageNamed:@"twoDimensionCodeBtn"] forState:UIControlStateNormal];
        [btnCheckIn setFrame:CGRectMake(120, 0, 80, 80)];
        [buttonsBgView addSubview:btnCheckIn];
        //最近浏览
        UIButton *btnRecentBrowse=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnRecentBrowse addTarget:self action:@selector(btnRecentBrowse) forControlEvents:UIControlEventTouchUpInside];
        [btnRecentBrowse setImage:[UIImage imageNamed:@"recentBrowseBtn"] forState:UIControlStateNormal];
        [btnRecentBrowse setFrame:CGRectMake(220, 0, 80, 80)];
        [buttonsBgView addSubview:btnRecentBrowse];
        //个人中心
        UIButton *btnAccount=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnAccount addTarget:self action:@selector(btnAccount) forControlEvents:UIControlEventTouchUpInside];
        [btnAccount setImage:[UIImage imageNamed:@"accountBtn"] forState:UIControlStateNormal];
        [btnAccount setFrame:CGRectMake(20, 120, 80, 80)];
        [buttonsBgView addSubview:btnAccount];
        //搜索
        UIButton *btnSearch=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnSearch addTarget:self action:@selector(btnSearch) forControlEvents:UIControlEventTouchUpInside];
        [btnSearch setImage:[UIImage imageNamed:@"searchBtn"] forState:UIControlStateNormal];
        [btnSearch setFrame:CGRectMake(120, 120, 80, 80)];
        [buttonsBgView addSubview:btnSearch];
        //历史订单按钮
        UIButton *btnHistory=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnHistory addTarget:self action:@selector(btnHistory) forControlEvents:UIControlEventTouchUpInside];
        [btnHistory setImage:[UIImage imageNamed:@"historyBtn"] forState:UIControlStateNormal];
        [btnHistory setFrame:CGRectMake(220, 120, 80, 80)];
        [buttonsBgView addSubview:btnHistory];

        [self.view addSubview:buttonsBgView];
        [buttonsBgView release];
        cityBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [cityBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
        [cityBtn setFrame:CGRectMake(265, 5, 50, 30)];
        [cityBtn setBackgroundImage:[UIImage imageNamed:@"cityBtn"] forState:UIControlStateNormal];
        [cityBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        cityBtn.titleLabel.lineBreakMode=UILineBreakModeTailTruncation;
        cityBtn.titleLabel.shadowColor=[UIColor blackColor];
        cityBtn.titleLabel.shadowOffset=CGSizeMake(0, 1.0);
        [cityBtn setTitle:@"北京" forState:UIControlStateNormal];
        [self.view addSubview:cityBtn];
        self.title=@"淘吃客";
        // 下一个界面的返回按钮
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"返回";
        [temporaryBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];
        self.isbackWithNavAnimaton=NO;


    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (bmkMapView==nil) {
        bmkMapView=[[BMKMapView alloc] init];
        self.bmkMapView.delegate=self;
        bmkMapView.showsUserLocation=YES;
        search = [[BMKSearch alloc] init];
        search.delegate=self;
    }
    if (self.isbackWithNavAnimaton) {
        self.navigationController.navigationBarHidden=NO;
    }
    else{
        self.navigationController.navigationBarHidden=YES;
    }
    NSUserDefaults *us=[NSUserDefaults standardUserDefaults];
    NSString *usCityName=[us valueForKey:@"cityName"];
    if (usCityName!=nil) {
        [cityBtn setTitle:usCityName forState:UIControlStateNormal];
    }
}
-(void)selectCity{
    SelectCityViewController *svc=[[SelectCityViewController alloc] init];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:svc] autorelease];
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.window.rootViewController presentModalViewController:nav animated:YES];
    [svc release];
    self.isbackWithNavAnimaton=NO;
}
#pragma mark -
#pragma mark BMKMapViewDelegate
//更新位置以后
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    BMKCoordinateRegion newRegion;
    newRegion.center=userLocation.coordinate;
    newRegion.span.latitudeDelta  = 0.01;
    newRegion.span.longitudeDelta = 0.01;
    [mapView setRegion:newRegion animated:YES];
    mapView.showsUserLocation=NO;
	BOOL flag = [search reverseGeocode:userLocation.coordinate];
	if (!flag) {
		NSLog(@"search failed!");
	}
    
}
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
        NSUserDefaults *us=[NSUserDefaults standardUserDefaults];
        NSString *usCityName=[us valueForKey:@"cityName"];
        NSLog(@"------%@",result.addressComponent.city);
        [[AFRestAPIClient sharedClient] getPath:@"city" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSArray *cities=(NSArray *)responseObject;
            for (NSDictionary *dic in cities) {
                self.cityName=[dic valueForKey:@"name"];
                self.cityId=[dic valueForKey:@"id"];
                NSRange range=[result.addressComponent.city rangeOfString:cityName];
                if (range.location!=NSNotFound&&![usCityName isEqualToString:cityName]) {
                    NSString *message=[NSString stringWithFormat:@"您现在在%@，是否切换到所在城市",result.addressComponent.city];
                    MyAlertView *myAlert=[[MyAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"切换" ,nil];
                    [myAlert show];
                    [myAlert release];
                    break;
                }
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
	}
    self.bmkMapView.showsUserLocation=NO;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.cityBtn setTitle:cityName forState:UIControlStateNormal];
        NSUserDefaults *us=[NSUserDefaults standardUserDefaults];
        [us setObject:cityName forKey:@"cityName"];
        [us setObject:cityId forKey:@"cityId"];
        [us synchronize];
    }
}


-(void)btnRestaurantClick{
    RestaurantController *restaurantController=[[RestaurantController alloc] initWithShowStyle:ShowNormal];
    restaurantController.title=@"附近餐厅";
    if (bmkMapView==nil) {
        bmkMapView=[[BMKMapView alloc] init];
    }
    restaurantController.bmkMapView=bmkMapView;
    [self.navigationController pushViewController:restaurantController animated:YES];
    [restaurantController release];
    self.isbackWithNavAnimaton=YES;
}

-(void)btnSearch{
    RestaurantController *restaurantController=[[RestaurantController alloc] initWithShowStyle:ShowNormal];
    restaurantController.title=@"搜索餐厅";
    restaurantController.isSeachAll=YES;
    [self.navigationController pushViewController:restaurantController animated:YES];
    [restaurantController release];
    self.isbackWithNavAnimaton=YES;
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
    self.isbackWithNavAnimaton=NO;
}
-(void)btnAccount{
    AccountViewController *acViewCon=[[AccountViewController alloc] init];
    [self.navigationController pushViewController:acViewCon animated:YES];
    [acViewCon release];
    self.isbackWithNavAnimaton=YES;
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
        MessageView *mv=[MessageView messageViewWithMessageText:@"无效二维码"];
        [mv show];
        
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
            MessageView *mv=[MessageView messageViewWithMessageText:@"无效二维码"];
            [mv show];
            

        }];
    } failure:^{
        MessageView *mv=[MessageView messageViewWithMessageText:@"无法连接到服务器"];
        [mv show];
        
    }];
}
-(void)btnHistory{
    HistoryOrderControllerViewController *historyController=[[HistoryOrderControllerViewController alloc] init];
    [self.navigationController pushViewController:historyController animated:YES];
    [historyController release];
    self.isbackWithNavAnimaton=YES;
};

-(void)btnRecentBrowse{
    RecentBrowseViewController *recVc=[[RecentBrowseViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:recVc animated:YES];
    [recVc release];
    self.isbackWithNavAnimaton=YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [cityBtn release];
    [bmkMapView release];
    [cityName release];
    [cityId release];
    [search release];
    [super dealloc];
}

@end
