//
//  SelectCityViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-28.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "SelectCityViewController.h"
#import "AFRestAPIClient.h"
@interface SelectCityViewController ()

@end

@implementation SelectCityViewController
@synthesize resultCities,cities;
-(id)init{
    self=[super init];
    if (self) {
        self.title=@"选择城市";
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapTableViewBg"]];
        self.tableView.backgroundView = bgImageView;
        [bgImageView release];
        UISearchBar *searchBar=[[UISearchBar alloc] init];
        searchBar.placeholder=@"输入城市名称或拼音首字母";
        [searchBar setBackgroundImage:[UIImage imageNamed:@"mapTableViewBg"]];
        [searchBar sizeToFit];
        searchBar.delegate=self;
        self.tableView.tableHeaderView=searchBar;
        UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(0, 0, 50, 30)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"navRightBtn"]forState:UIControlStateNormal];
        [rightButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        [rightButton setTitle:@"取消" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(closeView)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem= rightItem;
        [rightItem release];
        [[AFRestAPIClient sharedClient] getPath:@"city" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.cities=(NSArray *)responseObject;
            resultCities=[[NSMutableArray alloc] initWithArray:self.cities];
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
    return self;
}
-(void)closeView{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSouse
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (resultCities==nil) {
        return 0;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resultCities.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                            SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleValue1
				 reuseIdentifier:SectionsTableIdentifier] autorelease];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurantTableCellBg"]];
        cell.backgroundView = bgImageView;
        [bgImageView release];
        UIImageView *selectBgImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categoryTablecellSelectBg"]];
        cell.selectedBackgroundView=selectBgImageView;
        [selectBgImageView release];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
        cell.detailTextLabel.textColor=[UIColor redColor];
        cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        cell.detailTextLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    }
    NSDictionary *dic=[resultCities objectAtIndex:indexPath.row];
    NSString *cityName=[dic valueForKey:@"name"];
    cell.textLabel.text=cityName;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[resultCities objectAtIndex:indexPath.row];
    NSString *cityName=[dic valueForKey:@"name"];
    NSString *cityId=[dic valueForKey:@"id"];
    NSUserDefaults *us=[NSUserDefaults standardUserDefaults];
    [us setValue:cityName forKey:@"cityName"];
    [us setValue:cityId forKey:@"cityId"];
    [us synchronize];
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UISearchBar *searchBar=(UISearchBar *)self.tableView.tableHeaderView;
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate;
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (resultCities==nil) {
        return;
    }
    if ([searchText isEqualToString:@""]) {
        [resultCities release];
        resultCities=[[NSMutableArray alloc] initWithArray:cities];
        [self.tableView reloadData];
        return;
    }
    [self.resultCities removeAllObjects];
    for (NSDictionary *dic in self.cities) {
        NSString *cityName=[dic valueForKey:@"name"];
        NSString *cityPinYin=[dic valueForKey:@"pinyin"];
        NSRange textRangeName,textRangePinyin;
        textRangeName =[cityName rangeOfString:searchText];
        NSString *pinyin=searchText.lowercaseString;
        textRangePinyin=[cityPinYin rangeOfString:pinyin];
        if(textRangeName.location != NSNotFound||textRangePinyin.location!=NSNotFound)
        {
            [self.resultCities addObject:dic];
        }
    }
    [self.tableView reloadData];

}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];

}
-(void)dealloc{
    [resultCities release];
    [cities release];
    [super dealloc];
}
@end
