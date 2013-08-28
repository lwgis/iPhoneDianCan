//
//  RegisterViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-8-23.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol loginDelegate;

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic,assign)id<loginDelegate> loginDelegate;
@property(nonatomic,retain)UITextField *userNameTextView;
@property(nonatomic,retain)UITextField *passWordTextView;
@property(nonatomic,retain)UITextField *pwdCheckTextView;
@property(nonatomic,retain)UIScrollView *scrollView;
@end
@protocol loginDelegate <NSObject>

-(void)loginIn;
@end
