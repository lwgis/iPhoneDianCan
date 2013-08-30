//
//  BadgeButton.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-2-27.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "BadgeButton.h"

@implementation BadgeButton
@synthesize badgeValue=_badgeValue,buttonCount;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonCount=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonCount setFrame:CGRectMake(self.frame.size.width-18, 0, 18, 18)];
        buttonCount.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
        buttonCount.titleLabel.textAlignment=UITextAlignmentCenter;
        [buttonCount setUserInteractionEnabled:NO];
    }
    return self;
}

-(void)setBadgeValue:(NSInteger)badgeValue{
    _badgeValue=badgeValue;
    if (_badgeValue<0) {
        _badgeValue=0;
    }
    if (_badgeValue>0) {
        [buttonCount setTitle:[NSString stringWithFormat:@"%d",_badgeValue] forState:UIControlStateNormal];
//        [buttonCount sizeToFit];
        CGFloat width=0;
        if (_badgeValue<10) {
            width=16;
        }
        if (_badgeValue<100) {
            width=23;
        }
        if (_badgeValue>100) {
            width=30;
        }
        [buttonCount setFrame:CGRectMake(self.frame.size.width-width-5, 0,width, 18)];
        [buttonCount setBackgroundImage:[UIImage imageNamed:@"labelCount"] forState:UIControlStateNormal];
        [self addSubview:buttonCount];
        buttonCount.alpha=1;
    }
    else{
        [buttonCount removeFromSuperview];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
    [buttonCount release];
    [super dealloc];
}
@end
