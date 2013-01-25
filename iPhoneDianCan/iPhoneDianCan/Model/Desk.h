//
//  Desk.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-25.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Desk : NSObject
@property NSInteger did;
@property(nonatomic,retain)NSString *name;
@property NSInteger capacity;//容纳人数
@property NSInteger tid;//类型(大厅，包间)
-(id)initWithDictionary:(NSDictionary *) dictionary;
@end
