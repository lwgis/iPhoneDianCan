//
//  TabView.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-4.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "TabView.h"

@implementation TabView
//创建按钮
- (UIButton *)buttonWithName:(NSString *)name tag:(NSInteger)btnTag buttonImageName:(NSString *)buttonImageName buttonImageSelectedName:(NSString *)buttonImageSelectedName isSelected:(Boolean)isSelected {
    UIButton *btnFoodlist=[UIButton buttonWithType:UIButtonTypeCustom];
    btnFoodlist.tag=btnTag;
    [btnFoodlist addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnFoodlist setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
    [btnFoodlist setBackgroundImage:[UIImage imageNamed:buttonImageSelectedName] forState:UIControlStateSelected];
    [btnFoodlist setFrame:CGRectMake(btnTag*80, 0, 320/4, tabBarHeight)];
    [btnFoodlist setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [btnFoodlist setTitle:name forState:UIControlStateNormal];
    [btnFoodlist setTitle:name forState:UIControlStateSelected];
    [btnFoodlist.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [btnFoodlist setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnFoodlist setTitleColor:[UIColor colorWithRed:200 green:200 blue:200 alpha:0.6] forState:UIControlStateSelected];
    btnFoodlist.selected=isSelected;
    return btnFoodlist;
}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"CustomizedTabBg"]];
        self.userInteractionEnabled=YES;
        UIButton *btnFoodlist = [self buttonWithName:@"首页" tag:0 buttonImageName:@"foodlistButton" buttonImageSelectedName:@"foodlistButtonSelected" isSelected:YES];
        [self addSubview:btnFoodlist];
        UIButton *btnOrderList=[self buttonWithName:@"已点菜单" tag:1 buttonImageName:@"orderListButton" buttonImageSelectedName:@"orderListButtonSelected" isSelected:NO];
        [self addSubview:btnOrderList];
        UIButton *btnWaiter=[self buttonWithName:@"服务员" tag:2 buttonImageName:@"waiterButton" buttonImageSelectedName:@"waiterButtonSelected" isSelected:NO];
        [self addSubview:btnWaiter];
        UIButton *btnPay =[self buttonWithName:@"结账" tag:3 buttonImageName:@"payButton" buttonImageSelectedName:@"payButtonSelected" isSelected:NO]; 
        [self addSubview:btnPay];
    }
    return self;
}
-(void)btnClick:(UIButton *)sender{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton *)view;
            btn.selected=NO;
        }
    }
    [sender setSelected:YES];
    [self.delegate tabWasSelected:sender.tag];
}
-(void)setTabViewHidden:(BOOL) hidden{
    
}

@end
