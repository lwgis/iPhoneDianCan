//
//  RestaurantUser.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-16.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantUser : NSObject{

}
//属性
@property NSInteger rid;
@property(nonatomic,retain)NSString *name;
//方法
-(id)initWithRid:(NSInteger)aRid name:(NSString *)aName;
-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
