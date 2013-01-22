//
//  RestaurantController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-9.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "FoodListController.h"
@interface RestaurantController : UIViewController<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate>{
    BMKMapView *bmkMapView;
}
@property(nonatomic,retain)UITableView *table;
@property(nonatomic,retain)NSMutableDictionary *allRestaurants;
@end
