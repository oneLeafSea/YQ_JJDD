//
//  TCTollgateMgr.h
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/29.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTWSMgr.h"
#import "TCTollgateNotification.h"
#import "TVElecPoliceInfo.h"


@protocol TCTollgateMgrDelegate;

@interface TCTollgateMgr : NSObject


/**
 *  订阅卡口设备
 *
 *  @param devices    TVElecPoliceInfo的数组
 *  @param wsmgr      websocket mgr
 *  @param completion 完成后调用
 */
- (void)subscribeTollgateWithDevices:(NSArray *)devices
                               wsmgr:(RTWSMgr *)wsmgr
                          completion:(void(^)(id result, NSError *error))completion;


- (void)addDeviece:(TVElecPoliceInfo *)epi wsmgr:(RTWSMgr *)wsmgr completion:(void(^)(id result, NSError *error))completion;
- (void)removeDevice:(TVElecPoliceInfo *)epi wsmgr:(RTWSMgr *)wsmgr completion:(void(^)(id result, NSError *error))completion;

@property(nonatomic, weak) id<TCTollgateMgrDelegate> delegate;

@property(nonatomic, strong) NSArray *subcricbedDeivces;

@end

@protocol TCTollgateMgrDelegate <NSObject>

- (void)TCTollgateMgr:(TCTollgateMgr *)tgMgr newPushNotifications:(NSArray *)notifications;

@end