//
//  Desk.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-25.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "Desk.h"

@implementation Desk
@synthesize did,name,capacity,tid;
-(id)initWithDictionary:(NSDictionary *)dictionary{
    self=[super init];
    if (self) {
        NSNumber *numDid=[dictionary valueForKey:@"id"];
        did=numDid.integerValue;
        self.name=[dictionary valueForKey:@"name"];
        NSNumber *numCapacity=[dictionary valueForKey:@"id"];
        capacity=numCapacity.integerValue;
        NSNumber *numTid=[dictionary valueForKey:@"tid"];
        tid=numTid.integerValue;
    }
    return self;
}
-(void)dealloc{
    [name release];
    [super dealloc];
}
@end
