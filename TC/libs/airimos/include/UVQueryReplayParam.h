// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVQueryReplayParam.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:查询录像参数类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

@class UVQueryCondition;

/** 查询录像参数类
 
 主要在调用查询录像接口时使用，参考UVServiceManager方法：
 
        - (void)queryReplay:(UVQueryReplayParam*)para_ listener:(void (^)(NSArray *recordList,UVError *error))block_;
 
 */
@interface UVQueryReplayParam : NSObject
//摄像机编码 必要参数
@property(nonatomic,strong) NSString *cameraCode;
//录像开始时间 必要参数
@property(nonatomic,strong) NSString *beginTime;
//录像结束时间 必要参数
@property(nonatomic,strong) NSString *endTime;
//查询条件 参考UVQueryCondition定义 必要参数
@property(nonatomic,strong) UVQueryCondition *queryCondition;
@end
