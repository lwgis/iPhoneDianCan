//
//  OrderItem.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-25.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"
@interface OrderItem : NSObject
@property NSInteger oid;
@property (nonatomic)NSInteger countNew;
@property (nonatomic)NSInteger countDeposit;
@property (nonatomic)NSInteger countConfirm;
@property (nonatomic)NSInteger countAll;

@property(nonatomic,retain)Recipe *recipe;
//@property NSInteger status;//0表示没有上菜，1表示已经下单，2表示已经上菜
-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
