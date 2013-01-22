//
//  UINavigationBar+Customized.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-2.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "UINavigationBar+Customized.h"

@implementation UINavigationBar (Customized)
+ (Class)class {
    return NSClassFromString(@"MyNavigationBar");
}
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"CustomizedNavBg"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
