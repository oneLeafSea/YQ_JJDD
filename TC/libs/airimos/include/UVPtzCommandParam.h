//  Copyright (c) 2014年 Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVPtzCommandParam.h
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
/** 发送云台指令
 */
@interface UVPtzCommandParam : NSObject
//摄像机编码
@property(nonatomic) NSString *cameraCode;
//方向
@property(nonatomic) int32_t direction;
//速度1
@property(nonatomic) int32_t speed1;
//速度2
@property(nonatomic) int32_t speed2;
@end
