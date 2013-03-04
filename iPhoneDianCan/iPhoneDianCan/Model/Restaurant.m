//
//  Restaurant.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-15.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "Restaurant.h"
#import "RestaurantUser.h"
@implementation Restaurant
@synthesize rid,name,address,restaurantUser,telephone,x,y;

-(id)initWithID:(NSInteger)aRid name:(NSString *)aName address:(NSString *)anAddress telephone:(NSString *)aTelephone  RestaurantUser:(RestaurantUser *)aRestaurantUser x:(double)aX y:(double)aY{
    self=[super init];
    if (self) {
        rid=aRid;
        self.name=aName;
        self.address=anAddress;
        self.telephone=aTelephone;
        self.restaurantUser=aRestaurantUser;
        x=aX;
        y=aY;
    }
    return self ;
}

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self=[super init];
    if (self) {
        NSNumber *numRid=[dictionary valueForKey:@"id"];
        rid=numRid.integerValue;
        self.name=[dictionary valueForKey:@"name"];
        self.address=[dictionary valueForKey:@"address"];
        self.telephone=[dictionary valueForKey:@"telephone"];
        NSDictionary *dicUser=[dictionary valueForKey:@"user"];
        restaurantUser=[[RestaurantUser alloc] initWithDictionary:dicUser];
        NSNumber *numX=[dictionary valueForKey:@"x"];
        NSNumber *numY=[dictionary valueForKey:@"y"];
        x=numX.doubleValue;
        y=numY.doubleValue;
    }
    return  self;
}

-(void)dealloc{
    [name release];
    [telephone release];
    [address release];
    [restaurantUser release];
    [super dealloc];
}

-(NSString *)description{
    return self.name;
}
@end
