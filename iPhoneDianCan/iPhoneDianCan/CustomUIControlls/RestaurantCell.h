//
//  RestaurantCell.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-26.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
@interface RestaurantCell : UITableViewCell
@property(nonatomic,assign)Restaurant *restaurant;
@property(nonatomic,retain)UIButton *favoriteBtn;
@property(nonatomic)BOOL isFavorite;
@end
