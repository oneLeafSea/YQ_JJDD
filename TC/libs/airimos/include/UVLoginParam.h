// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVLoginParam.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:登录参数类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

#import <Foundation/Foundation.h>
/** 登录参数类
 
 主要在调用登录接口时使用，参考UVServiceManager方法：
    
        - (void)login:(UVLoginParam*)para_ listener:(void (^)(UVInfoManager* infomanage,UVError *error))block_;

 */
@interface UVLoginParam : NSObject
//登录密码 密码为密文 必要参数
@property(nonatomic,strong) NSString *password;
//通信端口 必要参数
@property(nonatomic,assign) int port;
//服务器地址 必要参数
@property(nonatomic,strong) NSString *server;
//登录用户名 必要参数
@property(nonatomic,strong) NSString *username;

@end
