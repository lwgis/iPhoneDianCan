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
@synthesize oid,desk,number,starttime,code,status,priceAll,priceConfirm,priceDeposit,restaurant,orderItems;
+(void)rid:(NSInteger)rid Oid:(NSInteger)oid Order:(success)order failure:(failure)failure{
    NSString *path=[NSString stringWithFormat:@"restaurants/%d/orders/%d",rid,oid];
    [[AFRestAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        Order *aOrder=[[[Order alloc] initWithDictionary:responseObject] autorelease];
        [self updataBadge:aOrder];
        order(aOrder);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        failure();
    }];
}

+(void)rid:(NSInteger)rid Code:(NSInteger)code Order:(success)order failure:(failure)failure{
    NSString *path=[NSString stringWithFormat:@"restaurants/%d/orders/code/%d",rid,code];
    [[AFRestAPIClient sharedClient] postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Order *aOrder=[[[Order alloc] initWithDictionary:responseObject] autorelease];
        [self updataBadge:aOrder];
        order(aOrder);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        failure();
    }];
}

+ (void)updataBadge:(Order *)aOrder {
    NSInteger count=0;
    for (OrderItem *item in aOrder.orderItems) {
        count=count+item.countAll;
    }
    NSNumber *numCount=[NSNumber numberWithInteger:count];
    [[NSNotificationCenter defaultCenter] postNotificationName:KBadgeNotification object:numCount];
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
        Order *aOrder=[[[Order alloc] initWithDictionary:responseObject] autorelease];
        [self updataBadge:aOrder];
        order(aOrder);
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
        Order *aOrder=[[[Order alloc] initWithDictionary:responseObject] autorelease];
        [self updataBadge:aOrder];
        order(aOrder);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        failure();
    }];
    
}

+(void)CheckOrderWithRid:(NSInteger)rid Oid:(NSInteger)oid Order:(success)order failure:(failure)failure{
    NSString *path=[NSString stringWithFormat:@"restaurants/%d/orders/%d/tocheck",rid,oid];
    [[AFRestAPIClient sharedClient] putPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        Order *aOrder=[[[Order alloc] initWithDictionary:responseObject] autorelease];
        order([aOrder autorelease]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        failure();
    }];
}

+(void)OrderWithRid:(NSInteger)rid Oid:(NSInteger)oid Order:(success)order failure:(failure)failure{
    NSString *path=[NSString stringWithFormat:@"restaurants/%d/orders/%d/deposit",rid,oid];
    [[AFRestAPIClient sharedClient] putPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        Order *aOrder=[[[Order alloc] initWithDictionary:responseObject] autorelease];
        order(aOrder);
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
        NSNumber *numPriceAll=[dictionary valueForKey:@"priceAll"];
        priceAll=numPriceAll.doubleValue*1.0;
        NSNumber *numPriceConfirm=[dictionary valueForKey:@"priceConfirm"];
        priceConfirm=numPriceConfirm.doubleValue*1.0;
        NSNumber *numPriceDeposit=[dictionary valueForKey:@"priceDeposit"];
        priceDeposit=numPriceDeposit.doubleValue*1.0;
        orderItems=[[NSMutableArray alloc] init];
        NSArray *orderitemsArray=[dictionary valueForKey:@"clientItems"];
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
