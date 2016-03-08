// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVResourceInfo.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:资源信息类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

//1; 云台摄像机：2; 高清固定摄像机：3; 高清云台摄像机：4; 车载摄像机：5; 不可控标清摄像机：6; 不可控高清摄像机：7;
#define UV_CAMERA_TYPE_FIX (1)
#define UV_CAMERA_TYPE_PTZ (2)
#define UV_CAMERA_TYPE_FIX_HD (3)
#define UV_CAMERA_TYPE_PTZ_HD (4)
#define UV_CAMERA_TYPE_CAR (5)
#define UV_CAMERA_TYPE_FIX_NO_CTRL (6)
#define UV_CAMERA_TYPE_FIX_NO_CTRL_HD (7)

//组织：1; 摄像机：1001;
#define UV_RES_TYPE_CAMERA (1001)
#define UV_RES_TYPE_ORG (1)

#import <Foundation/Foundation.h>
/** 资源信息类
 
 定义一条资源的相关信息 这里主要指摄像机和组织资源
 
 */
@interface UVResourceInfo : NSObject
//是否在线
@property(nonatomic,assign) BOOL isOnline;
//是否已共享
@property(nonatomic,assign) BOOL isShared;
//资源名称
@property(nonatomic,strong) NSString *resName;
//资源编码
@property(nonatomic,strong) NSString *resCode;
//资源子类型 当type=UV_RES_TYPE_CAMERA时，参考UV_CAMERA_TYPE_系列常量定义
@property(nonatomic,assign) int32_t resSubType;
//资源类型 当前支持UV_RES_TYPE_CAMERA和UV_RES_TYPE_ORG
@property(nonatomic,assign) int32_t resType;

@end
