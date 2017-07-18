// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVStartReplayParam.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:启动回放参数类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

#import <Foundation/Foundation.h>
@class UVRecordInfo,UVStreamInfo;
/** 启动回放参数类
 
 主要在调用启动回放接口时使用，参考UVServiceManager方法：
 
        - (void)startReplay:(UVStartReplayParam*)para_ listener:(void (^)(NSString *playSession,UVError *error))block_;
 
 */
@interface UVStartReplayParam : NSObject
//摄像机编码 必要参数
@property(nonatomic,strong) NSString *cameraCode;
//回放信息 参考UVRecordInfo定义 必要参数
@property(nonatomic,strong) UVRecordInfo *recordInfo;
//定义流信息 参考UVStreamInfo定义 必要参数
@property(nonatomic,strong) UVStreamInfo *streamInfo;

@property(nonatomic,assign) BOOL useTcpConnect;

@end
