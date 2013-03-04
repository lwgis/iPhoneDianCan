//
//  BadgeButton.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-2-27.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeButton : UIButton
@property(nonatomic) NSInteger badgeValue;
@property(nonatomic,retain)UIButton *buttonCount;
@end
