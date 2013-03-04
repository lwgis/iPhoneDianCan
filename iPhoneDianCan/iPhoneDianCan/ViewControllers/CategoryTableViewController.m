//
//  CategoryTableViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "Category.h"
@interface CategoryTableViewController ()

@end
@protocol LocationToCellDelegate;

@implementation CategoryTableViewController
@synthesize allCategores,catagoreTableView,locationToCellDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    self=[super init];
    if (self) {
        allCategores=[[NSMutableArray alloc] init];
    }
    return self;

}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (allCategores.count>0) {
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allCategores.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Category *category=[allCategores objectAtIndex:indexPath.row];
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleSubtitle
				 reuseIdentifier:SectionsTableIdentifier] autorelease];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurantTableCellBg"]];
        cell.backgroundView = bgImageView;
        [bgImageView release];
        UIImageView *selectBgImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categoryTablecellSelectBg"]];
        cell.selectedBackgroundView=selectBgImageView;
        [selectBgImageView release];

    }
    [cell.textLabel setText:category.name];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40;
}

- (void) unselectCurrentRow{
    // Animate the deselection
    [self.catagoreTableView deselectRowAtIndexPath:
     [self.catagoreTableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:newIndexPath.row];
    [locationToCellDelegate LocationToCell:(NSIndexPath *)index];

    [self performSelector:@selector(unselectCurrentRow)
               withObject:nil afterDelay:1.0];
    
}

-(void)dealloc{
    [allCategores release];
    [super dealloc];
}
@end
