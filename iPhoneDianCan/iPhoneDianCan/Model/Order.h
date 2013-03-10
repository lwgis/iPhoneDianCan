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
typedef void (^success) (Order *order);
typedef void(^failure)();
@property NSInteger oid;
@property(nonatomic,retain)Desk *desk;
@property NSInteger number;
@property(nonatomic,retain)NSDate *starttime;
@property NSInteger code;
@property NSInteger status;//1表示未结账，3表示是请求结账，4已结账
@property double priceAll;
@property double priceDeposit;
@property double priceConfirm;

@property(nonatomic,retain)Restaurant *restaurant;
@property(nonatomic,retain)NSMutableArray *orderItems;
-(id)initWithDictionary:(NSDictionary*) dictionary;
+(void)rid:(NSInteger)rid Oid:(NSInteger)oid Order:(success)order failure:(failure)failure; //根据餐馆ID和订单ID获取订单
+(void)rid:(NSInteger)rid Code:(NSInteger)code Order:(success)order failure:(failure)failure;//根据餐馆ID和开台码获取订单
+(void)addRicpeWithRid:(NSInteger)rid RecipeId:(NSInteger)recipeId Oid:(NSInteger)oid Order:(success)order failure:(failure)failure;//加菜
+(void)removeRicpeWithRid:(NSInteger)rid RecipeId:(NSInteger)recipeId Oid:(NSInteger)oid Order:(success)order failure:(failure)failure;//减菜
+(void)CheckOrderWithRid:(NSInteger)rid Oid:(NSInteger)oid Order:(success)order failure:(failure)failure;//申请结账
+(void)OrderWithRid:(NSInteger)rid Oid:(NSInteger)oid Order:(success)order failure:(failure)failure;//下单
@end
