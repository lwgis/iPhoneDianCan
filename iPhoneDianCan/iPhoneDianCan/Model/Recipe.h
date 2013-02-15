//
//  Recipe.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-23.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipe : NSObject
@property NSInteger rid;
@property NSInteger cid;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *description;
@property (nonatomic,retain)NSString *imageUrl;
@property double price;
@property NSInteger orderedCount;
-(id)initWithDictionary:(NSDictionary *) dictionary;

@end
