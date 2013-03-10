//
//  OrderItem.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-25.
//  Copyright (c) 2013年 ztb. All rights reserved.
//
#import "OrderItem.h"
@implementation OrderItem
@synthesize oid,countNew,countDeposit,countConfirm,countAll,recipe;
-(id)initWithDictionary:(NSDictionary *)dictionary{
    self=[super init];
    if (self) {
//        NSNumber *numOid=[dictionary valueForKey:@"id"];
//        oid=numOid.integerValue;
        NSNumber *numCountNew=[dictionary valueForKey:@"countNew"];
        countNew=numCountNew.integerValue;
        NSNumber *numCountDeposit=[dictionary valueForKey:@"countDeposit"];
        countDeposit=numCountDeposit.integerValue;
        NSNumber *numCountConfirm=[dictionary valueForKey:@"countConfirm"];
        countConfirm=numCountConfirm.integerValue;
        recipe=[[Recipe alloc] initWithDictionary:[dictionary valueForKey:@"recipe"]];
//        NSNumber *numStatus=[dictionary valueForKey:@"status"];
//        status=numStatus.integerValue;
    }
    return self;
}
-(NSInteger)countAll{
    return countConfirm+countDeposit+countNew;
}
-(void)dealloc{
    [recipe release];
    [super dealloc];
}
@end
