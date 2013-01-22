//
//  RestaurantUser.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-16.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantUser : NSObject{
    NSInteger _rid;
    NSString * _name;
}
//属性
@property(nonatomic,readonly)NSInteger rid;
@property(nonatomic,readonly)NSString *name;
//方法
-(id)initWithRid:(NSInteger)rid name:(NSString *)name;
-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
