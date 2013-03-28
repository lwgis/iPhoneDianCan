//
//  AppDelegate.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTabBarController.h"
#import "BMapKit.h"
#import "Order.h"
#import "MainViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,BMKGeneralDelegate,UINavigationControllerDelegate>{
    BMKMapManager *mapManager;
}
@property(nonatomic,retain)MainViewController *mainViewController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MyTabBarController *tabBarController;
@property(nonatomic,strong)UINavigationController *navMain;//主页导航
@property(nonatomic,strong) UINavigationController *navOrderList;//订单导航
@property(nonatomic,strong)TabView *tabView;
@end
