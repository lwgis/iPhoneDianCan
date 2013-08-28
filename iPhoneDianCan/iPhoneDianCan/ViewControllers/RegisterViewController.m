//
//  RegisterViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-8-23.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MessageView.h"
#import "AFRestAPIClient.h"
#import "AFHTTPRequestOperation.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize userNameTextView,passWordTextView,scrollView,pwdCheckTextView;
-(void)dealloc{
    [userNameTextView release];
    [passWordTextView release];
    [pwdCheckTextView release];
    [scrollView release];
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.title=@"注册";
        scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-44)];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"返回";
        [temporaryBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];
        UIImageView *bgImageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
        [bgImageView setImage:[UIImage imageNamed:@"recipeTableViewBg"]];
        [self.view addSubview:bgImageView];
        [bgImageView release];
        UIImageView *userNameImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 280, 55)];
        [userNameImageView setImage:[UIImage imageNamed:@"userNameImage"]];
        [self.scrollView addSubview:userNameImageView];
        [userNameImageView release];
        userNameTextView=[[UITextField alloc] initWithFrame:CGRectMake(90, 15, 170, 30)];
        userNameTextView.delegate=self;
        userNameTextView.placeholder=@"请输入注册邮箱";
        userNameTextView.textColor=[UIColor orangeColor];
        userNameTextView.font = [UIFont boldSystemFontOfSize:20];
        userNameTextView.layer.borderColor = [UIColor grayColor].CGColor;
        userNameTextView.layer.cornerRadius =8;
        userNameTextView.keyboardType=UIKeyboardTypeEmailAddress;
        userNameTextView.returnKeyType=UIReturnKeyNext;
        [self.scrollView addSubview:userNameTextView];
        UIImageView *pwdImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 60, 280, 55)];
        [pwdImageView setImage:[UIImage imageNamed:@"pwdImage"]];
        [self.scrollView addSubview:pwdImageView];
        [pwdImageView release];
        passWordTextView=[[UITextField alloc] initWithFrame:CGRectMake(90, 70, 170, 30)];
        passWordTextView.delegate=self;
        passWordTextView.returnKeyType=UIReturnKeyNext;
        passWordTextView.secureTextEntry = YES;
        passWordTextView.placeholder=@"请输入密码";
        passWordTextView.textColor=[UIColor orangeColor];
        passWordTextView.font = [UIFont boldSystemFontOfSize:20];
        passWordTextView.layer.borderColor = [UIColor grayColor].CGColor;
        passWordTextView.layer.cornerRadius =8;
        [self.scrollView addSubview:passWordTextView];
        
        UIImageView *pwdCheckImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 120, 280, 55)];
        [pwdCheckImageView setImage:[UIImage imageNamed:@"pwdCheckImage"]];
        [self.scrollView addSubview:pwdCheckImageView];
        [pwdCheckImageView release];
        pwdCheckTextView=[[UITextField alloc] initWithFrame:CGRectMake(90, 130, 170, 30)];
        pwdCheckTextView.delegate=self;
        pwdCheckTextView.returnKeyType=UIReturnKeyDone;
        pwdCheckTextView.secureTextEntry = YES;
        pwdCheckTextView.placeholder=@"请再次输入密码";
        pwdCheckTextView.textColor=[UIColor orangeColor];
        pwdCheckTextView.font = [UIFont boldSystemFontOfSize:20];
        pwdCheckTextView.layer.borderColor = [UIColor grayColor].CGColor;
        pwdCheckTextView.layer.cornerRadius =8;
        [self.scrollView addSubview:pwdCheckTextView];
        
        UIButton *loginRegister=[UIButton buttonWithType:UIButtonTypeCustom];
        [loginRegister addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
        [loginRegister setImage:[UIImage imageNamed:@"registerBtn"] forState:UIControlStateNormal];
        [loginRegister setFrame:CGRectMake(92, 180, 135, 55)];
        [self.scrollView addSubview:loginRegister];
        [self.view addSubview:self.scrollView];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    scrollView.contentSize=CGSizeMake(320,SCREENHEIGHT-44+60);
    [self.userNameTextView becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//验证邮箱格式
- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}


-(void)registerUser{
    if (![self validateEmail:userNameTextView.text]){
        MessageView *mv=[MessageView messageViewWithMessageText:@"邮箱格式不正确！"];
        [mv show];
        [passWordTextView resignFirstResponder];
        [userNameTextView becomeFirstResponder];
        return;
    }
    if (passWordTextView.text.length==0) {
        MessageView *mv=[MessageView messageViewWithMessageText:@"密码不能为空！"];
        [mv show];
        [passWordTextView becomeFirstResponder];
        [userNameTextView resignFirstResponder];
        return;
    }
    if (pwdCheckTextView.text.length==0) {
        MessageView *mv=[MessageView messageViewWithMessageText:@"确认密码不能为空！"];
        [mv show];
        [pwdCheckTextView becomeFirstResponder];
        [passWordTextView resignFirstResponder];
        return;
    }
    if (![pwdCheckTextView.text isEqualToString:passWordTextView.text]) {
        MessageView *mv=[MessageView messageViewWithMessageText:@"两次输入的密码不一样！"];
        [mv show];
        [pwdCheckTextView becomeFirstResponder];
        [passWordTextView resignFirstResponder];
        return;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userNameTextView.text, @"username",
                            passWordTextView.text, @"password",
                            nil];
    [[AFRestAPIClient sharedClient] postPath:@"user/register" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation) {
            NSUserDefaults *ns=[NSUserDefaults standardUserDefaults];
            NSMutableDictionary *userInfoDic=[[NSMutableDictionary alloc] initWithDictionary:operation.response.allHeaderFields];
            [userInfoDic setValue:userNameTextView.text forKey:@"name"];
            [ns setObject:userInfoDic forKey:@"userInfo"];
            [ns synchronize];
            [userInfoDic release];
            NSString *authorization=[operation.response.allHeaderFields valueForKey:@"Authorization"];
            authorization=[authorization stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[AFRestAPIClient sharedClient] setDefaultHeader:@"Authorization" value:authorization];
            [self.loginDelegate loginIn];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.responseString) {
            MessageView *mv=[MessageView messageViewWithMessageText:operation.responseString];
            [mv show];
            [userNameTextView becomeFirstResponder];
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
    }];

}

#pragma mark - UITextField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==pwdCheckTextView) {
        [self.scrollView setContentOffset:CGPointMake(0, 60) animated:YES];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==userNameTextView) {
        [userNameTextView resignFirstResponder];
        [passWordTextView becomeFirstResponder];
    }
    if (textField==passWordTextView) {
        [passWordTextView resignFirstResponder];
        [pwdCheckTextView becomeFirstResponder];
    }
    if (textField==pwdCheckTextView) {
        [pwdCheckTextView resignFirstResponder];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}
@end
