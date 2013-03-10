//
//  Recipe.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-23.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe
@synthesize rid,cid,name,price,imageUrl,description,countNew,countDeposit,countConfirm,countAll,status;
-(id)initWithDictionary:(NSDictionary *) dictionary{
    self=[super init];
    if (self) {
        NSNumber *numRid=[dictionary valueForKey:@"id"];
        rid=numRid.integerValue;
        NSNumber *numCid=[dictionary valueForKey:@"cid"];
        cid=numCid.integerValue;
        NSNumber *numPrice=[dictionary valueForKey:@"price"];
        price=numPrice.doubleValue;
        self.name=[dictionary valueForKey:@"name"];
        self.description=[dictionary valueForKey:@"description"];
        self.imageUrl=[dictionary valueForKey:@"image"];
    }
    return self;
}

-(NSInteger)countAll{
    return countConfirm+countDeposit+countNew;
}
-(void)dealloc{
    [name release];
    [imageUrl release];
    [description release];
    [super dealloc];
}
@end
