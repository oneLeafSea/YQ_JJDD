// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVConest.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

#ifndef AirIMOSIphoneSDK_UVConest_h
#define AirIMOSIphoneSDK_UVConest_h

#pragma mark - 全局定义
//临时目录
#define TEMP_FILE_PATH(name_) [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), name_]]

//当前IOS版本
#define UV_IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#pragma mark - 通知相关
//登录成功通知
#define UV_NOTICATION_LOGIN @"notication_login"

//退出登录通知
#define UV_NOTICATION_LOGOUT @"notication_logout"

//告警事件
#define UV_NOTICATION_ALARM @"notication_alarm"

// -------------------
#pragma mark - 通知对象定义的键值相关
//用户会话
#define UV_NOTICATION_KEY_USER_SESSION @"notication_key_user_session"

//是否是自动登录 只有UV_NOTICATION_LOGIN和UV_NOTICATION_LOGOUT两个通知有效
#define UV_NOTICATION_KEY_AUTO_LOGIN_LOGOUT @"notication_key_auto_login_logout"


#define UV_NOTICATION_KEY_ALARM_LIST @"notication_key_alarm_list"

#endif
