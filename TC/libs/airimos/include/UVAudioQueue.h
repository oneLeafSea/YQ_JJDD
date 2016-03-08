// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVAudioQueue.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:音频解码类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#define MAX_CODEC_NAME_LANGTH 32
#define kAudioBufferSeconds 3
#define NUM_BUFFERS 3

#define kBufferDurationSeconds .5


typedef struct {
    //codec_id 暂时没有使用
    int codec_id;
    //名称 暂时没有使用
    char codec_name[MAX_CODEC_NAME_LANGTH];
    //采样率 如8000
    int sample_rate;
    //帧
    int frame_size;
    //通道数
    int channels;
}UVCodecContext;

@interface UVAudioQueue : NSObject
@property(nonatomic,strong,readonly) NSMutableArray *dataQueue;
@property(nonatomic,assign,readonly) BOOL isPlaying;
//是否暂停 
@property(nonatomic,assign) BOOL isPaused;
//录音相关属性
//音频文件句柄
@property(nonatomic,assign,readonly) AudioFileID mRecordFile;
@property(nonatomic,assign,readonly) BOOL isRecroding;
//当前录音文件包数量
@property(nonatomic,assign) UInt32 mRecordPacket;

/** 使用音频UVCodecContext进行初始化 目前只支持PCM音频格式

 @param UVCodecContext codec_ 音频UVCodecContext
 @return id
 */
- (id)initWithCodec:(UVCodecContext)codec_;

/** 播放

 @return BOOL
 */
- (BOOL)play;

/** 停止
 
 @return void
 */
- (void)stop;

/** 向播放缓冲区增加播放数据

 @param NSData packet_ 音频包
 @return void
 */
- (void)addData:(NSData*)data_;

- (NSInteger)getQueueSize;

//self audio callback
- (void)audioQueueOutputCallback:(AudioQueueRef)inAQ inBuffer:(AudioQueueBufferRef)buffer;
- (void)audioQueueIsRunningCallback;
@end
