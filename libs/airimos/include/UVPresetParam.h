//  Copyright (c) 2014年 Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVPresetParam.h
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
/** 预置位
 */
@interface UVPresetParam : NSObject
//摄像机编码
@property(nonatomic) NSString *cameraCode;
//预置位值
@property(nonatomic) int32_t presetValue;
@end
