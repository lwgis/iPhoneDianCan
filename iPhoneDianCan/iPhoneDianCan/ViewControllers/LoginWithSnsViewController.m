//
//  LoginWithSnsViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-20.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "LoginWithSnsViewController.h"
#import "AFImageRequestOperation.h"
#import "AFRestAPIClient.h"
@interface LoginWithSnsViewController ()

@end

@implementation LoginWithSnsViewController
@synthesize webView;
-(id)initWithUrl:(NSString *)urlString{
    self=[super init];
    if (self) {
        webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-TABBARHEIGHT-45)];
        webView.delegate=self;
        [self.view addSubview:webView];
        [self loadWebPageWithString:urlString];
    }
    return self;
}
- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.title=@"载入中...";
    NSString *urlString=request.URL.absoluteString;
    NSLog(@"shouldStartLoadWithRequest=%@",urlString);
    NSArray *array = [urlString componentsSeparatedByString:@"http://taochike.sinaapp.com/rest/1/taochike/thirdlogin/callback?"];
    if (array.count>1) {
        NSString *str=[array objectAtIndex:1];
        array=[str componentsSeparatedByString:@"&"];
        NSMutableDictionary *userInfoDic=[[NSMutableDictionary alloc] init];
        for (NSString *str in array) {
            NSArray *subArray=[str componentsSeparatedByString:@"="];
            NSString *key=[subArray objectAtIndex:0];
            NSString *value=[subArray objectAtIndex:1];
            [userInfoDic setObject:value forKey:key];
        }
        NSUserDefaults *ns=[NSUserDefaults standardUserDefaults];
        [ns setObject:userInfoDic forKey:@"userInfo"];
        [ns synchronize];
        NSString *authorization=[userInfoDic valueForKey:@"Authorization"];
        authorization=[authorization stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[AFRestAPIClient sharedClient] setDefaultHeader:@"Authorization" value:authorization];
        NSString *thumbnail=[userInfoDic valueForKey:@"thumbnail"];
        NSURLRequest *requst=[NSURLRequest requestWithURL:[NSURL URLWithString:thumbnail]];
        AFImageRequestOperation *afRequest= [AFImageRequestOperation imageRequestOperationWithRequest:requst imageProcessingBlock:^UIImage *(UIImage *image) {
            return image;
        } success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [userInfoDic setObject:UIImagePNGRepresentation(image) forKey:@"image"];
            [ns setObject:userInfoDic forKey:@"userInfo"];
            NSLog(@"webViewDidFinishLoad:%@",userInfoDic);
            [ns synchronize];
            [userInfoDic release];
            [self.loginDelegate loginIn];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [ns synchronize];
            [userInfoDic release];
            [self.loginDelegate loginIn];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [afRequest start];

        return NO;
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title=@"登 录";
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
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    [webView release];
    [super dealloc];
}
@end
