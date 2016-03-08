//
//  RTWSMgr.h
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/26.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>
#import "RTWSMsg.h"

@protocol RTWSMgrDelegate;

@interface RTWSMgr : NSObject

- (instancetype)initWithAddr:(NSString *)addr;

/**
 *  链接websocket服务器
 *
 *  @param completion 完成后调用
 */
- (void)connectWithCompletion:(void(^)(NSError* err))completion;

- (void)close;

/**
 *  发送消息不需要关注ack
 *
 *  @param msg 消息
 */

- (void)sendMsg:(RTWSMsg *)msg;

/**
 *  发送消息需要回应时调用此函数
 *
 *  @param msg        消息结构体
 *  @param completion 返回结构
 */

- (void)sendMsg:(RTWSMsg *)msg withCompletion:(void(^)(id result, NSError *error))completion;

@property(nonatomic, weak) id<RTWSMgrDelegate> delegate;

@end

@protocol RTWSMgrDelegate <NSObject>

- (void)RTWSMgr:(RTWSMgr *)wsMgr socketDidCloseWithReason:(NSString *)reason;

@end
