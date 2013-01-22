//
//  MyTabBarController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-4.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabView.h"
@interface MyTabBarController : UITabBarController<MyTabBarDelegate>
@property(nonatomic,assign) TabView *tabView;
@end
