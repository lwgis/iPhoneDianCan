//
//  RestaurantCell.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-26.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RestaurantCell.h"
#import "AFRestAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "RestaurantController.h"
#import "MessageView.h"
@implementation RestaurantCell
@synthesize indexPath;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.favoriteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.favoriteBtn addTarget:self action:@selector(favoriteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.favoriteBtn setImage:[UIImage imageNamed:@"favoriteBtn"] forState:UIControlStateNormal];
        [self.favoriteBtn setImage:[UIImage imageNamed:@"favoriteBtnSelect"] forState:UIControlStateHighlighted];
        NSUserDefaults *ns=[NSUserDefaults standardUserDefaults];
        NSDictionary *dic=[ns objectForKey:@"userInfo"];
        if (dic!=nil) {
            [self addSubview:self.favoriteBtn];
        }
        self.isFavorite=NO;
    }
    return self;
}

-(void)setRestaurant:(Restaurant *)restaurant{
    _restaurant=restaurant;
    NSString *imageUrlString=IMAGESERVERADDRESS;
    imageUrlString=[NSString stringWithFormat:@"%@%@",imageUrlString,restaurant.imageUrl];
    [self.imageView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"imageWaiting"]];
    self.textLabel.text = restaurant.name;
    self.detailTextLabel.text=restaurant.description;
    [self setFavoriteBtnHighLight:restaurant.isFavorite];
    self.isFavorite=restaurant.isFavorite;
}

-(void)setFavoriteBtnHighLight:(BOOL)hightLight{
    if (hightLight) {
        [self.favoriteBtn setImage:[UIImage imageNamed:@"favoriteBtn"] forState:UIControlStateHighlighted];
        [self.favoriteBtn setImage:[UIImage imageNamed:@"favoriteBtnSelect"] forState:UIControlStateNormal];
    }
    else{
        [self.favoriteBtn setImage:[UIImage imageNamed:@"favoriteBtn"] forState:UIControlStateNormal];
        [self.favoriteBtn setImage:[UIImage imageNamed:@"favoriteBtnSelect"] forState:UIControlStateHighlighted];
        if (self.isAllowRemoveCell) {
            UITableView *tv=(UITableView *)self.superview;
            RestaurantController *resCon=(RestaurantController *)tv.delegate;
            [tv beginUpdates];
            [resCon.allRestaurants removeObjectAtIndex:self.indexPath.row];
            [tv deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            [tv endUpdates];
            [self performSelector:@selector(reloadTableViewData)
                       withObject:nil afterDelay:0.3];
        }
    }
}

-(void)reloadTableViewData{
    UITableView *tv=(UITableView *)self.superview;
    [tv reloadData];
}

-(void)favoriteBtnClick:(UIButton *)sender{
    self.isFavorite=!self.isFavorite;
    NSString *pathStr=[NSString stringWithFormat:@"restaurants/%d/favorite",self.restaurant.rid];
    self.favoriteBtn.userInteractionEnabled=NO;
    if (self.isFavorite) {
        [[AFRestAPIClient sharedClient] postPath:pathStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            self.favoriteBtn.userInteractionEnabled=YES;
            MessageView *mv=[MessageView messageViewWithMessageText:@"已收藏"];
            [mv showWithDuration:0.5];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            self.favoriteBtn.userInteractionEnabled=YES;
            MessageView *mv=[MessageView messageViewWithMessageText:@"无法连接到服务器"];
            [mv show];
            
        }];
    }
    else{
        pathStr=[NSString stringWithFormat:@"user/favorites/%d",self.restaurant.rid];
        [[AFRestAPIClient sharedClient] deletePath:pathStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            self.favoriteBtn.userInteractionEnabled=YES;
            MessageView *mv=[MessageView messageViewWithMessageText:@"已取消收藏"];
            [mv showWithDuration:0.5];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            self.favoriteBtn.userInteractionEnabled=YES;
            MessageView *mv=[MessageView messageViewWithMessageText:@"无法连接到服务器"];
            [mv show];
            
        }];

    }
    [self setFavoriteBtnHighLight:self.isFavorite];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(5, 5, 70, 70)];
    self.textLabel.frame = CGRectMake(80.0f, 10.0f, 150.0f, 20.0f);
    self.detailTextLabel.frame = CGRectMake(80.0f, 40.0f, 240.0f, 40.0f);
    [self.favoriteBtn setFrame:CGRectMake(270, 20, 35, 35)];
}

-(void)dealloc{
    [super dealloc];
}
@end
