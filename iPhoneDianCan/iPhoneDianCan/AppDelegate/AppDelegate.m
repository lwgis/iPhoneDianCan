//
//  AppDelegate.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "OrderListController.h"
#import "WaiterViewController.h"
#import "TabView.h"
#import "BMapKit.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFRestAPIClient.h"
@implementation AppDelegate
- (void)dealloc
{
    [_navMain release];
    [_navOrderList release];
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    MainViewController *mainViewController = [[[MainViewController alloc] init] autorelease];
    OrderListController *orderListController = [[[OrderListController alloc] init] autorelease];
    WaiterViewController *waiterController=[[[WaiterViewController alloc] init] autorelease];
    UINavigationController *navOrderList = [[[UINavigationController alloc] initWithRootViewController:orderListController] autorelease];
    UINavigationController *navMain = [[[UINavigationController alloc] initWithRootViewController:mainViewController] autorelease];
    UINavigationController *navWaiter = [[[UINavigationController alloc] initWithRootViewController:waiterController] autorelease];
    self.tabBarController = [[[MyTabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = @[navMain, navOrderList,navWaiter];
    UIViewController *buttomViewController=[[UIViewController alloc] init];
    buttomViewController.view=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREENHEIGHT)] autorelease];
    [buttomViewController.view addSubview:self.tabBarController.view];
    //tab按钮视图
     self.tabView=[[[TabView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-TABBARHEIGHT, 320, TABBARHEIGHT)] autorelease];
    self.tabView.delegate=self.tabBarController;
   self.tabView.backgroundColor=[UIColor clearColor];
    [buttomViewController.view addSubview:self.tabView];
    self.tabBarController.tabView=self.tabView;
    mainViewController.tabView=self.tabView;
    //设置百度地图key
    mapManager=[[BMKMapManager alloc] init];
   BOOL ret= [mapManager start:@"7E781CD995FDD3089381C0EDD67126D0A335528E" generalDelegate:self];
    if (!ret) {
		NSLog(@"manager start failed!");
	}
    self.window.rootViewController=buttomViewController;
    [self.window makeKeyAndVisible];
    [buttomViewController release];
    //设置设备码
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *udid=[ud objectForKey:@"udid"];
    NSLog(@"%@",udid);
    if (udid==nil) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = [NSString stringWithFormat:@"%@", uuidString ];
        CFRelease(puuid);
        CFRelease(uuidString);
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                result, @"udid",
                                @"2", @"ptype",
                                nil];
        [[AFRestAPIClient sharedClient] postPath:@"device" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dn=(NSDictionary *)responseObject;
            NSString *string=[dn objectForKey:@"deviceid"];
            [ud setValue:string forKey:@"udid"];
            [ud synchronize];
            [[AFRestAPIClient sharedClient] setDefaultHeader:@"X-device" value:string];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"错误: %@", error);
        }];
    }
    else{
        [[AFRestAPIClient sharedClient] setDefaultHeader:@"X-device" value:udid];
    }
        return YES;
}
-(void)btnClick{
    if (self.tabBarController.selectedIndex==1) {
        self.tabBarController.selectedIndex=0;
    }
    else{
        self.tabBarController.selectedIndex=1;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
