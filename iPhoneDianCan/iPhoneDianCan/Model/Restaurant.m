//
//  Restaurant.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-15.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "Restaurant.h"
#import "RestaurantUser.h"
#import "AFRestAPIClient.h"
@implementation Restaurant
@synthesize rid,name,pinyin,address,restaurantUser,telephone,x,y;

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
        self.pinyin=[dictionary valueForKey:@"pinyin"];
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

+(void)rid:(NSInteger)rid Restaurant:(restaurantSuccess)restaurant failure:(restaurantFailure)failure{
    NSString *path=[NSString stringWithFormat:@"restaurants/%d",rid];
    [[AFRestAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        Restaurant *aRestaurant=[[Restaurant alloc] initWithDictionary:responseObject];
        restaurant([aRestaurant autorelease]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        failure();
    }];
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
