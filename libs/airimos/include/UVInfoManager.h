// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVInfoManager.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:登录信息类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

//保活失败最大重试次数
#define KEEP_LIVE_MAX_FAILURE_NUM (8)
//保活间隔 单位：秒
#define KEEP_LIVE_INTVAL (5.0f)
#define RECEIVE_ALARM_TIMEOUT (10)
/** 登录信息类
 
 登录成功后，该类存放登录后的相关信息，也可以利用该类判断当前是否已经登录，示例代码：
 
        UVInfoManager *info = [UVInfoManager instance]
        if(!info.isLogin) UVLog("你还没有登录");
 */
@interface UVInfoManager : NSObject
//当前登录用户名
@property(nonatomic,strong) NSString *username;
//当前登录密码
@property(nonatomic,strong) NSString *password;
//当前登录服务器
@property(nonatomic,strong) NSString *server;
//当前用户会话session，服务器用来唯一区别用户会话连接
@property(nonatomic,strong) NSString *userSession;
//当前通信媒体端口
@property(nonatomic,assign) int mediaPort;
//当前通信端口，主要用于登录
@property(nonatomic,assign) int servicePort;
//摄像机端口，暂没有使用
@property(nonatomic,assign) int cameraPort;
//返回是否已经登录
@property(nonatomic,assign,readonly) BOOL isLogin;
//是否是自动登录或自动退出
@property(nonatomic,assign,readonly) BOOL isAutoLoginStatusChange;

@property(nonatomic,readonly) dispatch_queue_t keepLiveQueue;
@property(nonatomic,readonly) dispatch_queue_t receiveAlarmQueue;
//是否自动保活 默认为YES
@property(nonatomic) BOOL autoKeepLive;
//保活失败数量
@property(nonatomic) NSInteger keepLiveFailNum;
//是否接受告警 默认为NO
@property(nonatomic) BOOL receiveAlarm;

- (id)init;

/** 实例化对象
 
 建议在使用前，均调用此静态方法
 
 @return UVInfoManager
 */
+(UVInfoManager*)instance;

/** 设置当前登录状态
 
 @param BOOL login_ 是否登录
 @param BOOL auto_ 是否是自动登录或退出
 */
- (void)setLoginStatus:(BOOL)login_ autoLogin:(BOOL)auto_;
    
@end
