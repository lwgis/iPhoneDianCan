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
@end
