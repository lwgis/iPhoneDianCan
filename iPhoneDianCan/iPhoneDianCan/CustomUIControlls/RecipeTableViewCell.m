//
//  RecipeTableViewCell.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-23.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RecipeTableViewCell.h"
#import "Recipe.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
@implementation RecipeTableViewCell
@synthesize recipe = _recipe,zoomButton;
-(id)init{
    self=[super init];
    return self;
}
-(void)setRecipe:(Recipe *)recipe{
    _recipe=recipe;
    self.textLabel.text=recipe.name;
    self.detailTextLabel.text=[NSString stringWithFormat:@"%.2f",recipe.price];

    NSString *imageUrlString=IMAGESERVERADDRESS;
    imageUrlString=[NSString stringWithFormat:@"%@%@",imageUrlString,recipe.imageUrl];
    [self.imageView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"imageWaiting"]];
//    [self.imageView setImage:[UIImage imageNamed:@"imageWaiting"]];
//    AFImageRequestOperation *ope=[AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrlString]] success:^(UIImage *image) {
//        [self.imageView setImage:image];
//    }];
//    [ope start];

    self.textLabel.backgroundColor=[UIColor clearColor];
    self.detailTextLabel.backgroundColor=[UIColor clearColor];
    [zoomButton addTarget:self action:@selector(zoomImage) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsLayout];


}
-(void)zoomImage{
    NSString *imageUrlString=IMAGESERVERADDRESS;
    imageUrlString=[NSString stringWithFormat:@"%@%@",imageUrlString,_recipe.imageUrl];
    UIImageView *zoomImageBgView=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320, SCREENHEIGHT)];
    [zoomImageBgView setImage:[UIImage imageNamed:@"imageZoomBg"]];
    UITableView *tv=(UITableView *)self.superview;
    CGPoint point= tv.contentOffset;
    UIImageView *zoomImageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x-point.x+5,self.frame.origin.y-point.y+45+5, 70, 70)];
    zoomImageBgView.userInteractionEnabled=YES;
    zoomImageView.userInteractionEnabled=YES;
    UIButton *zoomCloseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [zoomCloseButton setFrame:CGRectMake(0.0f, 0.0f, 320, SCREENHEIGHT)];
    [zoomCloseButton addTarget:self action:@selector(zoomClose:) forControlEvents:UIControlEventTouchUpInside];
    [zoomImageView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"imageWaiting"]];
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [zoomImageBgView addSubview:zoomImageView];
    [zoomImageBgView addSubview:zoomCloseButton];
    [UIView animateWithDuration:0.5 animations:^{
        [zoomImageView setFrame:CGRectMake(0.0f, (SCREENHEIGHT-320)/2.0f, 320.0f, 320.0f)];
    }];
    [appDelegate.window.rootViewController.view addSubview:zoomImageBgView];
    [zoomImageView release];
    [zoomImageBgView release];
//    AFImageRequestOperation *ope=[AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrlString]] success:^(UIImage *image) {
//        [zoomImageView setImage:image];
//    }];
//    [ope start];
}
-(void)zoomClose:(UIButton *)sender{
    [sender.superview removeFromSuperview];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurantTableCellBg"]];
        self.backgroundView = bgImageView;
        [bgImageView release];
        zoomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [zoomButton setFrame:CGRectMake(5.0f, 5.0f, 70.0f, 70.0f)];
        [self addSubview:zoomButton];
        UIView *backView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView = backView;
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        [backView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(5.0f, 5.0f, 70.0f, 70.0f);
    self.textLabel.frame = CGRectMake(80.0f, 10.0f, 240.0f, 20.0f);
//    self.detailTextLabel.contentMode=UIViewContentModeBottomRight;
    self.detailTextLabel.frame = CGRectMake(280.0f, 30.0f, 40.0f, 20.0f);
    self.detailTextLabel.textColor=[UIColor redColor];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.textLabel.highlightedTextColor=[UIColor blackColor];
    self.detailTextLabel.highlightedTextColor=[UIColor redColor];
}

-(void)dealloc{
    [super dealloc];
}
@end
