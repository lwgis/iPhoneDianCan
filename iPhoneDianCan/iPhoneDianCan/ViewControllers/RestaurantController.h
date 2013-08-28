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
#import "RestaurantResultController.h"
typedef enum{
    ShowNormal=1,
    ShowFavorite=2,
}ShowStyle;

@interface RestaurantController : UIViewController<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,BMKSearchDelegate>{
    bool isShowMapView;//是否显示地图
}
@property(nonatomic,assign)BMKMapView *bmkMapView;
@property(nonatomic,retain)UITableView *table;
@property(nonatomic,retain)NSMutableArray *allRestaurants;
@property(nonatomic,retain)RestaurantResultController *restaurantResultController;
@property(nonatomic)BOOL isSeachAll;
@property(nonatomic)ShowStyle showStyle;
@property(nonatomic,retain)BMKSearch *search;
-(id)initWithShowStyle:(ShowStyle)showStyle;
@end
