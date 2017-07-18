// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVPlayerDelegate.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:播放器回调类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

/** 播放回调类
 
 参考 UVPlayer :
    
    UVPlayer *player = [[UVPlayer alloc] initWithDelegate:self];
 

 */
#import "UVPlayer.h"
#import "UVError.h"

@protocol UVPlayerDelegate <NSObject>
@optional
/** 播放失败
 
 @param UVplayer sender_ 当前播放器对象
 @param UVError error_ 错误信息
 @see UVPlayer
 @see UVError
 */
- (void)onPlayError:(UVPlayer*)sender_ error:(UVError*)error_;

/** 播放状态
 
 @param UVPlayer sender_ 当前播放器对象
 @param PLAY_STATUS status_ 当前播放状态
 @see UVPlayer
 */
- (void)onPlayStatus:(UVPlayer*)sender_ status:(PLAY_STATUS)status_;

/** 录像状态
 
 @param UVPlayer sender_ 当前播放器对象
 @param BOOL status_ YES为正在录像 NO为已停止录像
 @see UVPlayer
 */
- (void)onRecordStatus:(UVPlayer*)sender_ status:(BOOL)status_;

/** 静音
 
 @param UVPlayer sender_ 当前播放器对象
 @param BOOL status_ YES为已静音 NO未静音
 @see UVplayer
 */
- (void)onMuteStatus:(UVPlayer*)sender_ status:(BOOL)status_;

/** 抓拍
 
 @param UVPlayer sender_ 当前播放器对象
 @param NSURL path_ 抓拍图片保存的完整路径
 @param UVError error_ 错误信息 如果操作成功则返回nil
 @see UVPlayer
 @see UVError
 */
- (void)onSnatchStatus:(UVPlayer*)sender_ path:(NSURL*)path_ error:(UVError*)error_;
@end
