//
//  Order.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-25.
//  Copyright (c) 2013年 ztb. All rights reserved.
//
#import "Order.h"
#import "AFRestAPIClient.h"
@implementation Order
@synthesize oid,desk,number,starttime,code,status,price,restaurant,orderItems;
+(void)rid:(NSInteger)rid Oid:(NSInteger)oid Order:(success)order failure:(failure)failure{
    NSString *path=[NSString stringWithFormat:@"restaurants/%d/orders/%d",rid,oid];
    [[AFRestAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        Order *aOrder=[[Order alloc] initWithDictionary:responseObject];
        order([aOrder autorelease]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        failure();
    }];
}
+(void)rid:(NSInteger)rid Code:(NSInteger)code Order:(success)order failure:(failure)failure{
    NSString *path=[NSString stringWithFormat:@"restaurants/%d/orders/code/%d",rid,code];
    [[AFRestAPIClient sharedClient] postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Order *aOrder=[[Order alloc] initWithDictionary:responseObject];
        order([aOrder autorelease]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        failure();
    }];
}

+(void)addRicpeWithRid:(NSInteger)rid RecipeId:(NSInteger)recipeId Oid:(NSInteger)oid Order:(success)order failure:(failure)failure{
    NSString *path=[NSString stringWithFormat:@"restaurants/%d/orders/%d",rid,oid];
    NSNumber *numRecipeId=[NSNumber numberWithInteger:recipeId];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            numRecipeId, @"rid",
                            @"1", @"count",
                            nil];
    [[AFRestAPIClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        Order *aOrder=[[Order alloc] initWithDictionary:responseObject];
        order([aOrder autorelease]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        failure();
    }];

}

+(void)removeRicpeWithRid:(NSInteger)rid RecipeId:(NSInteger)recipeId Oid:(NSInteger)oid Order:(success)order failure:(failure)failure{
    NSString *path=[NSString stringWithFormat:@"restaurants/%d/orders/%d",rid,oid];
    NSNumber *numRecipeId=[NSNumber numberWithInteger:recipeId];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            numRecipeId, @"rid",
                            @"-1", @"count",
                            nil];
    [[AFRestAPIClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        Order *aOrder=[[Order alloc] initWithDictionary:responseObject];
        order([aOrder autorelease]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        failure();
    }];
    
}


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
