//
//  TCLogin.m
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/26.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCLogin.h"
#import "RTWSMsg.h"
#import "RTWSMsgConstants.h"

@implementation TCLogin

+ (void)loginWithUsr:(NSString *)usr
                 pwd:(NSString *)pwd
               wsmgr:(RTWSMgr *)wsmgr
          withResult:(void(^)(RTWSMsg * resp))result {
    RTWSMsg *msg = [[RTWSMsg alloc] init];
    msg.topic = kTopicLogin;
    [msg addParamWithKey:@"user" value:usr];
    [msg addParamWithKey:@"pwd" value:pwd];
    [msg addParamWithKey:@"device" value:kDeviceIPad];
    NSLog(@"%@",usr);
    [wsmgr sendMsg:msg withCompletion:^(id rt, NSError *error) {
        if (error == nil) {
            NSDictionary *dict = rt;
            RTWSMsg *r = [[RTWSMsg alloc] initWithDict:dict];
            result(r);
        } else {
            NSLog(@"%@", error);
            result(nil);
        }
    }];
}
+(void)loginWithUsr:(NSString *)usr
                pwd:(NSString *)pwd{
    
}
@end
