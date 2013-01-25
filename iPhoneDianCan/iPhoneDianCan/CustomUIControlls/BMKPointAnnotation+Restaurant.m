//
//  BMKPointAnnotation+Restaurant.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-25.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "BMKPointAnnotation+Restaurant.h"

NSIndexPath *_indexPath;
@implementation BMKPointAnnotation (Restaurant)
@dynamic indexPath;
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath=indexPath;
}
-(NSIndexPath *)indexPath{
    return _indexPath;
}
@end
