//  Copyright (c) 2014年 Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVPresetInfo.h
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
/** 预置位信息 
 */
@interface UVPresetInfo : NSObject
//预置位值, 取值范围为PTZ_PRESET_MINVALUE~服务器配置文件里配置的预置位最大值
@property(nonatomic) int32_t presetValue;
//预置位描述
@property(nonatomic) NSString *presetDesc;
@end
