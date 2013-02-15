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
#import "FoodListController.h"
@implementation RecipeTableViewCell
@synthesize recipe = _recipe,zoomButton,addRecipeBtn,removeRecipeBtn,countLabel,recipeCount=_recipeCount;
-(id)init{
    self=[super init];
    return self;
}

-(void)setRecipeCount:(NSInteger)recipeCount{
    _recipeCount=recipeCount;
    if (_recipeCount<=0) {
        [self.countLabel setText:@""];
        _recipeCount=0;
        [self.removeRecipeBtn removeFromSuperview];
    }
    else{
        [self.countLabel setText:[NSString stringWithFormat:@"%d 份",_recipeCount]];
        [self.contentView addSubview:self.removeRecipeBtn];
    }
}

-(void)setRecipe:(Recipe *)recipe{
    _recipe=recipe;
    self.recipeCount=recipe.orderedCount;
    self.textLabel.text=recipe.name;
    self.detailTextLabel.text=[NSString stringWithFormat:@"¥ %.2f",recipe.price];

    NSString *imageUrlString=IMAGESERVERADDRESS;
    imageUrlString=[NSString stringWithFormat:@"%@%@",imageUrlString,recipe.imageUrl];
    [self.imageView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"imageWaiting"]];
    /*
    [self.imageView setImage:[UIImage imageNamed:@"imageWaiting"]];
    AFImageRequestOperation *ope=[AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrlString]] success:^(UIImage *image) {
        [self.imageView setImage:image];
    }];
    [ope start];
     */
    self.textLabel.backgroundColor=[UIColor clearColor];
    self.detailTextLabel.backgroundColor=[UIColor clearColor];
    [zoomButton addTarget:self action:@selector(zoomImage) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsLayout];
}
-(void)addRecipe{
    self.recipeCount++;
    self.recipe.orderedCount++;
    NSLog(@"contentView subview coutn=%d",self.contentView.subviews.count);
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *numRid=[ud valueForKey:@"rid"];
    NSNumber *numOid=[ud valueForKey:@"oid"];
    [Order addRicpeWithRid:numRid.integerValue RecipeId:self.recipe.rid Oid:numOid.integerValue Order:^(Order *order) {
//        UITableView *tv=(UITableView *)self.superview;
//        FoodListController *flCon=(FoodListController *)tv.delegate;
//        [flCon synchronizeOrder:order];
    } failure:^{
    }];
}
-(void)removeRecipe{
    self.recipeCount--;
    self.recipe.orderedCount--;
    if (self.recipe.orderedCount<0) {
        self.recipe.orderedCount=0;
    }
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *numRid=[ud valueForKey:@"rid"];
    NSNumber *numOid=[ud valueForKey:@"oid"];
    [Order removeRicpeWithRid:numRid.integerValue RecipeId:self.recipe.rid Oid:numOid.integerValue Order:^(Order *order) {
//        UITableView *tv=(UITableView *)self.superview;
//        FoodListController *flCon=(FoodListController *)tv.delegate;
//        [flCon synchronizeOrder:order];
    } failure:^{
    }];

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
    [UIView animateWithDuration:0.2 animations:^{
        [zoomImageView setFrame:CGRectMake(0.0f, (SCREENHEIGHT-320)/2.0f, 320.0f, 320.0f)];
    } completion:^(BOOL finished) {
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurantTableCellBg"]];
        self.backgroundView = bgImageView;
        [bgImageView release];
        self.zoomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [zoomButton setFrame:CGRectMake(5.0f, 5.0f, 70.0f, 70.0f)];
        [self addSubview:zoomButton];
        UIView *backView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView = backView;
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        [backView release];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.addRecipeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [addRecipeBtn setFrame:CGRectMake(270, 45, 40, 40)];
        [addRecipeBtn setBackgroundImage:[UIImage imageNamed:@"addRecipeBtn"] forState:UIControlStateNormal];
        [addRecipeBtn addTarget:self action:@selector(addRecipe) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addRecipeBtn];
        self.removeRecipeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [removeRecipeBtn setFrame:CGRectMake(170, 45, 40, 40)];
        [removeRecipeBtn setBackgroundImage:[UIImage imageNamed:@"removeRecipeBtn"] forState:UIControlStateNormal];
        [removeRecipeBtn addTarget:self action:@selector(removeRecipe) forControlEvents:UIControlEventTouchUpInside];
        countLabel=[[UILabel alloc] initWithFrame:CGRectMake(210, 45, 60, 40)];
        countLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
        countLabel.backgroundColor=[UIColor clearColor];
        countLabel.textColor=[UIColor redColor];
        countLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:countLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(5.0f, 5.0f, 80.0f, 80.0f);
    self.textLabel.frame = CGRectMake(90.0f, 10.0f, 240.0f, 20.0f);
//    self.detailTextLabel.contentMode=UIViewContentModeBottomRight;
    self.detailTextLabel.frame = CGRectMake(100.0f, 50.0f, 60.0f, 40.0f);
    self.detailTextLabel.font=[UIFont boldSystemFontOfSize:15];
    self.detailTextLabel.textColor=[UIColor redColor];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.textLabel.highlightedTextColor=[UIColor blackColor];
    self.detailTextLabel.highlightedTextColor=[UIColor redColor];

}

-(void)dealloc{
    [zoomButton release];
    [addRecipeBtn release];
    [countLabel release];
    [removeRecipeBtn release];
    [super dealloc];
}
@end
