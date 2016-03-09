//
//  TCApplyReq.m
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/29.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCApplyReq.h"
#import "RTWSMsg.h"
#import "RTWSMsgConstants.h"

@implementation TCApplyReq

+ (void)ApplyCtrlWithWsmgr:(RTWSMgr *)wsmgr completion:(void(^)(RTWSMsg *msg, NSError *err))completion {
    RTWSMsg *msg = [[RTWSMsg alloc] init];
    msg.topic = kTopicApplyCtrl;
    [msg addParamWithKey:@"device" value:kDeviceIPad];
    [wsmgr sendMsg:msg withCompletion:^(id rt, NSError *error) {
        if (error == nil) {
            NSDictionary *dict = rt;
            RTWSMsg *r = [[RTWSMsg alloc] initWithDict:dict];
            if (completion) {
                completion(r, error);
            }
        } else {
            NSLog(@"%@", error);
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

@end
