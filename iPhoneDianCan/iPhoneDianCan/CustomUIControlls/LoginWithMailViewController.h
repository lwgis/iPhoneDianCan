//
//  LoginWithMailViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-8-22.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
@interface LoginWithMailViewController : UIViewController<UITextFieldDelegate,loginDelegate>
@property(nonatomic,retain)UITextField *userNameTextView;
@property(nonatomic,retain)UITextField *passWordTextView;
@property(nonatomic,retain)UIButton *myFavoriteBtn;
@property(nonatomic,retain)UILabel *nickNameLable;
@property(nonatomic,retain)UIView *shareLoginBgView;
@end
