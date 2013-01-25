//
//  Catagory.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-23.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"
@interface Category : NSObject
@property NSInteger cid;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *imageUrl;
@property(nonatomic,retain)NSMutableArray *allRecipes;
-(id)initWithDictionary:(NSDictionary *) dictionary;
@end
