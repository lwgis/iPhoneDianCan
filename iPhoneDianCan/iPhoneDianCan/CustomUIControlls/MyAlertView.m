//
//  MyAlertView.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-4.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "MyAlertView.h"

@implementation MyAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)layoutSubviews{
    //屏蔽系统的ImageView 和 UIButton
    [super layoutSubviews];
    for (UIView *v in [self subviews]) {
        if ([v class] == [UIImageView class]){
            UIImageView *iv=(UIImageView *)v;
            if(iv.frame.size.height<300&&self.subviews.count>5)
            [iv setHidden:YES];
            [iv setImage:[UIImage imageNamed:@"alertViewBg"]];
        }
        if ([v isKindOfClass:[UIButton class]] ||
            [v isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
//            [v setHidden:YES];
            UIButton *btn=(UIButton *)v;
            [btn setBackgroundImage:[UIImage imageNamed:@"alertYesNoBtn"] forState:UIControlStateNormal];
        }
    }
}
@end
