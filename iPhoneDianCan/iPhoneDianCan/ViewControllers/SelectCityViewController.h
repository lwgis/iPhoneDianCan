//
//  SelectCityViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-28.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCityViewController : UITableViewController<UISearchBarDelegate,UIScrollViewDelegate>
@property(nonatomic,retain)NSMutableArray *resultCities;
@property(nonatomic,retain)NSArray *cities;
@end
