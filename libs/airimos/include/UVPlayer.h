// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVPlayer.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:播放器类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

//包缓存大小
#define STREAM_BUFFER_SIZE  (1024*384)

//队列最大个数 当前默认为100个，如果队列满数据会丢失 注，这里的队列只有在调用AVStreaming有效
#define MAX_STREAM_DATA_COUNT (100)

//读取帧失败最大重试次数
#define MAX_READ_FRAME_FAILURE_COUNT (3)

/**
当前播放状态封装
 */
typedef enum
{
    //正在连接服务器 播放网络流有效
    PLAY_STATUS_CONNECTING = 1,
    //预处理状态
    PLAY_STATUS_PREPARE,
    //正在播放状态
    PLAY_STATUS_OPENED,
    //暂停状态
    PLAY_STATUS_PAUSE,
    //暂停恢复状态
    PLAY_STATUS_RESUME,
    //已经停止状态
    PLAY_STATUS_CLOSED,
    //正在停止状态
    PLAY_STATUS_CLOSING,
} PLAY_STATUS;

typedef struct
{
    int sock;
    char *buffer;
    size_t len;
    char *pos;
} ReadSocket;

//读取流回调函数定义 buf要填充的流数据 len要填充的数据流长度 请返回实际已经填充的数据长度
typedef int (^readStreamListener)(UInt8* buf,int len);

@class UVError;
@protocol UVPlayerDelegate;

/**
 
 使用示例：
 
     UVPlayer *player = [[UVPlayer alloc] init];
     [player AVInitialize:_imageviewPreview];
 
 有两种方法设置流信息，
 方法一， 不断调用:
 
    - (void)AVStreaming:(NSData *)data_;
 
 方法，往缓冲区加入数据。建议网络流使用
 
 方法二，设置readStream回调。程序会不断在调用readStream这个回调方法来获取流数据，示例代码：
    
    player.readStream = ^(UInt8 *buf,int buf_size){
        NSData *data = <你的数据流>;
        const char* bytes = [data bytes];
        memcpy(buf, bytes, [data length]);
        return [data length];
    };
 
 该方法建议在本地文件流或内存数据流中使用。
 
其它说明：
 
- 方法二执行过程优先于方法一，二者不能并存
- 方法二的 buf_size 的大小默认是1024*384(参考 STREAM_BUFFER_SIZE 的定义)，而 NSData 的数据不一定有这么大，可以使用循环填充到足够的数据后再返回
 
 */
@interface UVPlayer : NSObject

@property(nonatomic,weak) id<UVPlayerDelegate> delegate;

@property (assign, nonatomic) BOOL isClosed;

//是否静音
@property(nonatomic,assign) BOOL isMute;

@property(nonatomic,assign) BOOL isPaused;

//如果设置为nil，则默认从用户调用AVStreaming函数输入的流中获取；如果用户有自定义，则AVStreaming函数写数据流将无效 用户只要自行填充readStreamListener中定义的buf数据即可
@property(nonatomic,strong)  readStreamListener readStream;

 //录像线程，主要用于录像。如果不指定，则使用共享线程
@property(nonatomic,assign) dispatch_queue_t recordQueue;

//readonly
//是否正在录像
@property(nonatomic,assign,readonly) BOOL isRecording;

//当前播放状态
@property(nonatomic,assign,readonly) PLAY_STATUS playStatus;

//当前是否在播放中 (注:非关闭状态都会返回YES)
@property(nonatomic,assign,readonly,getter = getIsPlaying) BOOL isPlaying;

@property(nonatomic, readwrite) ReadSocket *rsock;

/**
  初始化对象
 
 @param UVFFmpegDelegate deletgate
 @return 返回初始化后的对象
 @see UVFFmpegDelegate:
 */
- (id)initWithDelegate:(id<UVPlayerDelegate>)delegate_;

/** 初始化

 @param UIImageView preview_ 要显示实况的imageview
 @return YES 操作成功
 */
- (void)AVInitialize:(UIImageView*)preview_;

/** 启动视频播放 播放成功将触发PLAY_STATUS状态回调 否则触发onPlayOnError
 
 @return YES 操作成功
 */
- (BOOL)AVStartPlay;

/**停止播放 将触发PLAY_STATUS状态回调
 
 */
- (BOOL)AVStopPlay;

/** 启动录像
 
 @param NSURL url_ 要录像的文件
 @return BOOL YES为操作成功 NO为操作失败
 */
- (BOOL)startRecord:(NSURL*)url_;

/**停止录像 将触发onRecordStatus状态回调
 
 */
- (BOOL)stopRecord;

/** 输入视频流信息到播放队列
 
 @param NSData data_ 视频流数据
 @return BOOL YES表示写入缓存成功 NO为失败(失败一般是因为缓冲已满)
 */
- (BOOL)AVStreaming:(NSData *)data_;

/** 改变视图大小
 
 @param NSInteger w 视频宽
 @param NSInteger h 视频高
 */
- (void) changeDisplaySize:(NSInteger)w_ height:(NSInteger)h_;

/** 抓拍
 
 @param NSURL path_ 抓拍保存路径
 */
- (void) snatch:(NSURL*)path_;

//内部调用
- (void) recordFile:(UInt8 *)buf len:(int) len;
@end

