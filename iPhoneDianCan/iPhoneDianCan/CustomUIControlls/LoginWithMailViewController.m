//
//  LoginWithMailViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-8-22.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "LoginWithMailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MessageView.h"
#import "AFRestAPIClient.h"
#import "AFHTTPRequestOperation.h"
#import "MyAlertView.h"
#import "RestaurantController.h"
#import "RegisterViewController.h"
@interface LoginWithMailViewController ()

@end

@implementation LoginWithMailViewController
@synthesize userNameTextView,passWordTextView,myFavoriteBtn,nickNameLable,shareLoginBgView;
- (id)init
{
    self = [super init];
    if (self) {
        self.title=@"登录";
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"返回";
        [temporaryBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];
        UIImageView *bgImageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
        [bgImageView setImage:[UIImage imageNamed:@"recipeTableViewBg"]];
        [self.view addSubview:bgImageView];
        [bgImageView release];
        //用户名
        nickNameLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 40)];
        nickNameLable.textAlignment=NSTextAlignmentCenter;
        nickNameLable.backgroundColor=[UIColor clearColor];
        nickNameLable.font=[UIFont fontWithName:@"Helvetica-Bold" size:25];
        //登录整体
        shareLoginBgView=[[UIView alloc] initWithFrame:self.view.bounds];
        shareLoginBgView.backgroundColor=[UIColor clearColor];
        UIImageView *userNameImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 280, 55)];
        [userNameImageView setImage:[UIImage imageNamed:@"userNameImage"]];
        [self.shareLoginBgView addSubview:userNameImageView];
        [userNameImageView release];
        userNameTextView=[[UITextField alloc] initWithFrame:CGRectMake(90, 15, 170, 30)];
        userNameTextView.delegate=self;
        userNameTextView.placeholder=@"请输入用户名邮箱";
        userNameTextView.textColor=[UIColor orangeColor];
        userNameTextView.font = [UIFont boldSystemFontOfSize:20];
        userNameTextView.layer.borderColor = [UIColor grayColor].CGColor;
        userNameTextView.layer.cornerRadius =8;
        userNameTextView.keyboardType=UIKeyboardTypeEmailAddress;
        userNameTextView.returnKeyType=UIReturnKeyNext;
        [self.shareLoginBgView addSubview:userNameTextView];
        
        UIImageView *pwdImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 60, 280, 55)];
        [pwdImageView setImage:[UIImage imageNamed:@"pwdImage"]];
        [self.shareLoginBgView addSubview:pwdImageView];
        [pwdImageView release];
        passWordTextView=[[UITextField alloc] initWithFrame:CGRectMake(90, 70, 170, 30)];
        passWordTextView.returnKeyType=UIReturnKeyDone;
        passWordTextView.secureTextEntry = YES;
        passWordTextView.placeholder=@"请输入密码";
        passWordTextView.textColor=[UIColor orangeColor];
        passWordTextView.font = [UIFont boldSystemFontOfSize:20];
        passWordTextView.layer.borderColor = [UIColor grayColor].CGColor;
        passWordTextView.layer.cornerRadius =8;
        [self.shareLoginBgView addSubview:passWordTextView];
        UIButton *loginRegister=[UIButton buttonWithType:UIButtonTypeCustom];
        [loginRegister addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
        [loginRegister setImage:[UIImage imageNamed:@"registerBtn"] forState:UIControlStateNormal];
        [loginRegister setFrame:CGRectMake(20, 120, 135, 55)];
        [self.shareLoginBgView addSubview:loginRegister];
        UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn addTarget:self action:@selector(loginCheck) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn setImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
        [loginBtn setFrame:CGRectMake(165, 120, 135, 55)];
        [self.shareLoginBgView addSubview:loginBtn];
        [self.view addSubview:shareLoginBgView];
        [self loginIn];
    }
    return self;
}
//注册
-(void)registerUser{
    RegisterViewController *registerUserUc=[[RegisterViewController alloc] init];
    registerUserUc.loginDelegate=self;
    [self.navigationController pushViewController:registerUserUc animated:YES];
    [registerUserUc release];
}
//登录
-(void)loginCheck{
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
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userNameTextView.text, @"username",
                            passWordTextView.text, @"password",
                            nil];
    [[AFRestAPIClient sharedClient] postPath:@"user/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject======%@",operation.response.allHeaderFields);
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
            [self loginIn];
        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.responseString) {
            MessageView *mv=[MessageView messageViewWithMessageText:operation.responseString];
            [mv show];
        }
    }];
}

-(void)loginIn{
    NSUserDefaults *ns=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfoDic=[ns objectForKey:@"userInfo"];
    if (userInfoDic==nil) {
        return;
    }
    [self.shareLoginBgView removeFromSuperview];
    NSString *nName=[userInfoDic objectForKey:@"name"];
    nName=[nName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [nickNameLable setText:nName];
    [self.view addSubview:nickNameLable];
    UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"navRightBtn"]forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [rightButton setTitle:@"注销" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(logout)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    [rightItem release];
    self.title=@"已登录";
    self.myFavoriteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [myFavoriteBtn setFrame:CGRectMake(40, 110, 240, 55)];
    [myFavoriteBtn setImage:[UIImage imageNamed:@"myFavoriteBtn"] forState:UIControlStateNormal];
    [myFavoriteBtn addTarget:self action:@selector(myFavoriteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myFavoriteBtn];
}

-(void)myFavoriteBtnClick{
    RestaurantController *mfrvc=[[RestaurantController alloc] initWithShowStyle:ShowFavorite];
    mfrvc.title=@"我的收藏";
    [self.navigationController pushViewController:mfrvc animated:YES];
    [mfrvc release];
}

-(void)logout{
    MyAlertView *myAlert=[[MyAlertView alloc] initWithTitle:@"提示" message:@"您确定要注销账号吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注销账号" ,nil];
    [myAlert show];
    [myAlert release];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSUserDefaults *ns=[NSUserDefaults standardUserDefaults];
        [ns removeObjectForKey:@"userInfo"];
        [self.nickNameLable removeFromSuperview];
        [self.view addSubview:self.shareLoginBgView];
        self.navigationItem.rightBarButtonItem=nil;
        self.title=@"登  录";
        [self.myFavoriteBtn removeFromSuperview];
        self.myFavoriteBtn=nil;
        self.userNameTextView.text=nil;
        self.passWordTextView.text=nil;
        [self.userNameTextView becomeFirstResponder];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [userNameTextView becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [userNameTextView release];
    [passWordTextView release];
    [myFavoriteBtn release];
    [nickNameLable release];
    [shareLoginBgView release];
    [super dealloc];
}
//验证邮箱格式
- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField==userNameTextView) {
//        if ([self validateEmail:userNameTextView.text]){
//            [userNameTextView resignFirstResponder];
//            [passWordTextView becomeFirstResponder];
//        }
//        else{
//            MessageView *mv=[MessageView messageViewWithMessageText:@"邮箱格式不正确！"];
//            [mv show];
//            [passWordTextView resignFirstResponder];
//            [userNameTextView becomeFirstResponder];
//        }
//    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==userNameTextView) {
        [userNameTextView resignFirstResponder];
        [passWordTextView becomeFirstResponder];
    }
    return YES;
}
@end
