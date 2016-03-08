// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVRecordInfo.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:录像信息类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

/** 录像信息类
 
 定义一条录像的相关信息
 
 */
@interface UVRecordInfo : NSObject
//录像开始时间
@property(nonatomic,strong) NSString *beginTime;
//录像结束时间
@property(nonatomic,strong) NSString *endTime;
//录像文件名
@property(nonatomic,strong) NSString *fileName;

@end
