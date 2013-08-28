//
//  AccountViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-19.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "AccountViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MyAlertView.h"
#import "RestaurantController.h"

#define kSianWeibo @"https://open.weibo.cn/oauth2/authorize?client_id=1399451403&response_type=code&redirect_uri=http://159.226.110.64:8080/chihuoapp/rest/thirdlogin/weibo&display=mobile"

#define kQQ @"https://graph.qq.com/oauth2.0/authorize?client_id=100397130&response_type=code&state=121212&redirect_uri=http://159.226.110.64:8080/chihuoapp/rest/thirdlogin/qzone&display=mobile"
#define kTencent @"https://open.t.qq.com/cgi-bin/oauth2/authorize?client_id=801329761&response_type=code&redirect_uri=http://159.226.110.64:8080/chihuoapp/rest/thirdlogin/tqq"
#define kRenren @"https://graph.renren.com/oauth/authorize?client_id=fdd705c8e4ab47a2b9e979f0e3dcfe69&response_type=code&redirect_uri=http://159.226.110.64:8080/chihuoapp/rest/thirdlogin/renren&display=mobile"
#define kDouban @"https://www.douban.com/service/auth2/auth?client_id=0c6305f3fefbe2f7252911dbfcf3a8e5&response_type=code&redirect_uri=http://159.226.110.64:8080/chihuoapp/rest/thirdlogin/douban"
@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize headImageView,shareLoginBgView,nickNameLable,myFavoriteBtn;

-(id)init{
    self=[super init];
    if (self) {
        self.title=@"登  录";
        UIImageView *bgImageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
        [bgImageView setImage:[UIImage imageNamed:@"recipeTableViewBg"]];
        [self.view addSubview:bgImageView];
        [bgImageView release];
        headImageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 80)];
        headImageView.layer.masksToBounds=NO;
        [headImageView layer].shadowPath =[UIBezierPath bezierPathWithRect:headImageView.bounds].CGPath;
        [[headImageView layer] setShadowOffset:CGSizeMake(0.0, 3)];
        [[headImageView layer] setShadowRadius:3.0];
        [[headImageView layer] setShadowOpacity:0.5];
        [[headImageView layer] setShadowColor:[UIColor blackColor].CGColor];
        nickNameLable=[[UILabel alloc] initWithFrame:CGRectMake(110, 15, 210, 40)];
        nickNameLable.backgroundColor=[UIColor clearColor];
        nickNameLable.font=[UIFont fontWithName:@"Helvetica-Bold" size:25];
        shareLoginBgView=[[UIView alloc] init];
        if (SCREENHEIGHT>500) {
            [shareLoginBgView setFrame:CGRectMake(0, 74, 320, 360)];
        }
        else{
            [shareLoginBgView setFrame:CGRectMake(0, 30, 320, 360)];
        }
        shareLoginBgView.backgroundColor=[UIColor clearColor];
        UIButton *sinaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sinaBtn.tag=0;
        [sinaBtn setFrame:CGRectMake(40, 10, 240, 55)];
        [self addShadow:sinaBtn imageName:@"sinaWeibo"];
        [self.shareLoginBgView addSubview:sinaBtn];
        UIButton *qqBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        qqBtn.tag=1;
        [qqBtn setFrame:CGRectMake(40, 75, 240, 55)];
        [self addShadow:qqBtn imageName:@"qq"];
        [self.shareLoginBgView addSubview:qqBtn];
        UIButton *tencentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tencentBtn.tag=2;
        [tencentBtn setFrame:CGRectMake(40, 135, 240, 55)];
        [self addShadow:tencentBtn imageName:@"tencent"];
        [self.shareLoginBgView addSubview:tencentBtn];
        UIButton *renrenBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        renrenBtn.tag=3;
        [renrenBtn setFrame:CGRectMake(40, 195, 240, 55)];
        [self addShadow:renrenBtn imageName:@"renren"];
        [self.shareLoginBgView addSubview:renrenBtn];
        UIButton *doubanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        doubanBtn.tag=4;
        [doubanBtn setFrame:CGRectMake(40, 255, 240, 55)];
        [self addShadow:doubanBtn imageName:@"douban"];
        [self.shareLoginBgView addSubview:doubanBtn];
        [self.view addSubview:shareLoginBgView];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"返回";
        [temporaryBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];
        [self loginIn];
    }
    return self;
}


- (void)addShadow:(UIButton *)button  imageName:(NSString *)imageName{
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [button layer].shadowPath =[UIBezierPath bezierPathWithRect:button.bounds].CGPath;
//    [button layer].masksToBounds = NO;
//    [[button layer] setShadowOffset:CGSizeMake(0.0, 3)];
//    [[button layer] setShadowRadius:5.0];
//    [[button layer] setShadowOpacity:0.5];
//    [[button layer] setShadowColor:[UIColor blackColor].CGColor];
    [button addTarget:self action:@selector(shareBtnsClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)shareBtnsClick:(UIButton *)button{
    NSString *urlStr=nil;
    switch (button.tag) {
        case 0:
            urlStr=kSianWeibo;
            break;
        case 1:
            urlStr=kQQ;
            break;
        case 2:
            urlStr=kTencent;
            break;
        case 3:
            urlStr=kRenren;
            break;
        case 4:
            urlStr=kDouban;
            break;
        default:
            break;
    }
    LoginWithSnsViewController *longinSns=[[LoginWithSnsViewController alloc] initWithUrl:urlStr];
    longinSns.loginDelegate=self;
    [self.navigationController pushViewController:longinSns animated:YES];
    [longinSns release];
//    [self loginIn];
}

-(void)loginIn{
    NSUserDefaults *ns=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfoDic=[ns objectForKey:@"userInfo"];
    if (userInfoDic==nil) {
        return;
    }
    [self.shareLoginBgView removeFromSuperview];
    NSData* imageData = [userInfoDic valueForKey:@"image"];
    NSString *nName=[userInfoDic objectForKey:@"name"];
    nName=[nName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [nickNameLable setText:nName];
    [self.view addSubview:nickNameLable];
    [self.headImageView setImage:[UIImage imageNamed:@"noHeadImage"]];
    [self.view addSubview:headImageView];
    if (imageData!=nil) {
        UIImage* image = [UIImage imageWithData:imageData];
        [self.headImageView setImage:image];
    }
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
        [self.headImageView removeFromSuperview];
        [self.nickNameLable removeFromSuperview];
        [self.view addSubview:self.shareLoginBgView];
        self.navigationItem.rightBarButtonItem=nil;
        self.title=@"登  录";
        [self.myFavoriteBtn removeFromSuperview];
        self.myFavoriteBtn=nil;
    }
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
    [headImageView release];
    [shareLoginBgView release];
    [nickNameLable release];
    [myFavoriteBtn release];
    [super dealloc];
}
@end
