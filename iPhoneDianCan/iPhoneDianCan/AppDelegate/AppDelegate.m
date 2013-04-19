//
//  AppDelegate.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "AppDelegate.h"
#import "OrderListController.h"
#import "BMapKit.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFRestAPIClient.h"
@implementation AppDelegate
- (void)dealloc
{
    [_mainViewController release];
    [_navMain release];
    [_navOrderList release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    _mainViewController = [[MainViewController alloc] init];
    UINavigationController *navMain = [[[UINavigationController alloc] initWithRootViewController:_mainViewController] autorelease];
    _mainViewController.navigationController.delegate=self;
    //设置百度地图key
    mapManager=[[BMKMapManager alloc] init];
   BOOL ret= [mapManager start:@"7E781CD995FDD3089381C0EDD67126D0A335528E" generalDelegate:self];
    if (!ret) {
		NSLog(@"manager start failed!");
	}
    self.window.rootViewController=navMain;
    self.window.backgroundColor=[UIColor grayColor];
    [self.window makeKeyAndVisible];
    //设置设备码
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *udid=[ud objectForKey:@"udid"];
    NSMutableDictionary *userInfoDic=[ud objectForKey:@"userInfo"];
    if (userInfoDic!=nil) {
        NSString *authorization=[userInfoDic valueForKey:@"Authorization"];
        authorization=[authorization stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[AFRestAPIClient sharedClient] setDefaultHeader:@"Authorization" value:authorization];
    }
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
#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
        if ( viewController ==  _mainViewController) {
    [navigationController setNavigationBarHidden:YES animated:animated];
      } else if ( [navigationController isNavigationBarHidden] ) {
          [navigationController setNavigationBarHidden:NO animated:animated];
      }
}

@end
