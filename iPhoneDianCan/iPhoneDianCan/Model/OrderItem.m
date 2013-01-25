//
//  OrderItem.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-25.
//  Copyright (c) 2013年 ztb. All rights reserved.
//
#import "OrderItem.h"
@implementation OrderItem
@synthesize oid,count,recipe,status;
-(id)initWithDictionary:(NSDictionary *)dictionary{
    self=[super init];
    if (self) {
        NSNumber *numOid=[dictionary valueForKey:@"id"];
        oid=numOid.integerValue;
        NSNumber *numCount=[dictionary valueForKey:@"count"];
        count=numCount.integerValue;
        recipe=[[Recipe alloc] initWithDictionary:[dictionary valueForKey:@"recipe"]];
        NSNumber *numStatus=[dictionary valueForKey:@"status"];
        status=numStatus.integerValue;
    }
    return self;
}

-(void)dealloc{
    [recipe release];
    [super dealloc];
}
@end
