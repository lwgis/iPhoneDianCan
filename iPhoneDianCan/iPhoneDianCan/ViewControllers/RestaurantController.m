//
//  RestaurantController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-9.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RestaurantController.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFRestAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "Restaurant.h"

@interface RestaurantController ()
@end

@implementation RestaurantController
@synthesize table,allRestaurants;
-(id)init{
    self=[super init];
    if (self) {
        [self.view setFrame:CGRectMake(0, 0, 320, screenHeight-49)];
        self.view.backgroundColor=[UIColor grayColor];
        self.title=@"餐厅列表";
        //初始化map
        bmkMapView=[[BMKMapView alloc] initWithFrame:self.view.frame];
        bmkMapView.alpha=0;
        bmkMapView.delegate=self;
        [self.view addSubview:bmkMapView];
        //初始化tableView
        table=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, screenHeight-49-44)];
        table.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapTableViewBg"]];
        self.table.backgroundView = bgImageView;
        [bgImageView release];
        table.alpha=0;
        [self.view addSubview:table];
        self.table.delegate=self;
        self.table.dataSource=self;
        allRestaurants=[[NSMutableDictionary alloc] init];
        //初始化餐厅列表
        [[AFRestAPIClient sharedClient] getPath:@"restaurants" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *list = (NSArray*)responseObject;
            NSInteger i=0;
            for (NSDictionary *dic in list) {
                Restaurant *restaurant=[[Restaurant alloc] initWithDictionary:dic];
                [allRestaurants setValue:restaurant forKey:[NSString stringWithFormat:@"%d", i]];
                [restaurant release];
                i++;
            }
            bmkMapView.showsUserLocation=YES;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"错误: %@", error);
            
        }];
    }
    //初始化右边切换按钮
    UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightButton setFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"switchMap"]forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [rightButton setTitle:@"地图" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonTouch:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    [rightItem release];
    return self;
}
-(void)rightBarButtonTouch:(UIButton *)sender{
    if (sender.titleLabel.text==@"地图") {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1];
        [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
        [self.view bringSubviewToFront:bmkMapView];
        [UIView commitAnimations];
        [sender setTitle:@"列表" forState:UIControlStateNormal];
    }else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1];
        [UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
        [self.view bringSubviewToFront:table];
        [UIView commitAnimations];
        [sender setTitle:@"地图" forState:UIControlStateNormal];

    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:SectionsTableIdentifier] autorelease];
    }
    cell.backgroundColor=[UIColor grayColor];
    NSString *key=[allRestaurants.allKeys objectAtIndex:row];
    Restaurant *restaurant=[self.allRestaurants valueForKey:key];
    cell.textLabel.text = restaurant.name;
    [cell.imageView setImage:[UIImage imageNamed:@"dcs.jpg"]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurantTableCellBg"]];
    cell.backgroundView = bgImageView;
    cell.textLabel.backgroundColor=[UIColor clearColor];
    [bgImageView release];
    //添加地图标记
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.longitude=restaurant.x;
    coor.latitude=restaurant.y;
    annotation.coordinate = coor;
    annotation.title = restaurant.name;
    annotation.subtitle=@"超级难吃";
    [bmkMapView addAnnotation:annotation];
    [annotation release];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     FoodListController*foodListController=[[FoodListController alloc] init];
    NSString *key=[allRestaurants.allKeys objectAtIndex:indexPath.row];
    Restaurant *restaurant=[allRestaurants objectForKey:key];
    foodListController.rid=restaurant.rid;
    foodListController.title=restaurant.name;
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    [temporaryBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
    [self.navigationController pushViewController:foodListController animated:YES];
    [foodListController release];
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
    [self.table reloadData];
    [UIView animateWithDuration:1 animations:^{
        self.table.alpha=1;
        bmkMapView.alpha=1;
    }];
    mapView.showsUserLocation=NO;
}
//添加标注
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor=BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop=YES;
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        newAnnotationView.rightCalloutAccessoryView = rightButton;
        UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dcs.jpg"]];
        [headImage setFrame:CGRectMake(0, 0, 30, 30)];
        newAnnotationView.leftCalloutAccessoryView = headImage;
        [headImage release];
        return [newAnnotationView autorelease];
    }
    return nil;
}
-(void)dealloc{
    [bmkMapView release];
    [allRestaurants release];
    [table release];
    [super dealloc];
}
@end
