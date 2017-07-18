//
//  TCLogin.h
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/26.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>
#import "RTWSMgr.h"

@interface TCLogin : NSObject

/**
 *  websocket登录接口
 *
 *  @param usr    用户名
 *  @param pwd    密码
 *  @param wsmgr  websocket mgr
 *  @param result block类型
 */

+ (void)loginWithUsr:(NSString *)usr
                 pwd:(NSString *)pwd
               wsmgr:(RTWSMgr *)wsmgr
          withResult:(void(^)(RTWSMsg * resp))result;
+(void)loginWithUsr:(NSString *)usr
                pwd:(NSString *)pwd ;
@end
