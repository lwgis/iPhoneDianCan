//
//  Catagory.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-23.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "Category.h"

@implementation Category
@synthesize cid,name,description,imageUrl,allRecipes;
-(id)initWithDictionary:(NSDictionary *) dictionary{
    self=[super init];
    if (self) {
        NSNumber *numCid=[dictionary valueForKey:@"id"];
        cid=numCid.integerValue;
        self.name=[dictionary valueForKey:@"name"];
        self.description=[dictionary valueForKey:@"description"];
        self.imageUrl=[dictionary valueForKey:@"image"];
        allRecipes=[[NSMutableArray alloc] init];
    }
    return self;
}
-(void)dealloc{
    [name release];
    [description release];
    [imageUrl release];
    [allRecipes release];
    [super dealloc];
}
@end
