//
//  Recipe.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-23.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipe : NSObject
@property NSInteger rid;
@property NSInteger cid;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *description;
@property (nonatomic,retain)NSString *imageUrl;
@property double price;
@property (nonatomic)NSInteger countNew;//购物车新增个数
@property (nonatomic)NSInteger countDeposit;//已下单个数
@property (nonatomic)NSInteger countConfirm;//已上菜个数
@property (nonatomic)NSInteger countAll;//总共

@property NSInteger status;//0表示没有上菜，1表示已经下单，2表示已经上菜
-(id)initWithDictionary:(NSDictionary *) dictionary;

@end
