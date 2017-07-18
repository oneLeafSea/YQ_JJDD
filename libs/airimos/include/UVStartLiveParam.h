// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVStartLiveParam.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:启动实况参数类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

@class UVStreamInfo;

/** 启动实况参数类
 
 主要在调用启动实况接口时使用，参考UVServiceManager方法：
 
        - (void)startLive:(UVStartLiveParam*)para_ listener:(void (^)(NSString *playSession,UVError *error))block_;
 
 */
@interface UVStartLiveParam : NSObject
//摄像机编码 必要参数
@property(nonatomic,strong) NSString *cameraCode;
//定义流信息 参考UVStreamInfo定义 必要参数
@property(nonatomic,strong) UVStreamInfo *streamInfo;
//是否使用辅流 必要参数
@property(nonatomic,assign) BOOL useSecondStream;

@end
