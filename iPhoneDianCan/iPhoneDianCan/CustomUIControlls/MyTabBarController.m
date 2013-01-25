//
//  MyTabBarController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-4.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "MyTabBarController.h"
#import "TabView.h"
@interface MyTabBarController ()

@end

@implementation MyTabBarController
@synthesize delegate,tabView;
-(id)init{
    self = [super init];
    if (self) {
        [self.view setFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-TABBARHEIGHT)];
    }
    return  self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
        }
        else{
            [view setFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-TABBARHEIGHT)];
        }
    }
    [self.tabBar setFrame: CGRectMake(0, SCREENHEIGHT-TABBARHEIGHT, 320, TABBARHEIGHT)];
    NSLog(@"%d",self.selectedIndex);
}
-(void)tabWasSelected:(NSInteger)index{
    self.selectedIndex=index;
}
-(void)updateContentViewSizeWithHidden:(BOOL)hidden{
    float tabHeight=TABBARHEIGHT;
    if (hidden) {
        tabHeight=0;
    }
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
        }
        else{
            [view setFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-tabHeight)];
        }
    }
    
}
-(void)dealloc{
    [tabView release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
