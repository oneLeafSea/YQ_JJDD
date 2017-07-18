// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
//  AirIMOSIphoneSDK.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:入口类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

#pragma mark - param
#import "UVLog.h"
#import "UVLoginParam.h"
#import "UVQueryReplayParam.h"
#import "UVQueryResourceParam.h"
#import "UVStartLiveParam.h"
#import "UVStartReplayParam.h"
#import "UVQueryCondition.h"

#pragma mark - objects
#import "UVRecordInfo.h"
#import "UVResourceInfo.h"
#import "UVStreamInfo.h"

#pragma mark - public
#import "UVError.h"
#import "UVInfoManager.h"

#pragma mark - include
#import "UVConest.h"
#import "UVErrorMessage.h"

#pragma mark - class
#import "UVUtils.h"
#import "UVServiceManager.h"

#import "UVAudioQueue.h"
#import "UVPlayer.h"
#import "UVPlayerDelegate.h"
#import "UVFilePlayer.h"
#import "UVPushMessageInfo.h"
#import "UVStreamPlayer.h"
/** 头文件入口类
 
 建议只要包括此头文件即可
 
 */
@interface AirIMOSIphoneSDK : NSObject

@end
