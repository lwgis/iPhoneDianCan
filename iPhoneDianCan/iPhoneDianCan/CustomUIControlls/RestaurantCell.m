//
//  RestaurantCell.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-26.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RestaurantCell.h"
#import "AFRestAPIClient.h"
@implementation RestaurantCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.favoriteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.favoriteBtn addTarget:self action:@selector(favoriteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.favoriteBtn setImage:[UIImage imageNamed:@"favoriteBtn"] forState:UIControlStateNormal];
        [self.favoriteBtn setImage:[UIImage imageNamed:@"favoriteBtnSelect"] forState:UIControlStateHighlighted];
        [self addSubview:self.favoriteBtn];
        self.isFavorite=NO;
    }
    return self;
}
-(void)setFavoriteBtnHighLight:(BOOL)hightLight{
    if (hightLight) {
        [self.favoriteBtn setImage:[UIImage imageNamed:@"favoriteBtn"] forState:UIControlStateHighlighted];
        [self.favoriteBtn setImage:[UIImage imageNamed:@"favoriteBtnSelect"] forState:UIControlStateNormal];
    }
    else{
        [self.favoriteBtn setImage:[UIImage imageNamed:@"favoriteBtn"] forState:UIControlStateNormal];
        [self.favoriteBtn setImage:[UIImage imageNamed:@"favoriteBtnSelect"] forState:UIControlStateHighlighted];
    }
}
-(void)favoriteBtnClick:(UIButton *)sender{
    self.isFavorite=!self.isFavorite;
    [self setFavoriteBtnHighLight:self.isFavorite];
    NSString *pathStr=[NSString stringWithFormat:@"restaurants/%d/favorite",self.restaurant.rid];
    self.favoriteBtn.userInteractionEnabled=NO;
    if (self.isFavorite) {
        [[AFRestAPIClient sharedClient] postPath:pathStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            self.favoriteBtn.userInteractionEnabled=YES;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            self.favoriteBtn.userInteractionEnabled=YES;
        }];
    }
    else{
        pathStr=[NSString stringWithFormat:@"user/favorites/%d",self.restaurant.rid];
        [[AFRestAPIClient sharedClient] deletePath:pathStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            self.favoriteBtn.userInteractionEnabled=YES;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            self.favoriteBtn.userInteractionEnabled=YES;
        }];

    }
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
@end
