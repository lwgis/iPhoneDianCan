//
//  MyZBarReaderViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-26.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "MyZBarReaderViewController.h"

@interface MyZBarReaderViewController ()

@end

@implementation MyZBarReaderViewController

-(id)init{
    self=[super init];
    if (self) {
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setFrame:CGRectMake(130, SCREENHEIGHT-30, 60, 40)];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"alertYesNoBtn"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.view addSubview:cancelBtn];
    }
return self;
}
-(void)cancelClick{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
