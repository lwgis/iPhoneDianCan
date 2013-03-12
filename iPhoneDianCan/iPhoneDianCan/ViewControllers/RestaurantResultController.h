//
//  RestaurantResultController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-12.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodListController.h"

@interface RestaurantResultController : UISearchDisplayController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSMutableArray *resultRestaurants;

@end
