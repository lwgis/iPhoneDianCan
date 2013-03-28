//
//  AccountViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-19.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginWithSnsViewController.h"
@interface AccountViewController : UIViewController<UIWebViewDelegate,loginDelegate,UIAlertViewDelegate>
@property(nonatomic,retain)UIImageView *headImageView;
@property(nonatomic,retain)UILabel *nickNameLable;
@property(nonatomic,retain)UIView *shareLoginBgView;
@end
