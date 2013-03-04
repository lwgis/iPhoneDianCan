//
//  WaiterViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-3.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "WaiterViewController.h"

@interface WaiterViewController ()

@end

@implementation WaiterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"服务员";
        self.view.backgroundColor=[UIColor grayColor];
    }
    return self;
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
