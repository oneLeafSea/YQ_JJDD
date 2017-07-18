//  Copyright (c) 2014年 Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVAlarmInfo.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 14-2-11
// Author: chenjiaxin/00891
// Description:
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
// 14-2-11  c00891 create
//

#import <Foundation/Foundation.h>

@interface UVPushMessageInfo : NSObject
//具体类型 参考 CALL_BACK_PROC_TYPE_E, 当前支持:1, 11
@property(nonatomic) int32_t type;
//告警事件编码
@property(nonatomic,strong) NSString *alarmEventCode;
//告警源编码
@property(nonatomic,strong) NSString *alarmSrcCode;
//告警源名称
@property(nonatomic,strong) NSString *alarmSrcName;
//始能后名字
@property(nonatomic,strong) NSString *activeName;
//告警类型 AlARM_TYPE_E
@property(nonatomic) int32_t alarmType;
//告警级别 ALARM_SEVERITY_LEVEL_E
@property(nonatomic) int32_t alarmLevel;
//告警时间
@property(nonatomic,strong) NSString *alarmTime;
//告警描述
@property(nonatomic,strong) NSString *alarmDescription;
//需要联动的摄像机编码
@property(nonatomic,strong) NSString *playCameraCode;
//当前登录用户session
@property(nonatomic,strong) NSString *userSession;

@end
