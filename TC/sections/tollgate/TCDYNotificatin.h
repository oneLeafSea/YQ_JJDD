//
//  TCDYNotificatin.h
//  TC
//
//  Created by guozw on 16/8/24.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTDYMsg.h"

#import <FMDB.h>

@interface TCDYNotificatin : NSObject

+ (NSArray *)notificationArray:(RTDYMsg *)msg;

@property(nonatomic, copy) NSString *deviceId;        // 卡口编码
//@property(nonatomic, copy) NSString *alarmType;       // 告警类型
//@property(nonatomic, copy) NSString *alarmCode;       // 违法代码
//@property(nonatomic, copy) NSString *alarmContent;    // 违法内容
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
//@property(nonatomic,copy)NSString *alarmControlType;//布控告警类型
//@property(nonatomic,copy)NSString *alarmControlContent;//布控告警内容


- (BOOL)insertToDYDbWithDbq:(FMDatabaseQueue *)dbq;
+ (NSArray *)getNotificationDYWithDbq:(FMDatabaseQueue *)dbq ByLimit:(NSInteger )limit;

+ (BOOL)truncateNoificationsDYWithDbq:(FMDatabaseQueue *)dbq;

@end
