//
//  Order.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-25.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Desk.h"
#import "Restaurant.h"
#import "OrderItem.h"
@interface Order : NSObject
@property NSInteger oid;
@property(nonatomic,retain)Desk *desk;
@property NSInteger number;
@property(nonatomic,retain)NSDate *starttime;
@property NSInteger code;
@property NSInteger status;//1表示未结账，3表示是请求结账，4已结账
@property double price;
@property(nonatomic,retain)Restaurant *restaurant;
@property(nonatomic,retain)NSMutableArray *orderItems;
-(id)initWithDictionary:(NSDictionary*) dictionary;
@end
