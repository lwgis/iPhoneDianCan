//
//  HistoryOrderControllerViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-17.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryOrderControllerViewController : UITableViewController
@property(nonatomic,retain)NSArray *orders;
@property(nonatomic,retain)NSMutableArray *allDates;
@property(nonatomic,retain)NSMutableDictionary *allOrdes;
@end
