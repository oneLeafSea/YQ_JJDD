// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVErrorMessage.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:错误码定义类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

#import "UVErrorCode.h"
/** 错误信息类
 
 使用示例：
 
        UVErrorMessage *errormessage = [UVErrorMessage instance];
        NSString mess = [errormessage getMessageByCode:UV_ERROR_COMMON_FAILURE];

 
 该类主要给UVError类使用，请参数UVError
 */
@interface UVErrorMessage : NSObject

/** 实例化对象
 
 建议在使用前，均调用此静态方法
 
 @return UVErrorMessage
 */
+ (UVErrorMessage*)instance;

/** 根据错误码获取具体的错误信息
 
 @param UV_ERROR_CODE_E code_ 错误码，参考UVErrorCode.h定义
 @return NSString 具体的错误信息
 */
 - (NSString*)getMessageByCode:(UV_ERROR_CODE_E)code_;
@end
