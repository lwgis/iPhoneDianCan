//
//  SecondViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "OrderListController.h"

@interface OrderListController ()

@end

@implementation OrderListController

-(id)init{
    self=[super init];
    if (self) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-40)];
        view.backgroundColor=[UIColor redColor];
        self.view=view;
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        [view release];
//        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
//                                    initWithTitle:@"左按钮"
//                                    style:UIBarButtonItemStyleBordered
//                                    target:self
//                                    action:@selector(backView)];
        UIImage* image= [UIImage imageNamed:@"navButton.png"];
        CGRect frame_1= CGRectMake(0, 0, 50,30);
        UIButton* backButton= [[UIButton alloc] initWithFrame:frame_1];
        [backButton setBackgroundImage:image forState:UIControlStateNormal];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        backButton.titleLabel.font=[UIFont systemFontOfSize:12];
        [backButton addTarget:self action:@selector(backView:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc] initWithCustomView:backButton];
        [backButton release];
//        [leftBtn setBackButtonBackgroundImage:[UIImage imageNamed:@"CustomizedNavBarBg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = leftBtn;
        [leftBtn release];        
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                     initWithTitle:@"右按钮"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(backView)];
        self.navigationItem.rightBarButtonItem = rightBtn;
        [rightBtn release];
            }
    return self;
}
-(void)backView:(UIButton *) btn{
//    OrderListController *temp= [[OrderListController alloc] init];
//    temp.title=@"2";
//    [self.navigationController pushViewController:temp animated:YES];
//    [temp release];
    NSLog(@"%@",btn);


}
- (void)viewDidLoad
{


    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
