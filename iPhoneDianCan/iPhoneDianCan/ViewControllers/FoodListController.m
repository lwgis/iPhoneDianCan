//
//  FirstViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "FoodListController.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFRestAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "Restaurant.h"

@interface FoodListController ()

@end

@implementation FoodListController
@synthesize rid;
-(id)init{
    self=[super init];
    if (self) {
//        self.title = NSLocalizedString(@"First", @"First");
        self.view.backgroundColor=[UIColor grayColor];
    }
    return self;
}
							
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *path=[NSString stringWithFormat:@"restaurants/%d/recipes",self.rid];
    NSString *udid=[ud objectForKey:@"udid"];
    [[AFRestAPIClient sharedClient] setDefaultHeader:@"X-device" value:udid];
    [[AFRestAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"返回实体: %@", responseObject);
        
        NSLog(@"返回头: %@", [operation.response allHeaderFields]);
        NSDictionary *dn=(NSDictionary *)responseObject;
        NSLog(@"%d",dn.count);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
