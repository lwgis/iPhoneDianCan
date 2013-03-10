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
#import "OrderListController.h"
#import "Category.h"
#import <QuartzCore/QuartzCore.h>
#import "FoodListController.h"
@implementation RecipeTableViewCell
@synthesize recipe = _recipe,zoomButton,addRecipeBtn,removeRecipeBtn,countLabel,firstBadgeLabel,secondBadgeLabel,recipeCount=_recipeCount,indexPath,isAllowRemoveCell;
-(id)init{
    self=[super init];
    return self;
}

-(void)setRecipeCount:(NSInteger)recipeCount{
    _recipeCount= recipeCount;
    if (_recipeCount<=0) {
        [self.countLabel setText:@""];
        _recipeCount=0;
        if (isAllowRemoveCell) {
            UITableView *tv=(UITableView *)self.superview;
            OrderListController *olCon=(OrderListController *)tv.delegate;
            Category *category=[olCon.allCategores objectAtIndex:indexPath.section];
            [category.allRecipes removeObjectAtIndex:indexPath.row];
            [tv beginUpdates];
            if (category.allRecipes.count==0) {
                [olCon.allCategores removeObjectAtIndex:indexPath.section];
                [tv deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
            else{
            [tv deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
            }
            [tv endUpdates];
            [self performSelector:@selector(reloadTableViewData)
                       withObject:nil afterDelay:0.2];
        }
        else{
            [self.removeRecipeBtn removeFromSuperview];
        }
    }
    else{
        if (_recipeCount<=(_recipe.countConfirm+_recipe.countDeposit)) {
            [self.removeRecipeBtn removeFromSuperview];
        }
        else{
            [self.contentView addSubview:self.removeRecipeBtn];

        }
        [self.countLabel setText:[NSString stringWithFormat:@"%d 份",_recipeCount]];
    }

}

-(void)reloadTableViewData{
    UITableView *tv=(UITableView *)self.superview;
    [tv reloadData];
    OrderListController *olCon=(OrderListController *)tv.delegate;
    if (olCon.allCategores.count==0) {
        [self performSelector:@selector(reloadTableViewData)
                   withObject:nil afterDelay:1.0];
    }
}

-(void)setRecipe:(Recipe *)recipe{
    _recipe=recipe;
    if (recipe.status!=0) {
        [addRecipeBtn setHidden:YES];
        [removeRecipeBtn setHidden:YES];
    }
    else{
        [addRecipeBtn setHidden:NO];
        [removeRecipeBtn setHidden:NO];
    }
    self.recipeCount=recipe.countAll;
    self.textLabel.text=recipe.name;
    self.detailTextLabel.text=[NSString stringWithFormat:@"¥ %.2f",recipe.price];
    if (recipe.countNew>0) {
        self.firstBadgeLabel.textColor=[UIColor redColor];
        self.firstBadgeLabel.text=[NSString stringWithFormat:@"未下单%d份",recipe.countNew];
    }
    else{
        self.firstBadgeLabel.textColor=[UIColor grayColor];
        self.firstBadgeLabel.text=[NSString stringWithFormat:@"已下单"];
    }

    if (recipe.countConfirm>0) {
        self.secondBadgeLabel.textColor=[UIColor orangeColor];
        if (recipe.countConfirm==1) {
            self.secondBadgeLabel.text=[NSString stringWithFormat:@"已上桌"];

        }
        else{
            self.secondBadgeLabel.text=[NSString stringWithFormat:@"已上桌%d份",recipe.countConfirm];
        }
    }
    else{
        
    }
    NSString *imageUrlString=IMAGESERVERADDRESS;
    imageUrlString=[NSString stringWithFormat:@"%@%@",imageUrlString,recipe.imageUrl];
    [self.imageView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"imageWaiting"]];
    self.textLabel.backgroundColor=[UIColor clearColor];
    self.detailTextLabel.backgroundColor=[UIColor clearColor];
    [zoomButton addTarget:self action:@selector(zoomImage) forControlEvents:UIControlEventTouchUpInside];
    if(isAllowRemoveCell){
        [self.contentView addSubview:firstBadgeLabel];
        [self.contentView addSubview:secondBadgeLabel];
    }

    [self setNeedsLayout];
}

-(void)addRecipe{
    Recipe *aRecipe=self.recipe;
    aRecipe.countNew++;
    self.recipe=aRecipe;
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *numRid=[ud valueForKey:@"rid"];
    NSNumber *numOid=[ud valueForKey:@"oid"];
    if (numOid==nil) {
        return;
    }
//    self.recipeCount++;
//    self.recipe.orderedCount++;
    [Order addRicpeWithRid:numRid.integerValue RecipeId:self.recipe.rid Oid:numOid.integerValue Order:^(Order *order) {
        UITableView *tv=(UITableView *)self.superview;
        OrderListController *flCon=(OrderListController *)tv.delegate;
//        [flCon synchronizeOrder:order];
        if (isAllowRemoveCell) {
            NSInteger newCount=0;
            for (OrderItem *oItem in order.orderItems) {
                newCount+=oItem.countNew;
            }
            if (newCount>0) {
                flCon.title=[NSString stringWithFormat:@"共:￥%.2f-未下单:%d",order.priceAll,newCount];
                flCon.navigationItem.leftBarButtonItem=flCon.leftButtonItem ;
            }
            else{
                flCon.title=[NSString stringWithFormat:@"共:￥%.2f",order.priceAll];
                flCon.navigationItem.leftBarButtonItem=nil ;
            }
        }
    } failure:^{
    }];
    UIImageView *animationImageView=[[UIImageView alloc] initWithImage:self.imageView.image];
    UITableView *tv=(UITableView *)self.superview;
    CGPoint point= tv.contentOffset;
    [animationImageView setFrame:CGRectMake(self.frame.origin.x-point.x+5,self.frame.origin.y-point.y+45+5, 25, 25)];
    animationImageView.tag=100;
    [tv.superview addSubview:animationImageView];


    CGMutablePathRef thePath =  CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, animationImageView.frame.origin.x, animationImageView.frame.origin.y);
    CGPathAddLineToPoint(thePath, NULL, animationImageView.frame.origin.x+32, animationImageView.frame.origin.y-60);
    CGPathAddLineToPoint(thePath, NULL, animationImageView.frame.origin.x+64, animationImageView.frame.origin.y-80);
    CGPathAddLineToPoint(thePath, NULL, animationImageView.frame.origin.x+96, animationImageView.frame.origin.y-60);
    CGPathAddLineToPoint(thePath, NULL, animationImageView.frame.origin.x+128, animationImageView.frame.origin.y);
    CGPathAddLineToPoint(thePath, NULL, animationImageView.frame.origin.x+160, SCREENHEIGHT-44-20);
    CAKeyframeAnimation *theAnimation =[CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.path=thePath;
    theAnimation.duration=(SCREENHEIGHT-(self.frame.origin.y-point.y))/800;
    NSLog(@"duration=%f",theAnimation.duration);
    theAnimation.repeatCount = 1; 
    theAnimation.autoreverses=NO;
    theAnimation.cumulative=YES;
    theAnimation.delegate=self;
    [animationImageView.layer addAnimation:theAnimation forKey:@"animateLayer"]; // 添加动画。
    CFRelease(thePath);
    [animationImageView setFrame:CGRectMake(320, SCREENHEIGHT, 25, 25)];
    [animationImageView release];
}

-(void)removeRecipe{
//    self.recipeCount--;
    Recipe *aRecipe=self.recipe;
    aRecipe.countNew--;
    self.recipe=aRecipe;
    if (self.recipe.countNew<0) {
        self.recipe.countNew=0;
    }
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *numRid=[ud valueForKey:@"rid"];
    NSNumber *numOid=[ud valueForKey:@"oid"];
    [Order removeRicpeWithRid:numRid.integerValue RecipeId:self.recipe.rid Oid:numOid.integerValue Order:^(Order *order) {
        UITableView *tv=(UITableView *)self.superview;
        OrderListController *flCon=(OrderListController *)tv.delegate;
//        [flCon synchronizeOrder:order];
        if (isAllowRemoveCell) {
            NSInteger newCount=0;
            for (OrderItem *oItem in order.orderItems) {
                newCount+=oItem.countNew;
            }
            if (newCount>0) {
                flCon.title=[NSString stringWithFormat:@"共:￥%.2f-未下单:%d",order.priceAll,newCount];
                flCon.navigationItem.leftBarButtonItem=flCon.leftButtonItem ;
                
            }
            else{
                flCon.title=[NSString stringWithFormat:@"共:￥%.2f",order.priceAll];
                flCon.navigationItem.leftBarButtonItem=nil ;

            }
        }
    } failure:^{
    }];

}

-(void)zoomImage{
    NSString *imageUrlString=LARGEIMAGESERVERADDRESS;
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
    [zoomImageView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:self.imageView.image];
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
        isAllowRemoveCell=NO;
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
        firstBadgeLabel=[[UILabel alloc] initWithFrame:CGRectMake(240, 0, 70, 20)];
        firstBadgeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        firstBadgeLabel.backgroundColor=[UIColor clearColor];
        firstBadgeLabel.textColor=[UIColor redColor];
        firstBadgeLabel.textAlignment=NSTextAlignmentRight;
        secondBadgeLabel=[[UILabel alloc] initWithFrame:CGRectMake(240, 20, 70, 20)];
        secondBadgeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        secondBadgeLabel.backgroundColor=[UIColor clearColor];
        secondBadgeLabel.textColor=[UIColor redColor];
        secondBadgeLabel.textAlignment=NSTextAlignmentRight;
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
    self.textLabel.frame = CGRectMake(90.0f, 10.0f, 150.0f, 20.0f);
//    self.textLabel.backgroundColor=[UIColor whiteColor];
//    self.detailTextLabel.contentMode=UIViewContentModeBottomRight;
    self.detailTextLabel.frame = CGRectMake(90.0f, 50.0f, 80.0f, 40.0f);
    self.detailTextLabel.font=[UIFont boldSystemFontOfSize:15];
    self.detailTextLabel.textColor=[UIColor redColor];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.textLabel.highlightedTextColor=[UIColor blackColor];
    self.detailTextLabel.highlightedTextColor=[UIColor redColor];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([anim isKindOfClass:[CAKeyframeAnimation class]]) {
        UITableView *tv=(UITableView *)self.superview;
        UIImageView *im=(UIImageView *)[tv.superview viewWithTag:100];
        if (im) {
            [im removeFromSuperview];
        }
    }
}

-(void)dealloc{
    [zoomButton release];
    [addRecipeBtn release];
    [countLabel release];
    [firstBadgeLabel release];
    [secondBadgeLabel release];
    [removeRecipeBtn release];
    [indexPath release];
    [super dealloc];
}
@end
