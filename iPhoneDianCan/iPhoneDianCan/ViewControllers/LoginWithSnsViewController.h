//
//  LoginWithSnsViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-20.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol loginDelegate;
@interface LoginWithSnsViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic,retain)UIWebView *webView;
@property(nonatomic,assign)id<loginDelegate> loginDelegate;

-(id)initWithUrl:(NSString *)urlString;
@end
@protocol loginDelegate <NSObject>

-(void)loginIn;

@end