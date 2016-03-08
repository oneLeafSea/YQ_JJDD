//
//  TCTollgateNotification.h
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/29.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTWSMsg.h"
#import <FMDB.h>

@interface TCTollgateNotification : NSObject

+ (NSArray *)notificationArray:(RTWSMsg *)msg;

@property(nonatomic, copy) NSString *deviceId;        // 卡口编码
@property(nonatomic, copy) NSString *alarmType;       // 告警类型
@property(nonatomic, copy) NSString *alarmCode;       // 违法代码
@property(nonatomic, copy) NSString *alarmContent;    // 违法内容
@property(nonatomic, copy) NSString *plateCode;       // 车牌号码
@property(nonatomic, copy) NSString *location;        // 卡口名称
@property(nonatomic, copy) NSString *capTime;         // 违法时间
@property(nonatomic, copy) NSString *speed;           // 过车速度
@property(nonatomic, copy) NSString *laneNo;          // 车道号
@property(nonatomic, copy) NSString *direction;       // 车道方向
@property(nonatomic, copy) NSString *logo;            // 车标
@property(nonatomic, copy) NSString *plateConfidence; // 车牌置信度
@property(nonatomic, copy) NSString *plateColor;      // 车牌颜色
@property(nonatomic, copy) NSString *vehicleType;     // 车辆类型
@property(nonatomic, copy) NSString *vehicleColor;    // 车辆颜色
@property(nonatomic, copy) NSString *imgUrl;          // 合成图URL
@property(nonatomic, copy) NSString *plateCodeUrl;    // 号牌URL

- (BOOL)insertToDbWithDbq:(FMDatabaseQueue *)dbq;

+ (NSArray *)getNotificationWithDbq:(FMDatabaseQueue *)dbq ByLimit:(NSInteger )limit;

+ (BOOL)truncateNoificationsWithDbq:(FMDatabaseQueue *)dbq;

@end
