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
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MyTabBarController *tabBarController;
@property(nonatomic,retain)UINavigationController *navMain;//主页导航
@property(nonatomic,retain) UINavigationController *navOrderList;//订单导航
@end
