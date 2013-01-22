//
//  RestaurantUser.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-16.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RestaurantUser.h"

@implementation RestaurantUser
-(id)initWithRid:(NSInteger)rid name:(NSString *)name{
    self=[super init];
    if (self) {
        _rid=rid;
        _name=name;
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary *)dictionary{
    self=[super init];
    if (self&&dictionary&&dictionary.count>0) {
        _rid=(NSInteger)[dictionary valueForKey:@"id"] ;
        _name=[dictionary valueForKey:@"name"];
    }
    return self;
}

@end
