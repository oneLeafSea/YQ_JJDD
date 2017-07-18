// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVUtils.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:工具函数类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

#import <Foundation/Foundation.h>
/** 工具类
 
 使用示例：
 
        NSString *date = [UVUtils stringFromTime:[NSDate date]];
 
 */
@interface UVUtils : NSObject

/** 获取指定时间字符串 返回格式如 2013-11-15 05:12:30
 
 @param NSDate 要转换的时间
 @return NSString 返回格式化后的时间字符串
 */
+(NSString*)stringFromTime:(NSDate*)date_;

/** 返回md5加密串
 
 @param NSString 要加密的明文串
 @return NSString 返回加密后的32位md5密文
 */
+ (NSString *) md5passwd: (NSString *) passwd;

- (long)intervalFromLastDate:(NSString *)dateString1  toTheDate:(NSString *)dateString2;

@end
