//
//  RTWSMsgConstants.h
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/26.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  消息的常量定义
 */

// ----------------Topic--------------------------

/**
 *  登陆
 */
extern NSString *const kTopicLogin;

/**
 *  登出
 */
extern NSString *const kTopicLogout;

/**
 *  申请控制
 */
extern NSString *const kTopicApplyCtrl;

/**
 *  申请控制的回应
 */
extern NSString *const kTopicReplyCtrl;


/**
 *  发起PING操作
 */
extern NSString *const kTopicPing;

/**
 *  踢掉的消息
 */
extern NSString *const kTopicKick;

/**
 *  订阅卡口信息
 */
extern NSString *const kTopicTollgateSelSvc;

extern NSString *const kTopicTollgatePush;


// ----------------status--------------------------

extern NSString *const kStatusSucess;
extern NSString *const kStatusFail;


// ----------------device--------------------------

extern NSString *const kDeviceIPad;


// ----------------notification--------------------------
/**
 *  卡口推送通知消息
 */
extern NSString *const kNotificationTollgatePush;
