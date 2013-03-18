//
//  HistoryOrder.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-17.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "HistoryOrder.h"
#import "AFRestAPIClient.h"
@implementation HistoryOrder
@synthesize restaurantName,rid,oid,number,starttime,year,month,day,hour,second,week,status,money;
-(id)initWithDictionary:(NSDictionary*) dictionary{
    self=[super init];
    if (self) {
        self.restaurantName=[dictionary valueForKey:@"restaurant"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        self.starttime= [dateFormatter dateFromString:[dictionary valueForKey:@"time"]];
        [dateFormatter release];
        NSNumber *numOid=[dictionary valueForKey:@"oid"];
        oid=numOid.integerValue;
        NSNumber *numRid=[dictionary valueForKey:@"rid"];
        rid=numRid.integerValue;
        NSNumber *numStatus=[dictionary valueForKey:@"status"];
        status=numStatus.integerValue;
        NSNumber *numNumber=[dictionary valueForKey:@"number"];
        number=numNumber.integerValue;
        NSNumber *numMoney=[dictionary valueForKey:@"money"];
        money=numMoney.floatValue;
        //初始日期详细
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:self.starttime];
        year=[comps year];
        month = [comps month];
        day = [comps day];
        hour = [comps hour];
        week=[self weekWithNum:[comps weekday]];
        [calendar release];
        
    }
    return  self;
}

-(NSString *)weekWithNum:(NSInteger)num{
    NSString *nowweekstr=nil;
    switch (num)
    {
        case 2:
            nowweekstr=@"星期一";
            break;
        case 3:
            nowweekstr=@"星期二";
            break;
        case 4:
            nowweekstr=@"星期三";
            break;
        case 5:
            nowweekstr=@"星期四";
            break;
        case 6:
            nowweekstr=@"星期五";
            break;
        case 7:
            nowweekstr=@"星期六";
            break;
        case 1:
            nowweekstr=@"星期日";
            break;
    }
    return nowweekstr;
}

+(void)historyOrder:(historyOrderSuccess)order failue:(historyOrderFailure)failure{
    NSString *path=[NSString stringWithFormat:@"user/history"];
    [[AFRestAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *tempOrders=(NSArray *)responseObject;
        NSMutableArray *orders=[[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in tempOrders) {
            HistoryOrder *aHistoryOrder=[[HistoryOrder alloc] initWithDictionary:dictionary];
            [orders addObject:aHistoryOrder];
            [aHistoryOrder release];
        }
        order([orders autorelease]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        failure();
    }];
    
}
-(NSString *)yearMouthDayWeek{
    NSString *ymd=[NSString stringWithFormat:@"%d年%d月%d日(%@)",year,month,day,week];
    return ymd;
}

-(void)dealloc{
    [starttime release];
    [restaurantName release];
    [week release];
    [super dealloc];
}
@end
