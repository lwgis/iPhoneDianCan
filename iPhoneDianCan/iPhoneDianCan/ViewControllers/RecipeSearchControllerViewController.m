//
//  RecipeSearchControllerViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-11.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RecipeSearchControllerViewController.h"
#import "Category.h"
#import <QuartzCore/QuartzCore.h>
@interface RecipeSearchControllerViewController ()

@end

@implementation RecipeSearchControllerViewController
@synthesize searchBar=_searchBar,searchResultTable,allCategores,locationToCellDelegate,allIndexPaths,allRecipes,shadowView;
-(id)init{
    self=[super init];
    if (self) {
        searchResultTable=[[UITableView alloc] init];
        searchResultTable.clipsToBounds=YES;
        searchResultTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        searchResultTable.backgroundColor=[UIColor clearColor]; //colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.6];
        searchResultTable.dataSource=self;
        searchResultTable.delegate=self;
        shadowView =[[UIView alloc] init];
        [shadowView layer].masksToBounds = NO;
        [[shadowView layer] setShadowOffset:CGSizeMake(-5, 5)];
        [[shadowView layer] setShadowRadius:5.0];
        [[shadowView layer] setShadowOpacity:0.6];
        [[shadowView layer] setShadowColor:[UIColor blackColor].CGColor];
        shadowView.backgroundColor=[UIColor clearColor];//colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
        allRecipes =[[NSMutableArray alloc] init];
        allIndexPaths=[[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)setSearchBar:(UISearchBar *)searchBar{
    _searchBar=searchBar;
    [_searchBar setBackgroundImage:[UIImage imageNamed:@"categoryTableViewBg"]];
    _searchBar.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UISearchDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [shadowView addSubview:searchResultTable];
    [self.searchBar.superview addSubview:shadowView];
    [self.searchBar.superview insertSubview:searchBar aboveSubview:shadowView];
    [allRecipes removeAllObjects];
    [allIndexPaths removeAllObjects];
    NSInteger section=0;
    for (Category *category in self.allCategores) {
        NSInteger row=0;
        for (Recipe *recipe in category.allRecipes) {
            NSRange textRangeName,textRangePinyin;
            textRangeName =[recipe.name rangeOfString:searchText];
            NSString *pinyin=searchText.lowercaseString;
            textRangePinyin=[recipe.pinyin rangeOfString:pinyin];
            if(textRangeName.location != NSNotFound||textRangePinyin.location!=NSNotFound)
            {
                NSIndexPath *indexPath=[NSIndexPath indexPathForItem:row inSection:section];
                [allIndexPaths addObject:indexPath];
                [allRecipes addObject:recipe];
            }
            row++;
        }
        section++;
    }
    [self.searchResultTable reloadData];
    NSInteger height=allRecipes.count;
    if (height>4) {
        if (SCREENHEIGHT>500) {
            if (height>5) {
                height=6;
            }
        }
        else{
            height=4;
        }
    }
    double duration=0.2;
    if (searchText.length==0||allRecipes.count==0) {
        duration=0;
    }
    [self.searchResultTable setFrame:CGRectMake(0, 0, self.searchBar.frame.size.width-15,height*35)];
    [self.shadowView setFrame:CGRectMake(10, -height*35, self.searchBar.frame.size.width-15,height*35)];
    [shadowView layer].shadowPath =[UIBezierPath bezierPathWithRect:shadowView.bounds].CGPath;
    [UIView animateWithDuration:duration animations:^{
        [self.shadowView setFrame:CGRectMake(10, self.searchBar.frame.size.height, self.searchBar.frame.size.width-15,height*35)];
        } completion:^(BOOL finished) {
        }];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSInteger height=allRecipes.count;
    if (height>9) {
        if (SCREENHEIGHT>500) {
            if (height>10) {
                height=11;
            }
        }
        else{
            height=9;
        }
    }
    double duration=0.3;
    if (searchBar.text.length==0||allRecipes.count==0) {
        duration=0;
    }
    [UIView animateWithDuration:duration animations:^{
        [self.searchResultTable setFrame:CGRectMake(0, 0, self.searchBar.frame.size.width-15,height*35)];
        [self.shadowView setFrame:CGRectMake(10, self.searchBar.frame.size.height, self.searchBar.frame.size.width-15,height*35)];
        [shadowView layer].shadowPath =[UIBezierPath bezierPathWithRect:shadowView.bounds].CGPath;
    } completion:^(BOOL finished) {

    }];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSInteger height=allRecipes.count;
    if (height>4) {
        if (SCREENHEIGHT>500) {
            if (height>5) {
                height=6;
            }
        }
        else{
            height=4;
        }
    }
    double duration=0.2;
    if (searchBar.text.length==0||allRecipes.count==0) {
        duration=0;
    }
    shadowView.layer.shadowPath=nil;
    [UIView animateWithDuration:duration animations:^{
        [self.searchResultTable setFrame:CGRectMake(0,0, self.searchBar.frame.size.width-15,height*35)];
        [self.shadowView setFrame:CGRectMake(10, self.searchBar.frame.size.height, self.searchBar.frame.size.width-15,height*35)];
        [shadowView layer].shadowPath =[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, shadowView.frame.size.width, shadowView.frame.size.height)].CGPath;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (allRecipes.count>0) {
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allRecipes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Recipe *recipe=[allRecipes objectAtIndex:indexPath.row];
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleValue1
				 reuseIdentifier:SectionsTableIdentifier] autorelease];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchResultCellBg"]];
        cell.backgroundView = bgImageView;
        [bgImageView release];
        UIImageView *selectBgImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categoryTablecellSelectBg"]];
        cell.selectedBackgroundView=selectBgImageView;
        [selectBgImageView release];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
        cell.detailTextLabel.textColor=[UIColor whiteColor];
        cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        cell.detailTextLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    }
    [cell.textLabel setText:recipe.name];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%.1f",recipe.price];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}



- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    [self.searchBar resignFirstResponder];
    NSIndexPath *index=[allIndexPaths objectAtIndex:newIndexPath.row];
//    self.searchBar.text=nil;
//    [self.searchResultTable removeFromSuperview];
    [locationToCellDelegate locationToCell:(NSIndexPath *)index];
    
    [self performSelector:@selector(unselectCurrentRow)
               withObject:nil afterDelay:1.0];
    
}


- (void) unselectCurrentRow{
    // Animate the deselection
    [self.searchResultTable deselectRowAtIndexPath:
     [self.searchResultTable indexPathForSelectedRow] animated:YES];
}

-(void)dealloc{
    [searchResultTable release];
    [allIndexPaths release];
    [allRecipes release];
    [shadowView release];
    [super dealloc];
}
@end
