// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVStreamPlayer.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:网络流播放器
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

#import "UVPlayer.h"
//每次接收数据包大小
#define MEM_SOCK_CACHE   (4096)

/** socket连接类型
 
 */
typedef enum
{
    //使用TCP进行连接 默认
    UV_SOCKET_CONNECT_TCP = 1,
    //使用UDP进行连接
    UV_SOCKET_CONNECT_UDP
} UV_SOCKET_CONNECT_TYPE;

/** 网络流播放器
 
 使用示例：
 
    UVStreamPlayer *player = [[UVStreamPlayer alloc] init];
    [player AVInitialize:_imageviewPreview];
    player.session = @"2224242434";
    NSUrl *url = [NSURL UrlWithString:@"udp://192.168.1.2:5555"];
    [player AVStartPlay:url];

 */
@interface UVStreamPlayer : UVPlayer

//当前播放在地址
@property(nonatomic,strong,readonly) NSURL *url;

//socket连接类型 由url确认
@property(nonatomic,assign,readonly) UV_SOCKET_CONNECT_TYPE connectType;
//当前播放session
@property(nonatomic,strong,readonly) NSString *playSession;
//当前是否已经连接
@property(nonatomic,readonly) BOOL isConnected;
//当前socket id
@property(nonatomic,readonly) ReadSocket socket;
//当前socket队列
@property(nonatomic,readonly) dispatch_queue_t socket_queue;
//当前状态是否正在连接中
@property(nonatomic,readonly) BOOL isConnecting;

/** 播放一个网络流
 
 @param NSURL url_ 要播放的地址
 */
- (BOOL)AVStartPlay:(NSURL*)url_;
/** 播放一个网络流
 
 @param NSURL url_ 要播放的地址
 @param NSString playSession_ 播放session
 */
- (BOOL)AVStartPlay:(NSURL*)url_ session:(NSString*)playSession_;
/** 暂停播放
 
 @param BOOL isPaused 暂停
 */
- (void)setIsPaused:(BOOL)isPaused;
/** 停止播放
 
 */
- (BOOL)AVStopPlay;
/** 断开连接 在播放过程中异常中止，但是可能连接并没有断开，请手动调用此方法断开
 
 */
- (void)disConnect;
@end
