//
//  RestaurantController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-9.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RestaurantController.h"
#import "AFRestAPIClient.h"
#import "Restaurant.h"
#import "MyBMKPointAnnotation.h"
#import "RestaurantCell.h"
#import "UIImageView+AFNetworking.h"
#import "MessageView.h"
@implementation RestaurantController
@synthesize table,allRestaurants,bmkMapView,restaurantResultController,search;

-(id)initWithShowStyle:(ShowStyle)showStyle{
    self=[super init];
    if (self) {
        self.showStyle=showStyle;
        [self.view setFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-49-45)];
        self.view.backgroundColor=[UIColor grayColor];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"返回";
        [temporaryBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];
        //初始化tableView
        table=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-49-44)];
        table.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapTableViewBg"]];
        self.table.backgroundView = bgImageView;
        [bgImageView release];
        [self.view addSubview:table];
        self.table.delegate=self;
        self.table.dataSource=self;
        allRestaurants=[[NSMutableArray alloc] init];
        UISearchBar *searchBar=[[UISearchBar alloc] init];
        searchBar.placeholder=@"输入餐厅名称或简拼";
        [searchBar setBackgroundImage:[UIImage imageNamed:@"mapTableViewBg"]];
        [searchBar sizeToFit];
        searchBar.delegate=self;
        self.table.tableHeaderView=searchBar;
        restaurantResultController =[[RestaurantResultController alloc] initWithSearchBar:searchBar contentsController:self];
        //初始化餐厅列表
        [[AFRestAPIClient sharedClient] getPath:@"restaurants?city=1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *list = (NSArray*)responseObject;
            NSInteger i=0;
            for (NSDictionary *dic in list) {
                Restaurant *restaurant=[[Restaurant alloc] initWithDictionary:dic];
                [allRestaurants addObject:restaurant];
                //添加地图标记
                MyBMKPointAnnotation* annotation = [[MyBMKPointAnnotation alloc]init];
                CLLocationCoordinate2D coor;
                coor.longitude=restaurant.x;
                coor.latitude=restaurant.y;
                annotation.coordinate = coor;
                annotation.title = restaurant.name;
                annotation.subtitle=@"超级难吃";
                annotation.index=i;
                [self.bmkMapView addAnnotation:annotation];
                [annotation release];
                [restaurant release];
                i++;
            }
            self.bmkMapView.showsUserLocation=YES;
            [[AFRestAPIClient sharedClient] getPath:@"user/favorites" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                NSArray *arr=(NSArray *)responseObject;
                for (Restaurant *res in allRestaurants) {
                    for (NSDictionary *dic in arr) {
                        NSString *ridStr=(NSString *)[dic valueForKey:@"rid"];
                        if (res.rid==[ridStr integerValue]) {
                            res.isFavorite=YES;
                        }
                    }
                }
                if (showStyle==ShowFavorite) {
                    NSArray *array=[self.allRestaurants copy];
                    [self.allRestaurants removeAllObjects];
                    for (Restaurant *res in array) {
                        if (res.isFavorite) {
                            [self.allRestaurants addObject:res];
                        }
                    }
                    [array release];
                    if (allRestaurants.count==0) {
                        MessageView *mv=[[MessageView alloc] initWithMessageText:@"您还没有收藏的餐厅"];
                        [mv show];
                    }
                }
                [self.table reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.table reloadData];
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"错误: %@", error);
            MessageView *mv=[[MessageView alloc] initWithMessageText:@"无法连接到服务器"];
            [mv show];
        }];
        
        if (showStyle==ShowNormal) {
            //初始化右边切换按钮
            UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightButton setFrame:CGRectMake(0, 0, 50, 30)];
            [rightButton setBackgroundImage:[UIImage imageNamed:@"navRightBtn"]forState:UIControlStateNormal];
            [rightButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
            [rightButton setTitle:@"地图" forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(rightBarButtonTouch:)forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
            self.navigationItem.rightBarButtonItem= rightItem;
            [rightItem release];
            isShowMapView=NO;
      }
         search = [[BMKSearch alloc]init];
        search.delegate=self;

    }
    return self;
}


-(void)rightBarButtonTouch:(UIButton *)sender{
    if (!isShowMapView) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1];
        [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
        [self.view bringSubviewToFront:bmkMapView];
        [UIView commitAnimations];
        [sender setTitle:@"列表" forState:UIControlStateNormal];
        isShowMapView=YES;
    }else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1];
        [UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
        [self.view bringSubviewToFront:table];
        [UIView commitAnimations];
        [sender setTitle:@"地图" forState:UIControlStateNormal];
        isShowMapView=NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (bmkMapView.delegate!=self) {
        [self.bmkMapView setFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-49-44)];
       self.bmkMapView.delegate=self;
       [self.view addSubview:self.bmkMapView];
        [self.view bringSubviewToFront:table];
    }
    if (self.isSeachAll) {
        self.navigationItem.rightBarButtonItem= nil;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allRestaurants.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[[RestaurantCell alloc]
				 initWithStyle:UITableViewCellStyleSubtitle
				 reuseIdentifier:SectionsTableIdentifier] autorelease];
        cell.backgroundColor=[UIColor grayColor];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurantTableCellBg"]];
        cell.backgroundView = bgImageView;
        cell.textLabel.backgroundColor=[UIColor clearColor];
        [bgImageView release];
        UIImageView *selectBgImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categoryTablecellSelectBg"]];
        cell.selectedBackgroundView=selectBgImageView;
        [selectBgImageView release];
    }
    Restaurant *restaurant=[self.allRestaurants objectAtIndex:row];
    cell.restaurant=restaurant;
    cell.indexPath=indexPath;
    if (_showStyle==ShowFavorite) {
        cell.isAllowRemoveCell=YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
//跳转到菜单列表
- (void)pushToFoodList:(NSInteger)row {
    Restaurant *restaurant=[allRestaurants objectAtIndex:row];
    NSUserDefaults *us=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionary=[us valueForKey:@"recentBrowse"];
    NSMutableDictionary *recentBrowse=[[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSLog(@"%@",recentBrowse);
    if (recentBrowse!=nil) {
        for (NSString *key in recentBrowse.allKeys) {
            NSDictionary *dic=[recentBrowse objectForKey:key];
            NSString *ridString=[dic valueForKey:@"id"];
            NSNumber *ridNum=[NSNumber numberWithInteger:[ridString integerValue]];
            if (ridNum.integerValue==restaurant.rid) {
                [recentBrowse removeObjectForKey:key];
            }
        }
    }
    NSString *dateStr=[NSString stringWithFormat:@"%@",[NSDate date]];
    [recentBrowse setObject:restaurant.restaurantDictionary forKey:dateStr];
    [us setValue:recentBrowse forKey:@"recentBrowse"];
    [us synchronize];
    [recentBrowse release];
    FoodListController*foodListController=[[FoodListController alloc] initWithRecipe:restaurant];
    [self.navigationController pushViewController:foodListController animated:YES];
    [foodListController release];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self pushToFoodList:indexPath.row];
    [self performSelector:@selector(unselectCurrentRow)
               withObject:nil afterDelay:1.0];

}

#pragma mark -
#pragma mark BMKMapViewDelegate
//更新位置以后
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    BMKCoordinateRegion newRegion;
    newRegion.center=userLocation.coordinate;
    newRegion.span.latitudeDelta  = 0.01;
    newRegion.span.longitudeDelta = 0.01;
    [mapView setRegion:newRegion animated:YES];
    [table reloadData];
    mapView.showsUserLocation=NO;
    
    NSLog(@"%f--%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
//	CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
//	if (_coordinateXText.text != nil && _coordinateYText.text != nil) {
//		pt = (CLLocationCoordinate2D){[_coordinateYText.text floatValue], [_coordinateXText.text floatValue]};
//	}
	BOOL flag = [search reverseGeocode:userLocation.coordinate];
	if (!flag) {
		NSLog(@"search failed!");
	}
}
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
        NSLog(@"------%@",result.addressComponent.city);
	}
}

//添加标注
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor=BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop=YES;
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        MyBMKPointAnnotation *myBMKPointAnnotation=(MyBMKPointAnnotation *)annotation;
        rightButton.tag=myBMKPointAnnotation.index;
        newAnnotationView.rightCalloutAccessoryView = rightButton;
        UIImageView *headImage = [[UIImageView alloc] init];
        NSString *imageUrlString=IMAGESERVERADDRESS;
        Restaurant *restaurant=[self.allRestaurants objectAtIndex:myBMKPointAnnotation.index];
        imageUrlString=[NSString stringWithFormat:@"%@%@",imageUrlString,restaurant.imageUrl];
        [headImage setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"imageWaiting"]];
        [headImage setFrame:CGRectMake(0, 0, 30, 30)];
        newAnnotationView.leftCalloutAccessoryView = headImage;
        [headImage release];
        return [newAnnotationView autorelease];
    }
    return nil;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.restaurantResultController.resultRestaurants removeAllObjects];
    for (Restaurant *aRestaurant in allRestaurants) {
        NSRange textRangeName,textRangePinyin;
        textRangeName =[aRestaurant.name rangeOfString:searchText];
        NSString *pinyin=searchText.lowercaseString;
        textRangePinyin=[aRestaurant.pinyin rangeOfString:pinyin];
        if(textRangeName.location != NSNotFound||textRangePinyin.location!=NSNotFound)
        {
            [self.restaurantResultController.resultRestaurants addObject:aRestaurant];
        }
    }
    [self.restaurantResultController.searchResultsTableView reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (!self.isSeachAll) {
        return;
    }
    NSUserDefaults *us=[NSUserDefaults standardUserDefaults];
    NSString *cityId=[us valueForKey:@"cityId"];

    NSString *pathStr=[NSString stringWithFormat:@"restaurants?city=%@&name=%@",cityId,searchBar.text];
    [[AFRestAPIClient sharedClient] getPath:pathStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.restaurantResultController.resultRestaurants removeAllObjects];
        NSArray *list = (NSArray*)responseObject;
        for (NSDictionary *dic in list) {
            Restaurant *restaurant=[[Restaurant alloc] initWithDictionary:dic];
            [self.restaurantResultController.resultRestaurants addObject:restaurant];
            [restaurant release];
        }
        [self.restaurantResultController.searchResultsTableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MessageView *mv=[[MessageView alloc] initWithMessageText:@"无法连接到服务器"];
        [mv show];
    }];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *sbtn = (UIButton *)cc;
            [sbtn removeFromSuperview];
            [sbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [sbtn setBackgroundImage:[UIImage imageNamed:@"navRightBtn"] forState:UIControlStateNormal];
            [sbtn setBackgroundImage:[UIImage imageNamed:@"navRightBtnHL"] forState:UIControlStateHighlighted];
            [sbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

-(void)showDetails:(UIButton *)sender{
    [self pushToFoodList:sender.tag];
}
- (void) unselectCurrentRow{
    // Animate the deselection
    [self.table deselectRowAtIndexPath:
     [self.table indexPathForSelectedRow] animated:YES];
}

-(void)dealloc{
    [bmkMapView release];
    [allRestaurants release];
    [table release];
    [restaurantResultController release];
    [search release];
    [super dealloc];
}
@end
