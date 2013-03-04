//
//  RestaurantUser.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-16.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RestaurantUser.h"

@implementation RestaurantUser
@synthesize rid,name;

-(id)initWithRid:(NSInteger)aRid name:(NSString *)aName{
    self=[super init];
    if (self) {
        rid=aRid;
        self.name=aName;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self=[super init];
    if (self&&dictionary&&dictionary.count>0) {
        rid=(NSInteger)[dictionary valueForKey:@"id"] ;
        self.name=[dictionary valueForKey:@"name"];
    }
    return self;
}

-(void)dealloc{
    [name release];
    [super dealloc];
}
@end
