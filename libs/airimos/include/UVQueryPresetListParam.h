//  Copyright (c) 2014年 Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVQueryPresetListParam.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 14-2-12
// Author: chenjiaxin/00891
// Description:
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
// 14-2-12  c00891 create
//

#import <Foundation/Foundation.h>
@class UVQueryCondition;
/** 分页查询摄像机的预置位
 */
@interface UVQueryPresetListParam : NSObject
//摄像机编码
@property(nonatomic) NSString *cameraCode;
//分页信息
@property(nonatomic) UVQueryCondition *pageInfo;
@end
