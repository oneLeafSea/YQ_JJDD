//
//  TCTollgateMgr.m
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/29.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCTollgateMgr.h"

#import "RTWSMsg.h"
#import <FMDB.h>
#import "RTBKMsg.h"
#import "RTWSMsgConstants.h"

#import "RTDYMsg.h"

@interface TCTollgateMgr()

@end

@implementation TCTollgateMgr


- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePushNotification:) name:kNotificationTollgatePush object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handlePushCtrollerNotification:) name:KNotificationTOllCtrollerPush object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hanlePushDYTollegate:) name:KNotificationDYTollegatePush object:nil];
        self.subcricbedDeivces = [[NSArray alloc] init];
    }
    return self;
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationTollgatePush object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KNotificationTOllCtrollerPush object:nil];
}

- (void)subscribeTollgateWithDevices:(NSArray *)devices
                               wsmgr:(RTWSMgr *)wsmgr
                          completion:(void(^)(id result, NSError *error))completion {
    __block NSMutableArray *deviceIds = [[NSMutableArray alloc] init];
    [devices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TVElecPoliceInfo *tg = obj;
        [deviceIds addObject:tg.deviceId];
    }];
    
    RTWSMsg *msg = [[RTWSMsg alloc] init];
    msg.topic = kTopicTollgateSelSvc;
    [msg addParamWithKey:@"ids" value:deviceIds];
    
    [wsmgr sendMsg:msg withCompletion:^(id result, NSError *error) {
        if (error == nil) {
            self.subcricbedDeivces = devices;
        }
        completion(result, error);
    }];
}

- (void)handlePushNotification:(NSNotification *)notification {
    RTWSMsg *msg = notification.object;
//    TCTollgateNotification *n = [[TCTollgateNotification alloc] initWithMsg:msg];
    NSArray *ns = [TCTollgateNotification notificationArray:msg];
    if ([self.delegate respondsToSelector:@selector(TCTollgateMgr:newPushNotifications:)]) {
        [self.delegate TCTollgateMgr:self newPushNotifications: ns];
    }
}
-(void)handlePushCtrollerNotification:(NSNotification*)notification{
   
    RTBKMsg*msg = notification.object;
    NSArray *ns = [TCTollgateNotification notificationArrayWithB_K:msg];
    if ([self.delegate respondsToSelector:@selector(TCTollgateBKMgr:newPushNotifications:)]) {
        [self.delegate TCTollgateBKMgr:self newPushNotifications: ns];
    }
}
-(void)hanlePushDYTollegate:(NSNotification*)notification{
    RTDYMsg *msg=notification.object;
    NSArray *ns=[TCDYNotificatin notificationArray:msg];
    if ([self.delegate respondsToSelector:@selector(TCTollgateDYMgr:newPushNotifications:)]) {
        [self.delegate TCTollgateDYMgr:self newPushNotifications: ns];
    }
}
- (void)addDeviece:(TVElecPoliceInfo *)epi wsmgr:(RTWSMgr *)wsmgr completion:(void(^)(id result, NSError *error))completion_ {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.subcricbedDeivces];
    //[arr addObject:epi];
    //NSLog(@"longlonglogng--- %@",arr);
    [self subscribeTollgateWithDevices:arr wsmgr:wsmgr completion:^(id result, NSError *error) {
        if (completion_) {
            completion_(result, error);
        }
    }];
}

- (void)removeDevice:(TVElecPoliceInfo *)epi wsmgr:(RTWSMgr *)wsmgr completion:(void(^)(id result, NSError *error))completion_ {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.subcricbedDeivces];
    [arr removeObject:epi];
    [self subscribeTollgateWithDevices:arr wsmgr:wsmgr completion:^(id result, NSError *error) {
        if (completion_) {
            completion_(result, error);
        }
    }];
}

@end
