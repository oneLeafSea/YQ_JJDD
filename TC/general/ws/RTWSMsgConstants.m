//
//  RTWSMsgConstants.m
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/26.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "RTWSMsgConstants.h"


NSString *const kTopicLogin = @"login";

NSString *const kTopicLogout = @"logout";

NSString *const kTopicApplyCtrl = @"apply_control";

NSString *const kTopicReplyCtrl = @"reply_control";

NSString *const kTopicPing = @"ping";

NSString *const kTopicKick = @"kick";

NSString *const kTopicTollgateSelSvc = @"tollgate_subscribe";
NSString *const kTopicTollgatePush = @"tollgate_push";
NSString *const kTopicTollgateBKPush = @"tollgate_push_alarm";
NSString *const kStatusSucess = @"1";
NSString *const kStatusFail = @"0";

NSString *const kDeviceIPad = @"iPad";


NSString *const kNotificationTollgatePush = @"cn.com.rooten.tollgate.push";

NSString *const KNotificationTOllCtrollerPush=@"cn.com.rooten.tollCtroller.push";
NSString *const KNotificationDYTollegatePush=@"cn.com.rooten.DYtollegate.push";