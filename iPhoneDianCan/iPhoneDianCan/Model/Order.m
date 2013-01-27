//
//  Order.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-25.
//  Copyright (c) 2013年 ztb. All rights reserved.
//
#import "Order.h"
@implementation Order
@synthesize oid,desk,number,starttime,code,status,price,restaurant,orderItems;
-(id)initWithDictionary:(NSDictionary*) dictionary{
    self=[super init];
    if (self) {
        NSNumber *numOid=[dictionary valueForKey:@"id"];
        oid=numOid.integerValue;
        desk=[[Desk alloc] initWithDictionary:[dictionary valueForKey:@"desk"]];
        NSNumber *numNumber=[dictionary valueForKey:@"number"];
        number=numNumber.integerValue;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        self.starttime= [dateFormatter dateFromString:[dictionary valueForKey:@"starttime"]];
        [dateFormatter release];
        NSNumber *numCode=[dictionary valueForKey:@"code"];
        code=numCode.integerValue;
        NSNumber *numStatus=[dictionary valueForKey:@"status"];
        status=numStatus.integerValue;
        restaurant=[[Restaurant alloc] initWithDictionary:[dictionary valueForKey:@"restaurant"]];
        orderItems=[[NSMutableArray alloc] init];
        NSArray *orderitemsArray=[dictionary valueForKey:@"orderItems"];
        for (NSDictionary *orderDictionary in orderitemsArray) {
            OrderItem *orderItem=[[OrderItem alloc] initWithDictionary:orderDictionary];
            [orderItems addObject:orderItem];
            [orderItem release];
        }
    }
    return self;
}
-(void)dealloc{
    [desk release];
    [starttime release];
    [restaurant release];
    [orderItems release];
    [super dealloc];
}
@end
