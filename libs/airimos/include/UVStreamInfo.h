// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVStreamInfo.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:流信息类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

//支持分辨率枚举
typedef enum tagStreamResolutionEnum
{
    UV_STREAM_RESOLUTION_D1 = 1,
    UV_STREAM_RESOLUTION_4CIF,
    UV_STREAM_RESOLUTION_2CIF,
    UV_STREAM_RESOLUTION_CIF,
    UV_STREAM_RESOLUTION_QCIF,
    UV_STREAM_RESOLUTION_720P,
}UV_STREAME_RESOLUTION_E;

/** 流信息类
 
 定义流格式、分辨率、码率等相关信息
 
 */
@interface UVStreamInfo : NSObject
//码率
@property(nonatomic,assign) int32_t  bitRate;
//帧率
@property(nonatomic,assign) int32_t frameRate;
//分辨率
@property(nonatomic,assign) int32_t resolution;
//模式，目前暂没有使用
@property(nonatomic,assign) int32_t mode;
//强制模式 目前暂没有使用
@property(nonatomic,assign) BOOL force;
//声音控制
@property(nonatomic,assign) BOOL audioOn;

/** 获取默认流信息
 
 @return UVStreamInfo 默认流信息定义
 */
+ (UVStreamInfo*)defaultStreamInfo;
@end
