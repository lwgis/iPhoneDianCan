//
//  AccountViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-19.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize webView;
-(id)init{
    self=[super init];
    if (self) {
        webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.delegate=self;
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self loadWebPageWithString:@"https://open.weibo.cn/oauth2/authorize?client_id=1399451403&response_type=code&redirect_uri=http://taochike.sinaapp.com/wbredirect.jsp&display=mobile"];

        [self.view addSubview:webView];
    }
    return self;
}
- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
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
-(void)dealloc{
    [webView release];
    [super dealloc];
}
@end
