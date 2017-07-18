// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVError.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:错误封装类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

#import "UVErrorCode.h"
/** 错误封装类
 
 错误产生后，通常通过这个类查看到相关的错误信息，示例代码：
 
        UVLog("error:%@",error);
 
 */
@interface UVError :NSObject
//错误码
@property(nonatomic,assign,readonly) NSInteger code;
//具体错误信息
@property(nonatomic,assign,readonly) NSString *message;

/** 根据错误码实例化一个错误类
 
 @param UV_ERROR_CODE_E code_ 错误码 参考UVErrorCode.h的定义
 @return UVError 错误类
 */
+ (id)errorWithCode:(UV_ERROR_CODE_E)code_;

/** 根据错误码和错误信息实例化一个错误类
 
 @param NSInteger code_ 错误码 自已指定的任何整数错误码 建议不要和系统错误码冲突
 @param NSString msg_ 错误描述
 @return UVError 错误类
 */
+ (id)errorWithCodeAndMessage:(NSInteger)code_ message:(NSString*)msg_;
@end
