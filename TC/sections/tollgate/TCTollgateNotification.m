//
//  TCTollgateNotification.m
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/29.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCTollgateNotification.h"
#import "TCTableRef.h"
#import <QuartzCore/QuartzCore.h>

@interface TCTollgateNotification()

@property (nonatomic, copy) NSString *msgid;
@end

@implementation TCTollgateNotification

+ (NSArray *)notificationArray:(RTWSMsg *)msg {
    NSArray *arr = msg.params[@"data"];
    __block NSMutableArray *notificationArray = [[NSMutableArray alloc] initWithCapacity:5];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = obj;
        TCTollgateNotification *n = [[self alloc] initWithDict:dict];
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
    self.alarmType = dict[@"alarmType"];       // 告警类型
    self.alarmCode = dict[@"alarmCode"];       // 违法代码
    self.alarmContent = dict[@"alarmContent"];    // 违法内容
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



- (BOOL)insertToDbWithDbq:(FMDatabaseQueue *)dbq {
    __block BOOL ret = YES;
    [dbq inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ret = [db executeUpdate:kSqlTollagtePushInsert, self.msgid, self.deviceId, self.alarmType, self.alarmCode, self.alarmContent, self.plateCode, self.location, self.capTime, self.speed, self.laneNo, self.direction, self.logo, self.plateConfidence, self.plateColor, self.vehicleType, self.vehicleColor, self.imgUrl, self.plateCodeUrl];
    }];
    return ret;
}

+ (NSArray *)getNotificationWithDbq:(FMDatabaseQueue *)dbq ByLimit:(NSInteger )limit {
    __block NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    [dbq inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSNumber *l = [NSNumber numberWithInteger:limit];
        FMResultSet *rs = [db executeQuery:kSqlTollageQueryWithLimit, l];
        while ([rs next]) {
            TCTollgateNotification *tn = [[TCTollgateNotification alloc] init];
            tn.msgid = [rs stringForColumn:@"msgid"];
            tn.deviceId = [rs stringForColumn:@"deviceId"];
            tn.alarmType = [rs stringForColumn:@"alarmType"];
            tn.alarmCode = [rs stringForColumn:@"alarmCode"];
            tn.alarmContent = [rs stringForColumn:@"alarmContent"];
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


+ (BOOL)truncateNoificationsWithDbq:(FMDatabaseQueue *)dbq {
    __block BOOL ret = YES;
    [dbq inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ret = [db executeUpdate:kSqlTollageTruncate];
    }];
    return ret;
}

@end
