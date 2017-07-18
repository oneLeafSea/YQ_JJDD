// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVFilePlayer.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:文件播放器类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

#import <Foundation/Foundation.h>
#import "UVPlayer.h"
/** 文件播放类
  具体使用方法参考demo
 
 */
@interface UVFilePlayer : UVPlayer

@property(nonatomic,strong,readonly) NSURL *url;
@property(nonatomic,strong,readonly) NSFileHandle *fp;
@property(nonatomic,assign,readonly) unsigned long long totalLength;
@property(nonatomic,assign,readonly) unsigned long long pos;

/** 播放一个文件
 
 @param NSURL url_ 要播放的文件详细地址
 */
- (BOOL)AVStartPlay:(NSURL*)url_;

@end
