// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVServiceManager.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:服务类 调用接口主要通过此类调用
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//
@class UVInfoManager,UVError;
@class UVLoginParam,UVQueryReplayParam,UVQueryResourceParam,UVStartLiveParam,UVStartReplayParam,UVGetReplayPosParam;
@class UVGpsInfo,UVPtzCommandParam;
@class imosClient,TSocketClientEx,TBinaryProtocol;
@class UVPresetInfo, UVPresetParam, UVQueryPresetListParam;

/** 全局通信服务类
 
 和后台通信都是通过个类进行，使用示例：
 
    UVServiceManager *manage = [UVServiceManager instance]
 
 如果执行请求失败，会抛出 UVError 异常
 */
@interface UVServiceManager : NSObject
    
@property(assign,nonatomic,readonly) BOOL isDebug;
//登录成功后，返回UVInfoManager类定义的相关信息；
@property(strong,nonatomic,readonly) UVInfoManager *info;
@property(nonatomic,readonly) imosClient *client;
/** 使用用户信息实例化对象
 
 @return UVServiceManager
 */
- (id)initWithInfo:(UVInfoManager*)info_;
/** 实例化对象
 
 建议在使用前，均调用此静态方法
 
 @return UVServiceManager
 */
+ (UVServiceManager*)instance;
/** 是否开启调试模式
 
 调试模式会打印大量的日志信息，方便调试；但同时也会牺牲性能，建议在发布后关闭
 
 @param BOOL 开启状态 默认为关闭 
 */
- (void)enableDebug:(BOOL)debug_;

/** 切换当前用于操作的UVInfoManage信息，单服务器情况下不需要设置
 */
- (void)setInfo:(UVInfoManager *)info;

/** 用户登录 登录成功后会自动设置当前的UVInfoManager信息
 
 @param UVLoginParam param_ 登录参数 请参考 UVLoginParam 定义
 @return  UVInfoManager  登录成功返回 UVInfoManager 信息
 @see UVLoginParam
 @see UVInfoManager
 @see UVError
 */
- (UVInfoManager*)login:(UVLoginParam*)para_;

/** 用户登录 登录成功后会自动设置当前的UVInfoManager信息
 
 @param UVLoginParam param_ 登录参数 请参考 UVLoginParam 定义
 @param  UVInfoManager info_ 预设的UVInfoManage 登录成功后自动填充登录信息
 @see UVLoginParam
 @see UVInfoManager
 @see UVError
 */
- (UVInfoManager*)login:(UVLoginParam*)para_ info:(UVInfoManager*)info_;

/** 用户退出
 
 @param BOOL auto_ 是否是自动退出 （自动退出一般是程序自动调用 如果是手动调用建议设置为NO）
 @see UVError
 */
- (void)logout:(BOOL)auto_;

/** 查询录像列表
 
 @param UVQueryReplayParam param_ 查询录像参数，请参考 UVQueryReplayParam 定义
 @return NSArray 返回UVRecordInfo记录，如果没有记录，则返回空数组
 @see UVQueryReplayParam
 @see UVError
 */
- (NSArray *)queryReplay:(UVQueryReplayParam*)para_;

/** 查询资源 这里主要指摄像机和组织
 
 @param UVQueryResourceParam param_ 查询资源参数，请参考 UVQueryResourceParam 定义
 @return NSArray 返回UVResourceInfo记录，如果没有记录，则返回空数组
 @see UVQueryResourceParam
 @see UVError
 */
- (NSArray *)queryResource:(UVQueryResourceParam*)para_;

/** 启动实况
 
 @param UVStartLiveParam param_ 播放实况参数，请参考 UVStartLiveParam 定义
 @return NSString 返回实况session
 @see UVStartLiveParam
 @see UVError
 */
- (NSString *)startLive:(UVStartLiveParam*)para_ withTimeOut:(NSTimeInterval)timeOut;

/** 启动回放
 
 @param UVStartReplayParam param_ 播放回放参数，请参考 UVStartReplayParam 定义
 @return NSString 返回回放session
 @see UVStartReplayParam
 @see UVError
 */
- (NSString *)startReplay:(UVStartReplayParam*)para_;

/** 查询回放进度
 
 @param UVGetReplayPosParam param_ 播放回放参数，请参考UVGetReplayPosParam定义
 @return NSString 如果成功返回当前回放的时间
 @see UVGetReplayPosParam
 @see UVError
 */
- (NSString *)getReplayPos:(NSString*)playSession_;

/**
 *  拖拽回放进度
 *
 *  @param playSession_  播放session
 *  @param playDatetime_ 回放时间
 */
- (void)dragReplay:(NSString *)playSession_ playDatetime:(NSString *)playDatetime_;

/** 停止实况
 
 @param NSString playSession_ 播放session
 @see UVError
 */
- (void)stopLive:(NSString*)playSession_;

/** 停止回放
 
 @param NSString playSession_ 播放session
 @see UVError
 */
- (void)stopReplay:(NSString*)playSession_;

/** 保活 手动保活时调用
 
 @see UVError
 */
- (void)keepAlive;

/** 获取告警推送 手动获取告警时调用
 注：获取告警会堵塞当前线程，请放在单独的线程中执行
 
 @param int32_t timeout_ 超时时间
 @return NSArray 返回UVPushMessageInfo列表
 @see UVError
 @see UVPushMessageInfo
 */
- (NSArray*)getPushMessages:(int32_t)timeout_;

/** 在当前线程中执行服务器请求 如果通信失败，则会抛出UVError异常 默认使用当前连接执行请求
 
 @param block 要执行请求代码
 */
- (void)execRequest:(void (^)())block_;

/** 在异步线程中执行服务器请求
 
 @param block 要执行请求代码
 @param block finish_ 请求结束后的执行的代码 如果请求产生错误 则error保存错误信息
 */
- (void)execRequest:(void (^)())block_ finish:(void (^)(UVError *error))finish_;

/** 创建通信连接 登录成功后则会自动创建一个连接
 
 */
- (void)disconnectClient:(TSocketClientEx **)transport_;

/** 关闭当前通信连接 退出登录则会自动关闭连接
 
 */
- (imosClient*)connectImosClient:(TSocketClientEx **)transport_;

/** 开启云台 在调用云台前需要调用这个开启摄像机云台控制
 *
 @param NSString cameraCode_ 摄像机编码
 *
 */
- (void)startCameraPtz:(NSString*)cameraCode_;

/** 关闭云台 摄像机云台不用了就调用这个函数关闭云台，不然可能会抢占这台摄像机，导致其他客户端调用该设备云台失败
 *
 @param NSString cameraCode_ 摄像机编码
 *
 */
- (void)stopCameraPtz:(NSString*)cameraCode_;

/** 发送云台命令 配置云台控制参数，主要有设备编码，方向参数和两个速度参数
 *
 @param UVPtzCommandParam param_ 云台控制参数
 *
 */
- (void)cameraPtzCommand:(UVPtzCommandParam*)param_;

/**
 *  设置预置位
 *
 *  @param cameraCode  摄像机编码
 *  @param presetInfo  预置位信息
 */
- (void)cameraSetPreset:(NSString *)cameraCode presetInfo:(UVPresetInfo *)presetInfo;

/**
 *  启用预置位
 *
 *  @param param       预置位信息
 */
- (void)cameraUsePreset:(UVPresetParam *)param;

/**
 *  删除预置位
 *
 *  @param param       预置位信息
 */
- (void)cameraDelPreset:(UVPresetParam *)param;

/**
 *  查询预置位列表
 *
 *  @param para_
 *
 *  @return 预置位列表
 */
- (NSMutableArray *)cameraQueryPresetList:(UVQueryPresetListParam *)para_;

/**
 *  锁定云台控制
 *
 *  @param cameraCode 摄像机编码
 */
- (void)cameraLockPtz:(NSString *)cameraCode;

/**
 *  解锁云台控制
 *
 *  @param cameraCode 摄像机编码
 */
- (void)cameraUnLockPtz:(NSString *)cameraCode;

@end