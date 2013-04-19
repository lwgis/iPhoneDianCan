//
//  MainViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-9.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantController.h"
#import "ZBarSDK.h"
#import "BMapKit.h"
@interface MainViewController : UIViewController<UIAlertViewDelegate,ZBarReaderDelegate,BMKMapViewDelegate,BMKSearchDelegate>
@property(nonatomic,retain)BMKMapView *bmkMapView;
@property(nonatomic,retain)UIButton *cityBtn;
@property(nonatomic,retain)NSString *cityId;
@property(nonatomic,retain)NSString *cityName;
@property(nonatomic)BOOL isbackWithNavAnimaton;//返回时是否有导航栏动画。
@property(nonatomic,retain)BMKSearch *search;

@end
