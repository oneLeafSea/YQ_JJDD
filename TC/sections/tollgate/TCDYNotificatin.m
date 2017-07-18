//
//  TCDYNotificatin.m
//  TC
//
//  Created by guozw on 16/8/24.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCDYNotificatin.h"

#import "TCTableRef.h"
#import <QuartzCore/QuartzCore.h>

@interface TCDYNotificatin()

@property (nonatomic, copy) NSString *msgid;
@end

@implementation TCDYNotificatin

+ (NSArray *)notificationArray:(RTDYMsg *)msg {
    NSArray *arr = msg.params[@"data"];
    //NSString *str=msg.params[@"data"];
    //NSLog(@"%@",str);
    // NSLog(@"%d",(int)arr.count);
    if ((NSNull*)arr==[NSNull null]) {
        NSLog(@"*******");
        return false;
    }
    __block NSMutableArray *notificationArray = [[NSMutableArray alloc] initWithCapacity:5];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = obj;
        TCDYNotificatin *n = [[self alloc] initWithDict:dict];
        if (n) {
            [notificationArray addObject:n];
        }
    }];
    return notificationArray;
    
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self parseDict:dict];
    }
    return self;
}

- (void)parseDict:(NSDictionary *)dict {
    self.msgid = dict[@"msgId"];
    self.deviceId = dict[@"deviceId"];        // 卡口编码
   // self.alarmType = dict[@"alarmType"];       // 告警类型
    //self.alarmControlType=dict[@"alarmControlType"];//布控告警类型
    //self.alarmControlContent=dict[@"alarmControlContent"];//布控告警内容
    //self.alarmCode = dict[@"alarmCode"];       // 违法代码
   // self.alarmContent = dict[@"alarmContent"];    // 违法内容
    self.plateCode = dict[@"plateCode"];       // 车牌号码
    self.location = dict[@"location"];        // 卡口名称
    self.capTime = dict[@"capTime"];         // 违法时间
    self.speed = dict[@"speed"];           // 过车速度
    self.laneNo = dict[@"laneNo"];          // 车道号
    self.direction = dict[@"direction"];       // 车道方向
    self.logo = dict[@"logo"];            // 车标
    self.plateConfidence = dict[@"plateConfidence"]; // 车牌置信度
    self.plateColor = dict[@"plateColor"];      // 车牌颜色
    self.vehicleType = dict[@"vehicleType"];     // 车辆类型
    self.vehicleColor = dict[@"vehicleColor"];    // 车辆颜色
    self.imgUrl = dict[@"imgUrl"];          // 合成图URL
    self.plateCodeUrl = dict[@"plateCodeUrl"];    // 号牌URL
}



- (BOOL)insertToDYDbWithDbq:(FMDatabaseQueue *)dbq {
    __block BOOL ret = YES;
    [dbq inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ret = [db executeUpdate:kSqlTollagteDYPushInsert, self.msgid, self.deviceId, self.plateCode, self.location, self.capTime, self.speed, self.laneNo, self.direction, self.logo, self.plateConfidence, self.plateColor, self.vehicleType, self.vehicleColor, self.imgUrl, self.plateCodeUrl];
    }];
    return ret;
}

+ (NSArray *)getNotificationDYWithDbq:(FMDatabaseQueue *)dbq ByLimit:(NSInteger )limit {
    __block NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    [dbq inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSNumber *l = [NSNumber numberWithInteger:limit];
        FMResultSet *rs = [db executeQuery:kSqlTollageDYQueryWithLimit, l];
        while ([rs next]) {
            TCDYNotificatin *tn = [[TCDYNotificatin alloc] init];
            tn.msgid = [rs stringForColumn:@"msgid"];
            tn.deviceId = [rs stringForColumn:@"deviceId"];
            
            tn.plateCode = [rs stringForColumn:@"plateCode"];
            tn.location = [rs stringForColumn:@"location"];
            tn.capTime = [rs stringForColumn:@"capTime"];
            tn.speed = [rs stringForColumn:@"speed"];
            tn.laneNo = [rs stringForColumn:@"laneNo"];
            tn.direction = [rs stringForColumn:@"direction"];
            tn.logo = [rs stringForColumn:@"logo"];
            tn.plateConfidence = [rs stringForColumn:@"plateConfidence"];
            tn.plateColor = [rs stringForColumn:@"plateColor"];
            tn.vehicleType = [rs stringForColumn:@"vehicleType"];
            tn.vehicleColor = [rs stringForColumn:@"vehicleColor"];
            tn.imgUrl = [rs stringForColumn:@"imgUrl"];
            tn.plateCodeUrl = [rs stringForColumn:@"plateCodeUrl"];
            [arr addObject:tn];
        }
        [rs close];
    }];
    return arr;
}


+ (BOOL)truncateNoificationsDYWithDbq:(FMDatabaseQueue *)dbq {
    __block BOOL ret = YES;
    [dbq inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ret = [db executeUpdate:kSqlTollageDYTruncate];
    }];
    return ret;
}

@end
