// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
//  UVLog.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:日志类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//
#import "UVServiceManager.h"
#ifndef AirIMOSIphoneSDK_UVLog_h
#define AirIMOSIphoneSDK_UVLog_h
/*# define UVLog(fmt, ...) UVLog((@"[%s][%s] [%d]" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);*/
#define UVLog(fmt, ...) if([UVServiceManager instance].isDebug){NSLog((@"[%s:%d]:" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif
