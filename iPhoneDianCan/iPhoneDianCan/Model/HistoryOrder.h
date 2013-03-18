//
//  HistoryOrder.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-17.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryOrder : NSObject
typedef void (^historyOrderSuccess) (NSArray *historyOrders);
typedef void(^historyOrderFailure)();
@property(nonatomic,retain)NSString *restaurantName;
@property NSInteger rid;
@property NSInteger oid;
@property NSInteger number;
@property(nonatomic,retain)NSDate *starttime;
@property(nonatomic)NSInteger year;
@property(nonatomic)NSInteger month;
@property(nonatomic)NSInteger day;
@property(nonatomic)NSInteger hour;
@property(nonatomic)NSInteger second;
@property(nonatomic,retain)NSString *week;
@property NSInteger code;
@property NSInteger status;//1表示未结账，3表示是请求结账，4已结账
@property(nonatomic)CGFloat money;
+(void)historyOrder:(historyOrderSuccess)order failue:(historyOrderFailure)failure;//获取历史订单
-(id)initWithDictionary:(NSDictionary*) dictionary;
-(NSString *)yearMouthDayWeek;
@end
