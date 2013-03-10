//
//  RecipeTableViewCell.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-23.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Recipe;
@interface RecipeTableViewCell : UITableViewCell{
    Recipe *_recipe;
}
@property(nonatomic,assign)Recipe *recipe;
@property(nonatomic,retain)UIButton *zoomButton;
@property(nonatomic,retain)UIButton *addRecipeBtn;
@property(nonatomic,retain)UIButton *removeRecipeBtn;
@property(nonatomic,retain)UILabel *countLabel;
@property(nonatomic,retain)UILabel *firstBadgeLabel;
@property(nonatomic,retain)UILabel *secondBadgeLabel;

@property(nonatomic) NSInteger recipeCount;
@property(nonatomic,retain)NSIndexPath *indexPath;
@property(nonatomic) BOOL isAllowRemoveCell;//是否允许UITableView将其移除
@end
